//
//  MainViewModel.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/09.
//

import AppKit
import Magnet
import Vision

final class MainViewModel: ObservableObject {
    @Published
    var strs = [String]()

    init() {
        if let keyCombo = KeyCombo(key: .one, cocoaModifiers: [.command, .shift]) {
            let hotKey = HotKey(identifier: "CommandShiftOne", keyCombo: keyCombo) { _ in
                self.takeScreenshot()
            }
            hotKey.register()
        }
    }

    func takeScreenshot() {
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).png")
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "-r", path.path]
        task.launch()
        task.waitUntilExit()
        requestRecognizeText(with: path.path)
    }

    func requestRecognizeText(with urlPath: String) {
        let image = NSImage(contentsOfFile: urlPath)
        guard let cgImage = image?.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler(request:error:))
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US", "fr-FR", "it-IT", "de-DE", "es-ES", "pt-BR", "zh-Hans", "zh-Hant"]
        request.usesLanguageCorrection = true
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
            request.results as? [VNRecognizedTextObservation]
        else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }

        print(recognizedStrings)
        strs = recognizedStrings
    }
}