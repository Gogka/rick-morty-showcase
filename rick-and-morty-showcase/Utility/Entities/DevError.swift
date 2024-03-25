//
//  DevError.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

struct DevError: Error, LocalizedError {
    let description: String
    var errorDescription: String? { description }
    
    init(_ description: String) {
        self.description = description
    }
}
