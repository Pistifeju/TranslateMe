//
//  LanguagesView.swift
//  TranslateMe
//
//  Created by István Juhász on 2023. 03. 18..
//

import SwiftUI

struct LanguagesView: View {
    @StateObject private var controllerViewModel = LanguagesViewControllerViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        List {
            Section(header: Text("").font(.headline)) {
                LanguagesSearchBar(searchText: $searchText)
                    .cornerRadius(12)
    //                .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                    .onChange(of: searchText) { newValue in
                        controllerViewModel.updateFilteredCellViewModels(with: newValue)
                    }
            }
            
            Section(header: Text("Downloaded Languages").font(.headline)) {
                ForEach(controllerViewModel.filteredDownloadedCellViewModels, id: \.self) { viewModel in
                    HStack {
                        Text(viewModel.countryFlag)
                            .font(.title)
                        Text(viewModel.title)
                            .font(.title)
                        
                        Spacer()
                        
                        DeleteButtonView(cellViewModel: viewModel)
                    }
                }
            }
            
            Section(header: Text("Downloadable Languages").font(.headline)) {
                ForEach(controllerViewModel.filteredNotDownloadedCellViewModels, id: \.self) { viewModel in
                    HStack {
                        Text(viewModel.countryFlag)
                            .font(.title)
                        Text(viewModel.title)
                            .font(.title)
                        
                        Spacer()
                        
                        DownloadButtonView(cellViewModel: viewModel)
                    }
                }
            }
        }
    }
}

struct LanguagesView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagesView()
    }
}
