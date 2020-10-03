//
//  ListItem.swift
//  The List
//
//  Created by Eric Foster on 9/5/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI
import CloudKit

struct ListItem: Hashable, Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String
    var address: String?
    var city: String?
    var category: Category
    var done: Bool
    var notes: String?
    
    enum Category: String, CaseIterable, Codable, Hashable {
        case none = "None"
        case bar = "Bar"
        case restaurant = "Restaurant"
        case hike = "Hike"
        case movietv = "Movie/TV"
        case experience = "Experience"
        case other = "Other"
    }
}
