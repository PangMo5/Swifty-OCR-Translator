//
//  GoogleTranslateModel.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/14.
//

import Foundation

enum GoogleTranslateAPIResponse {}

extension GoogleTranslateAPIResponse {
    struct Languages: Codable {
        var languages: [Language]
    }

    struct Detections: Codable {
        var detections: [Detection]
    }

    struct Translations: Codable {
        var translations: [Translation]
    }
}

extension GoogleTranslateAPIResponse {
    struct Language: Codable {
        var language: String
    }

    struct Detection: Codable {
        var confidence: Double
        var isReliable: Bool
        var language: String
    }

    struct Translation: Codable {
        var translatedText: String
    }
}
