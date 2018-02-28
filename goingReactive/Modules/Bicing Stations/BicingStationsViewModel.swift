//
//  BicingStationsViewModel.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 24/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import RxSwift
import RxCocoa

final class BicingStationsViewModel {
    
    // MARK: Injected
    
    var didLoadStations: (([BicingStation]) -> Void)?
    var didLoadError:  ((LocalizedError) -> Void)?
    var stations: [BicingStation] = []
    
    let resource: URLResource<[BicingStation]>
    let gateway: Gateway

    
    private var allStations: [BicingStation]? {
        didSet {
            guard let all = allStations else { return }
            stations = all
            didLoadStations?(all)
        }
    }
    
    // MARK: Lifecycle
    
    init(resorce: URLResource<[BicingStation]>, gateway: Gateway) {
        self.resource = resorce
        self.gateway = gateway
    }
    
    // MARK: Public
    
    func loadAllStations() {
        gateway.request(resource: resource) { result in
            switch result {
            case .success(let stations):
                self.allStations = stations
                break
            case .failure(let error):
                self.didLoadError?(error)
                break
            }
        }
    }
    
    func findStations(token: String) {
        guard let allStations = allStations else { return }
        let results = token.isEmpty  ? allStations : allStations.filter { $0.address.localizedCaseInsensitiveContains(token) }
        stations = results
        didLoadStations?(results)
    }
}
