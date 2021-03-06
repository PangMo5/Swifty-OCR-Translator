//
//  Swifty_OCR_TranslatorApp.swift
//  Swifty-OCR-Translator
//
//  Created by PangMo5 on 2021/07/06.
//

import SwiftUI

@main
struct Swifty_OCR_TranslatorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(minWidth: 300, idealWidth: 300, minHeight: 200, idealHeight: 200)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = MenuView()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 400, height: 400)

        let menuItem = NSMenuItem()
        menuItem.view = view

        let menu = NSMenu()
        menu.addItem(menuItem)

        statusItem?.menu = menu
        statusItem?.button?.image = NSImage(systemSymbolName: "mail.and.text.magnifyingglass", accessibilityDescription: nil)
        statusItem?.button?.image?.isTemplate = true

        NotificationCenter.default.addObserver(forName: .init(rawValue: "FinishedTranslate"), object: nil, queue: nil) { _ in
            self.statusItem?.menu?.popUp(positioning: menuItem,
                                         at: NSPoint(x: 0, y: self.statusItem?.button?.frame.height ?? 0),
                                         in: self.statusItem?.button)
        }
    }
}
