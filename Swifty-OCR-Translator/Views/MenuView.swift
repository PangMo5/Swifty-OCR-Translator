//
//  MenuView.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/09.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject
    var viewModel = MenuViewModel()

    var body: some View {
        if !viewModel.strs.isEmpty || !viewModel.translated.isEmpty {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Text("Source")
                        .font(.title)
                    Divider()
                    ForEach(viewModel.strs, id: \.self) {
                        Text($0)
                    }
                    Divider()
                    Text("Target")
                        .font(.title)
                    Divider()
                    ForEach(viewModel.translated, id: \.self) {
                        Text($0)
                    }
                    if let latestTranslator = viewModel.latestTranslator?.localized {
                        Text("Translated by \(latestTranslator)")
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top, 16)
                    }
                }
                .padding()
            }
        } else {
            Text("Capture image using [cmd + shift + 1]")
        }
    }
}
