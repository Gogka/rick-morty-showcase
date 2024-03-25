//
//  Global.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

@discardableResult
func makeObject<Object>(_ initial: Object, _ maker: (Object) -> Void) -> Object {
    maker(initial)
    return initial
}
