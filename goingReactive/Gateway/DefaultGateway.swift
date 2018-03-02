//
//  DefaultGateway.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 24/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import RxSwift

extension URLRequest {
    init<T>(resource: URLResource<T>) {
        self.init(url: resource.url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: resource.timeOut)
        self.httpMethod = resource.method.rawValue
    }
}

final class DefaultGateway: Gateway {

    // MARK: Session
    
    private lazy var sessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        return configuration
    }()
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: sessionConfiguration)
        return session
    }()
    
    // MARK: Public
    
    func request<T>(resource: URLResource<T>, completion: @escaping (Result<T>) -> Void) {
        let request = URLRequest(resource: resource)
        session.dataTask(with: request) { data, response, error in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                DispatchQueue.main.async {
                    if let results = resource.parse(json) {
                        completion(.success(results))
                    } else {
                        completion(.failure(GatewayError.unexpectedResponse))
                    }
                }
            } else {
                DispatchQueue.main.async {
                   completion(.failure(GatewayError.unableToReach))
                }
            }
            }
            .resume()
    }
}

extension DefaultGateway: ReactiveGateway {
    func request<T>(resource: URLResource<T>) -> Observable<T> {
        return Observable.create { [unowned self] observer -> Disposable in
            self.request(resource: resource) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
