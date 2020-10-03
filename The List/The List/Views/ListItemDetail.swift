//
//  ListItemDetail.swift
//  The List
//
//  Created by Eric Foster on 9/5/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI
import CloudKit

struct ListItemDetail: View {
    @Binding var listItem:ListItem
    @EnvironmentObject var listItems: ListItems
    
    @State private var itemDone: Bool = false
    @State private var editedItem = ListItem(name: "", address: "", city: "", category: ListItem.Category.none, done: false, notes: "")
        
    func updateDoneStatus() {
        self.itemDone.toggle()
        self.editedItem.done = self.itemDone
//        print("EDITED", self.editedItem)
        CloudKitHelper.modify(item: self.editedItem) { (result) in
            switch result {
            case .success(let item):
                print("Successfully modified item")
                for i in 0..<self.listItems.items.count {
                    let currentItem = self.listItems.items[i]
                    if currentItem.recordID == item.recordID {
                        self.listItems.items[i] = item
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
                Image("mauna-loa")
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .center, endPoint: .bottom))
                    )
                    .overlay(
                        VStack {
                            if (self.itemDone) {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                                            .font(Font.body.bold())
                                        Text("DONE!")
                                            .font(.caption)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 12)
                                    .padding(.top, 12)
                                    .foregroundColor(Color.white)
                                    .background(Color.green)
                                    .cornerRadius(4)
                                    .shadow(radius: 5)
                                    .onTapGesture(perform: updateDoneStatus)
                                }
                                .padding(.trailing, 0)
                                Spacer()
                            } else {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color.gray)
                                            .font(Font.body.bold())
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 13)
                                    .padding(.bottom, 12)
                                    .foregroundColor(Color.white)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .onTapGesture(perform: updateDoneStatus)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                    )
               
            VStack(alignment: .leading) {
                Text(self.editedItem.name)
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(alignment: .top) {
                    Text(self.editedItem.address!)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(self.editedItem.city!)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(self.editedItem.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, -80)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Notes")
                        .fontWeight(.bold)
                        .padding(.bottom, 6)
                    Divider()
                    Text(listItem.notes!)
                        .padding(.vertical)
                        .foregroundColor(Color(.systemGray))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .cornerRadius(4)
            }
            .frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
            )

        }
//        .environmentObject(listItems)
        .onAppear {
            CloudKitHelper.fetchOne(item: listItem) {
                (result) in
                    switch result {
                    case .success:
//                        print("SLID", listItem.done)
                        self.itemDone = listItem.done
                        self.editedItem = listItem
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
            }
        
        }
        
    }
    
}

struct ListItemDetail_Previews: PreviewProvider {
    static var previewListItem1 = ListItem(
        id: UUID(),
        recordID: nil,
        name: "Trader Vic's",
        address: "1234 Main St.",
        city: "San Francisco",
        category: ListItem.Category.bar,
        done: true,
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
        Group {
//            ListItemDetail(listItem: previewListItem1)
//            ListItemDetail(listItem: previewListItem2)
        }
    }
}
