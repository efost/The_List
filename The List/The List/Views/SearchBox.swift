//
//  SearchBox.swift
//  TheList
//
//  Created by Eric Foster on 9/7/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

struct SearchBox: View {
    @Binding var searchTerm: String
    
    @State private var isEditing = false
    
    func resetSearchBox() {
        self.searchTerm = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

    }
    
    var body: some View {
        HStack {
            TextField("Search The List...", text: $searchTerm)
                .padding(7)
                .padding(.horizontal, 12)
                .padding(.leading, 12)
                .background(Color(self.isEditing ? .white : .systemGray6))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray6), lineWidth: 1))
                .transition(.move(edge: .trailing))
                .animation(.default)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            Button(action: {
                                self.searchTerm = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            if (isEditing) {
                Button(action: {
                    self.isEditing = false
                    self.resetSearchBox()
                }) {
                    Text("Cancel")
                }.padding(.trailing, 10)
            }
        }.padding()
    }
}

struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        SearchBox(searchTerm: .constant(""))
    }
}
