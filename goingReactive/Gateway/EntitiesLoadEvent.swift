//
//  EntitiesLoadEvent.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 28/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

enum EntitiesLoadEvent<T> {
    case loading
    case entities(T)
    case error(LocalizedError)
}
