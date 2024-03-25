//
//  UIState.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

enum UIState<SuccessObject, FailureObject> {
    case success(SuccessObject)
    case loading
    case failure(FailureObject)
}
