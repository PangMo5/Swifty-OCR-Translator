//
//  MenuViewModel.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/09.
//

import AppKit
import Combine
import CombineMoya
import Defaults
import LanguageTranslatorV3
import Magnet
import Moya
import Vision

final class MenuViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    fileprivate var googleTranslateProvider = MoyaProvider<GoogleTranslateAPI>()

    @Published
    var strs = [String]()
    @Published
    var translated = [String]()

    init() {
        if let keyCombo = KeyCombo(key: .one, cocoaModifiers: [.command, .shift]) {
            let hotKey = HotKey(identifier: "CommandShiftOne", keyCombo: keyCombo) { _ in
                self.takeScreenshot()
            }
            hotKey.register()
        }
    }

    fileprivate func takeScreenshot() {
        let path = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).png")
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "-r", path.path]
        task.launch()
        task.waitUntilExit()
        requestRecognizeText(with: path.path)
    }

    fileprivate func requestRecognizeText(with urlPath: String) {
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

    fileprivate func recognizeTextHandler(request: VNRequest, error: Error?) {
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
        translate(textList: strs)
    }

    fileprivate func translate(textList: [String]) {
        switch Defaults[.selectedTranslator] {
        case .ibm:
            translateWithIBM(textList: textList)
        case .google:
            translateWithGoogle(textList: textList)
        }
    }

    fileprivate func translateWithIBM(textList: [String]) {
        let authenticator = WatsonIAMAuthenticator(apiKey: Defaults[.apiInfoDict].current.key)
        let languageTranslator = LanguageTranslator(version: "2018-05-01", authenticator: authenticator)
        languageTranslator.serviceURL = Defaults[.apiInfoDict].current.url

        languageTranslator
            .translate(text: textList,
                       modelID: "\(Defaults[.selectedSourceLanuage])-\(Defaults[.selectedTargetLanuage])") { [weak self] response, error in

                guard let translation = response?.result else {
                    print(error?.localizedDescription ?? "unknown error")
                    return
                }

                DispatchQueue.main.async {
                    self?.translated = translation.translations.map(\.translation)
                    self?.finishedTranslate()
                }
                print(translation)
            }
    }

    fileprivate func translateWithGoogle(textList: [String]) {
        googleTranslateProvider
            .requestPublisher(.translate(q: textList, target: Defaults[.selectedTargetLanuage], source: Defaults[.selectedSourceLanuage]))
            .map(GoogleTranslateAPIResponse.Translations.self, atKeyPath: "data")
            .print()
            .replaceError(with: .init(translations: []))
            .map {
                $0.translations.map(\.translatedText)
            }
            .sink(receiveValue: { [weak self] response in
                self?.translated = response
                self?.finishedTranslate()
            })
            .store(in: &cancellables)
    }
    
    func finishedTranslate() {
        NotificationCenter.default.post(name: .init(rawValue: "FinishedTranslate"), object: nil)
    }
}
