//
//  URLResource.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 25/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct URLResource<T> {
    var url: URL
    var method: HttpMethod
    var params: [String: Any]?
    let timeOut: TimeInterval
    var parse: (Any) -> T?
}

extension URLResource {
    init(url: URL, parse: @escaping (Any) -> T?) {
        self.init(url: url, method: .get, params: nil, timeOut: TimeInterval.shortTimeout, parse: parse)
    }
}

