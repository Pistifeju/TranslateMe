//
//  SettingsView.swift
//  TranslateX
//
//  Created by István Juhász on 2023. 03. 17..
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    @State private var isDarkModeOn: Bool
    
    private let viewModel: SettingsViewControllerViewModel
    
    init(viewModel: SettingsViewControllerViewModel) {
        self.viewModel = viewModel
        self.isDarkModeOn = UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                let width = UIScreen.main.bounds.width / 20
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: width)
                        .padding(10)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(8)
                }
                
                Text(viewModel.title)
                    .font(.title)
                    .padding(10)
                
                Spacer()
                
                if viewModel.type == .darkMode {
                    Spacer()
                    Toggle("", isOn: $isDarkModeOn)
                        .labelsHidden()
                        .onChange(of: isDarkModeOn) { value in
                            darkModeToggleChanged(isOn: value)
                        }
                }
            }
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
        .scrollDisabled(true)
    }
    
    private func darkModeToggleChanged(isOn: Bool) {
        if let currentWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            if isOn {
                currentWindow.overrideUserInterfaceStyle = .dark
            } else {
                currentWindow.overrideUserInterfaceStyle = .light
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init(cellViewModels: SettingsOption.allCases.compactMap({
            return SettingsCellViewModel(type: $0) { option in
                
            }
        })))
    }
}
