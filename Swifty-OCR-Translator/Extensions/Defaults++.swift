//
//  Defaults++.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/09.
//

import Defaults

extension Defaults.Keys {
    static let selectedSourceLanuage = Key<String>("selectedSourceLanuage", default: "")
    static let selectedTargetLanuage = Key<String>("selectedTargetLanuage", default: "")
    static let selectedTranslator = Key<Translator>("selectedTranslator", default: .allCases.first!)
    static let apiInfoDict = Key<[Translator: APIInfo]>("apiInfoDict", default: [:])
}
