//
//  ContentView.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/06.
//

import SwiftUI

struct MainView: View {
    @StateObject
    var viewModel = MainViewModel()

    var body: some View {
        VStack {
            ForEach(viewModel.strs, id: \.self) {
                Text($0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
