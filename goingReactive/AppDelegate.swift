//
//  AppDelegate.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 24/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var gateway: Gateway & ReactiveGateway = {
       return DefaultGateway()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let app = App(window: window, gateway: gateway)
        app.launch()
        window.makeKeyAndVisible()
        return true
    }
}

