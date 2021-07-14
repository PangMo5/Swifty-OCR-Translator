//
//  ContentView.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/06.
//

import Defaults
import SwiftUI

struct MainView: View {
    @StateObject
    var viewModel = MainViewModel()
    @Default(.selectedSourceLanuage)
    var selectedSourceLanuage
    @Default(.selectedTargetLanuage)
    var selectedTargetLanuage
    @Default(.selectedTranslator)
    var selectedTranslator
    @Default(.apiInfoDict)
    var apiInfoDict

    var body: some View {
        Form {
            Picker("Source Language", selection: $selectedSourceLanuage) {
                ForEach(viewModel.supportedOCRLanguages, id: \.self) {
                    Text($0.toLocalized)
                        .tag($0)
                }
            }
            Picker("Target Language", selection: $selectedTargetLanuage) {
                ForEach(viewModel.supportedTargetLanuages, id: \.self) {
                    Text($0.toLocalized)
                        .tag($0)
                }
            }
            Picker("Translator", selection: $selectedTranslator) {
                ForEach(Translator.allCases, id: \.self) {
                    Text($0.localized)
                        .tag($0)
                }
            }
            if selectedTranslator.requierdFields.contains(.url) {
                TextField("API URL", text: $apiInfoDict.current.url)
            }
            if selectedTranslator.requierdFields.contains(.key) {
                SecureField("API Key", text: $apiInfoDict.current.key)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
