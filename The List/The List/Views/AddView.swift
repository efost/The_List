//
//  AddView.swift
//  The List
//
//  Created by Eric Foster on 9/5/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI
import CloudKit

struct AddView: View {
    @State private var inSF: Bool = true
    @State private var itemCategory: ListItem.Category = .none
    @State private var newItem = ListItem(name: "", address: "", city: "", category: ListItem.Category.none, done: false, notes: "")
    @State private var addLocation: Bool = false
    @State private var showingAlert: Bool = true
    @State private var backToList: Bool = false
    
//    init(){
//        UITableView.appearance().backgroundColor = .clear
//    }
    
    var body: some View {
        VStack {
            if (backToList) {
                ListItemList()
            } else {
                Text("Add it to The List").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Form {
                    Section {
                        TextField("Name/Title", text: $newItem.name)
                        Picker(selection: $itemCategory, label: Text("Category")) {
                            ForEach(ListItem.Category.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    }
                    Section {
                        Toggle(isOn: self.$addLocation) {
                            Text("Add location info?")
                        }
                        if (self.addLocation) {
                            TextField("What's the address?", text: $newItem.address ?? "")
                            Toggle(isOn: self.$inSF) {
                                Text("In San Francisco?")
                            }
                            if (!self.inSF) {
                                TextField("What city?", text: $newItem.city ?? "")
                            }
                        }
                    }
                    Section {
                        VStack {
                            TextField("Any notes to add?", text: $newItem.notes ?? "")
                        }
                    }
                    Section {
                        Button(action: {
                            self.newItem.category = self.itemCategory
                            self.newItem.city = self.inSF ? "San Francisco" : self.newItem.city
                            CloudKitHelper.save(item: self.newItem) { (result) in
                                switch result {
                                case .success:
                                    print("Successfully added item")
                                    self.newItem = ListItem(name: "", address: "", city: "", category: ListItem.Category.none, done: false, notes: "")
                                    self.backToList = true
                                    
                                case .failure(let err):
                                    print(err.localizedDescription)
                                }
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Submit")
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}


