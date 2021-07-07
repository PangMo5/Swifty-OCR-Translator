//
//  ContentView.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/06.
//

import AppKit
import SwiftUI
import Vision

struct MainView: View {
    @State
    var strs = [String]()

    var body: some View {
        VStack {
            Button {
                guard let cgImage = NSImage(named: "imageC")?.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
                // Create a new image-request handler.
                let requestHandler = VNImageRequestHandler(cgImage: cgImage)

//            // Create a new request to recognize text.
                let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler(request:error:))
                request.recognitionLevel = .accurate
                request.recognitionLanguages = ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant"]
                request.usesLanguageCorrection = true
                do {
                    // Perform the text-recognition request.
                    print(try request.supportedRecognitionLanguages())
                    try requestHandler.perform([request])
                } catch {
                    print("Unable to perform the requests: \(error).")
                }
            } label: {
                Text("Detect")
                    .padding()
            }
            ForEach(strs, id: \.self) {
                Text($0)
            }
        }
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
            request.results as? [VNRecognizedTextObservation]
        else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            observation.topCandidates(1).first?.string
        }

        print(recognizedStrings)
        // Process the recognized strings.
        strs = recognizedStrings
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
