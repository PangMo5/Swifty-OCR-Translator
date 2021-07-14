//
//  GoogleTranslateAPI.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/14.
//

import Defaults
import Foundation
import Moya

enum GoogleTranslateAPI {
    case detect(q: String)
    case translate(q: [String], target: String, source: String, format: String = "text")
    case supportedLanguages
}

extension GoogleTranslateAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://translation.googleapis.com")!
    }

    var path: String {
        switch self {
        case .detect:
            return "/language/translate/v2/detect"
        case .translate:
            return "/language/translate/v2"
        case .supportedLanguages:
            return "/language/translate/v2/languages"
        }
    }

    var method: Moya.Method {
        switch self {
        case .detect, .translate:
            return .post
        case .supportedLanguages:
            return .get
        }
    }

    var sampleData: Data {
        "{".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case let .detect(q):
            var parameters = [String: Any]()
            parameters["key"] = Defaults[.apiInfoDict][.google]?.key
            parameters["q"] = q
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .translate(q, target, source, format):
            var parameters = [String: Any]()
            parameters["key"] = Defaults[.apiInfoDict][.google]?.key
            parameters["q"] = q
            parameters["target"] = target
            parameters["source"] = source
            parameters["format"] = format
            return .requestParameters(parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets))
        case .supportedLanguages:
            var parameters = [String: Any]()
            parameters["key"] = Defaults[.apiInfoDict][.google]?.key
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
