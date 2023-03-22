//
//  LanguagesView.swift
//  TranslateX
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
                        
                        DownloadButtonView(cellViewModel: viewModel, controllerViewModel: controllerViewModel)
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
