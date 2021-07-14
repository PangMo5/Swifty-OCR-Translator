//
//  MainViewModel.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/14.
//

import Combine
import CombineMoya
import Defaults
import Foundation
import LanguageTranslatorV3
import Moya

final class MainViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    fileprivate var googleTranslateProvider = MoyaProvider<GoogleTranslateAPI>()

    @Published
    var supportedOCRLanguages = ["en", "fr", "it", "de", "es", "pt", "zh"]
    @Published
    var supportedTargetLanuages = [String]()

    init() {
        Defaults.publisher(.selectedTranslator)
            .map(\.newValue)
            .sink(receiveValue: updateTargetLanuages(with:))
            .store(in: &cancellables)
        updateTargetLanuages(with: Defaults[.selectedTranslator])
    }

    func updateTargetLanuages(with translator: Translator) {
        switch translator {
        case .ibm:
            let authenticator = WatsonIAMAuthenticator(apiKey: Defaults[.apiInfoDict].current.key)
            let languageTranslator = LanguageTranslator(version: "2018-05-01", authenticator: authenticator)
            languageTranslator.serviceURL = Defaults[.apiInfoDict].current.url
            languageTranslator.listLanguages { [weak self] response, error in

                guard let supportedLanuages = response?.result else {
                    print(error?.localizedDescription ?? "unknown error")
                    return
                }

                DispatchQueue.main.async {
                    self?.supportedTargetLanuages = supportedLanuages.languages.compactMap(\.language)
                        .sorted(by: { $0.toLocalized < $1.toLocalized })
                }
            }
        case .google:
            googleTranslateProvider.requestPublisher(.supportedLanguages)
                .map(GoogleTranslateAPIResponse.Languages.self, atKeyPath: "data")
                .map {
                    $0.languages.map(\.language).sorted(by: { $0.toLocalized < $1.toLocalized })
                }
                .replaceError(with: [])
                .assign(to: \.supportedTargetLanuages, on: self)
                .store(in: &cancellables)
        }
    }
}

extension String {
    var toLocalized: String {
        Locale.current.localizedString(forLanguageCode: self) ?? "unknown"
    }
}
