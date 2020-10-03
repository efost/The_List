//
//  OptionalStringBinding.swift
//  TheList
//
//  Created by Eric Foster on 9/6/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
