//
//  ListItemList.swift
//  The List
//
//  Created by Eric Foster on 9/5/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

struct ListItemList: View {
    @EnvironmentObject var listItems: ListItems
    var isPreview: Bool = false
    @State private var searchTerm = ""
    @State private var viewingDetail = false
    @State private var activeFilter: String = ""
    @State private var currentListItem = ListItem(name: "", address: "", city: "", category: ListItem.Category.none, done: false, notes: "")
    
    var body: some View {
        VStack {
            if (listItems.items.count > 0) {
                VStack {
                    SearchBox(searchTerm: $searchTerm)
                    CategoryFilters(activeFilter: $activeFilter)
                    Text(activeFilter == "" ? "Everything" : "\(activeFilter)s" ).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding()
                    ScrollView {
                        let filteredItems = self.listItems.items.filter({
                            searchTerm != "" ? $0.name.contains(searchTerm) &&
                                (activeFilter != "" ? $0.category.rawValue == activeFilter : true) : true && (activeFilter != "" ? $0.category.rawValue == activeFilter : true)
                        })
                        ForEach(filteredItems, id: \.self) { listItem in
                            ListItemRow(listItem: listItem).onTapGesture {
                                self.currentListItem = listItem
                                print("CLI", self.currentListItem)
                                self.viewingDetail = true
                            }
                        }
                    }.padding()
                }
                Spacer()
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            if (!self.isPreview){
                self.listItems.items.removeAll()
            }
            // MARK: - fetch from CloudKit
            CloudKitHelper.fetchAll { (result) in
                switch result {
                case .success(let newItem):
                    self.listItems.items.append(newItem)
                    print("Successfully fetched item")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }.sheet(isPresented: $viewingDetail) {
            ListItemDetail(listItem: self.$currentListItem)
        }
    }
}

struct ListItemList_Previews: PreviewProvider {
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
        done: true,
        notes: "This place sucks!"
    )
    
    static var previews: some View {
        let previewList = ListItems()
        previewList.items.append(previewListItem1)
        previewList.items.append(previewListItem2)
        
        return ListItemList(isPreview: true).environmentObject(previewList)
    }
}
