//
//  ListItems.swift
//  TheList
//
//  Created by Eric Foster on 9/6/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

class ListItems: ObservableObject {
    @Published var items: [ListItem] = []
}
