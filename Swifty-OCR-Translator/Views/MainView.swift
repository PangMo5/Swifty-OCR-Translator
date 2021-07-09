//
//  ContentView.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/06.
//

import Defaults
import SwiftUI

struct MainView: View {
    @Default(.apiURL)
    var apiURL
    @Default(.apiKey)
    var apiKey

    var body: some View {
        Form {
            TextField("API URL", text: $apiURL)
            SecureField("API Key", text: $apiKey)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
