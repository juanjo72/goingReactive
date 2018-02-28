//
//  App.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 24/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import UIKit

final class App {
    
    let gateway: Gateway
    
    lazy var rootNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       return navigationController
    }()
    
    // MARK: Lifecycle
    
    init(window: UIWindow, gateway: Gateway) {
        self.gateway = gateway
        window.rootViewController = rootNavigationController
    }
    
    // MARK: Public
    
    func launch() {
        showAllStationsController(on: rootNavigationController)
    }
    
    func showAllStationsController(on navigationController: UINavigationController) {
        let allStationsResource = BicingStation.allStations
        let viewModel = BicingStationsViewModel(resorce: allStationsResource, gateway: gateway)
        let allStationsVC = BicingStationsViiewController(viewModel: viewModel)
        navigationController.pushViewController(allStationsVC, animated: true)
    }
}
