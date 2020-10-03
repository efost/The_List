//
//  ListView.swift
//  The List
//
//  Created by Eric Foster on 9/5/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listItems: ListItems
    
    var body: some View {
        ListItemList()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previewListItem1 = ListItem(
        id: UUID(),
        recordID: nil,
        name: "Trader Vic's",
        address: "1234 Main St.",
        city: "San Francisco",
        category: ListItem.Category.bar,
        done: false,
        notes: "This place rules!"
    )
    
    static var previewListItem2 = ListItem(
        id: UUID(),
        recordID: nil,
        name: "San Tung",
        address: "9999 Sunset St.",
        city: "San Francisco",
        category: ListItem.Category.bar,
        done: false,
        notes: "This place sucks!"
    )
    static var previews: some View {
        let previewList = ListItems()
        previewList.items.append(previewListItem1)
        previewList.items.append(previewListItem2)
        return ListView().environmentObject(previewList)
    }
}
