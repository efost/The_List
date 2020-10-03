//
//  ListItemRow.swift
//  The List
//
//  Created by Eric Foster on 9/5/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

struct ListItemRow: View {
    var listItem: ListItem
    
    var body: some View {
        HStack {
            Text(listItem.name)
                .strikethrough(listItem.done)
                .foregroundColor(listItem.done ? Color(.systemGray2) : Color(.black))
            
            Spacer()
        }
//        .overlay(
//            HStack {
//                Image(systemName: "checkmark.square.fill").foregroundColor(Color(listItem.done ? .systemGray5 : .clear)).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                Spacer()
//            }
//        )
        .padding(.vertical, 10)
        Divider()
            .padding(0)
    }
}

struct ListItemRow_Previews: PreviewProvider {
    static var listItem1 = ListItem(
        id: UUID(),
        recordID: nil,
        name: "Trader Vic's",
        address: "1234 Main St.",
        city: "San Francisco",
        category: ListItem.Category.bar,
        done: true,
        notes: "This place rules!"
    )
    static var listItem2 = ListItem(
        id: UUID(),
        recordID: nil,
        name: "Trader Vic's",
        address: "1234 Main St.",
        city: "San Francisco",
        category: ListItem.Category.bar,
        done: false,
        notes: "This place rules!"
    )
    static var previews: some View {
        Group {
            ListItemRow(listItem: listItem1)
            ListItemRow(listItem: listItem2)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
