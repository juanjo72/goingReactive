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
    
    let resource: URLResource<[BicingStation]>
    let gateway: Gateway
    
    // MARK: Observables
    
    let stations = Variable<[BicingStation]?>(nil)
    let error =  Variable<LocalizedError?>(nil)
    
    private var allStations: [BicingStation]? {
        didSet {
            guard let all = allStations else { return }
            stations.value = all
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
                self.error.value = error
                break
            }
        }
    }
    
    func findStations(token: String) {
        guard let allStations = allStations else { return }
        stations.value = token.isEmpty  ? allStations : allStations.filter { $0.address.localizedCaseInsensitiveContains(token) }
    }
}
