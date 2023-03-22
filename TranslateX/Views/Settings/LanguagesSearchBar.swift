//
//  LanguagesSearchBar.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 18..
//

import SwiftUI

struct LanguagesSearchBar: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: 0, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            
            TextField("Search language", text: $searchText)
                .padding(12)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.searchText = ""
                        self.isEditing = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .padding(.trailing, 16)
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct LanguagesSearchBar_Previews: PreviewProvider {
    static var searchText = Binding<String>(get: { "" }, set: { _ in })
    
    static var previews: some View {
        LanguagesSearchBar(searchText: searchText)
    }
}

