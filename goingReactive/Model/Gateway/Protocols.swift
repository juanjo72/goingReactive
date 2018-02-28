//
//  Protocols.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 26/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import RxSwift

typealias JSONDictionary = [String: Any]

protocol Gateway {
    func request<T>(resource: URLResource<T>, completion: @escaping (Result<T>) -> Void)
}

protocol ReactiveGateway {
    func request<T>(resource: URLResource<T>) -> Observable<T>
}
