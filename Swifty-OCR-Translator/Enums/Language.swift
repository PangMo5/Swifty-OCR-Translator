//
//  Language.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2022/06/08.
//

import Foundation
import Defaults

enum Language: String, CaseIterable, DefaultsSerializable {
    case en
    case ko
    case ja
    case fr
    case it
    case de
    case es
    case pt
    case zh

    var toLocaleStrings: [String] {
        switch self {
        case .en:
            return ["en-US"]
        case .ko:
            return ["ko-KR"]
        case .ja:
            return ["ja-JP"]
        case .fr:
            return ["fr-FR"]
        case .it:
            return ["it-IT"]
        case .de:
            return ["de-DE"]
        case .es:
            return ["es-ES"]
        case .pt:
            return ["pt-BR"]
        case .zh:
            return ["zh-Hans", "zh-Hant"]
        }
    }

    var toLocalized: String {
        Locale.current.localizedString(forLanguageCode: rawValue) ?? "unknown"
    }
}
