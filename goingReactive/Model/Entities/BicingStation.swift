//
//  BicingStation.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 24/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

struct BicingStation {
    var address: String
}

extension BicingStation {
    init?(json: JSONDictionary) {
        guard let street = json["streetName"] as? String
            ,let number = json["streetNumber"] as? String
            else { return nil }
        self.address = street + ", " + number
    }
}

extension BicingStation {
    static var allStations: URLResource<[BicingStation]> {
        let url = URL(string: "http://wservice.viabicing.cat/v2/stations")!
        return URLResource<[BicingStation]>(url: url) { response in
            guard let json = response as? JSONDictionary,
                let stations = json["stations"] as? [JSONDictionary] else { return nil }
            return stations.flatMap(BicingStation.init)
        }
    }
}
