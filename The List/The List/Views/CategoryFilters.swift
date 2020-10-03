//
//  CategoryFilters.swift
//  The List
//
//  Created by Eric Foster on 9/19/20.
//  Copyright © 2020 Eric Foster. All rights reserved.
//

import SwiftUI

struct CategoryFilters: View {
    @Binding var activeFilter: String
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                self.activeFilter = "Restaurant"
            }) {
                VStack {
                    Text("R").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .foregroundColor(self.activeFilter == "Restaurant" ? .white : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width: 40, height: 40)
                .background(
                    Color(self.activeFilter ==
                                    "Restaurant" ? .systemBlue : .clear)
                )
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue)
                )
            }
            
            Button(action: {
                self.activeFilter = "Bar"
            }) {
                VStack {
                    Text("B").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .foregroundColor(self.activeFilter == "Bar" ? .white : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width: 40, height: 40)
                .background(
                    Color(self.activeFilter ==
                                    "Bar" ? .systemBlue : .clear)
                )
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue)
                )
            }
            
            Button(action: {
                self.activeFilter = "Hike"
            }) {
                VStack {
                    Text("H").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .foregroundColor(self.activeFilter == "Hike" ? .white : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width: 40, height: 40)
                .background(
                    Color(self.activeFilter ==
                                    "Hike" ? .systemBlue : .clear)
                )
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue)
                )
            }
            
            Button(action: {
                self.activeFilter = ""
            }) {
                VStack {
                    Text("A").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .foregroundColor(self.activeFilter == "" ? .white : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .frame(width: 40, height: 40)
                .background(
                    Color(self.activeFilter ==
                                    "" ? .systemBlue : .clear)
                )
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue)
                )
            }
        }
    }
}

struct CategoryFilters_Previews: PreviewProvider {
    @State static var activeFilter: String = ""
    static var previews: some View {
        CategoryFilters(activeFilter: $activeFilter )
    }
}
