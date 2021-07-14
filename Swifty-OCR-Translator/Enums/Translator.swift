//
//  Translator.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/14.
//

import Defaults
import Foundation

enum Translator: String, Codable, CaseIterable, LosslessStringConvertible, DefaultsSerializable {
    enum Field {
        case url
        case key
    }

    case ibm
    case google

    init?(_ description: String) {
        self.init(rawValue: description)
    }

    var description: String {
        rawValue
    }

    var localized: String {
        switch self {
        case .ibm:
            return "IBM Watson"
        case .google:
            return "Google Cloud"
        }
    }

    var requierdFields: [Field] {
        switch self {
        case .ibm:
            return [.url, .key]
        case .google:
            return [.key]
        }
    }
}
