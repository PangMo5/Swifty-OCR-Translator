//
//  APIInfo.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/14.
//

import Defaults
import Foundation

struct APIInfo: Codable, DefaultsSerializable {
    var url: String
    var key: String
}

extension Dictionary where Key == Translator, Value == APIInfo {
    var current: APIInfo {
        get {
            self[Defaults[.selectedTranslator]] ?? .init(url: "", key: "")
        }
        set {
            self[Defaults[.selectedTranslator]] = newValue
        }
    }
}
