//
//  ReactiveBicingViewModel.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 28/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import RxSwift
import RxCocoa

final class ReactiveBicingViewModel {
    
    let stations: Driver<[BicingStation]>
    let isLoading: Driver<Bool>
    let error: Driver<LocalizedError>
    
    private let allStations: Driver<[BicingStation]>
    
    // MARK: Lifecycle
    
    init(allResource: URLResource<[BicingStation]>,
         gateway: ReactiveGateway,
         refreshDriver: Driver<Void>,
         searchDriver: Driver<String>) {
        // sequence of gateway events
        let loadEventsDriver  = refreshDriver
            .startWith(())
            .flatMapLatest { _ -> Driver<EntitiesLoadEvent<[BicingStation]>> in
                return gateway.request(resource: allResource)
                .map { .entities($0) }
                .asDriver(onErrorJustReturn: .error(GatewayError.unableToReach))
                .startWith(.loading)
        }
        // sequence with all stations
        allStations = loadEventsDriver
            .map { event -> [BicingStation]? in
                switch event {
                case .entities(let stations):
                    return stations
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
        // search with rebound
        let controlSearch = searchDriver
            .debounce(0.5)
            .distinctUntilChanged()
            .startWith("")
        // sequence combining search and all stations returning search result
        stations = Driver.combineLatest(controlSearch, allStations) { token, stations -> [BicingStation] in
            guard !token.isEmpty else { return stations }
            return stations.filter { $0.address.contains(token) }
        }
        // sequence of gateway loading statis
        isLoading = loadEventsDriver
            .map { event in
                switch event {
                case .loading:
                    return true
                default:
                    return false
                }
        }
        // sequence of gateway errors
        error = loadEventsDriver
            .map { event in
                switch event {
                case .error(let error):
                    return error
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
}
