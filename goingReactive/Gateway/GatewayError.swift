//
//  GatewayError.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 26/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

enum GatewayError: LocalizedError {
    case unexpectedResponse
    case unableToReach
    
    var errorDescription: String? {
        switch self {
        case .unexpectedResponse:
            return "Unexpected response"
        case .unableToReach:
            return "Unable to Reach"
        }
    }
}
