//
//  URLRequest+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

extension URLRequest {
    enum Method: String {
        case get = "GET"
    }
    
    mutating func setMethod(_ method: Method) {
        httpMethod = method.rawValue
    }
}
