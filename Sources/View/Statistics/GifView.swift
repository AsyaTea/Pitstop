//
//  GifView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/06/22.
//

import SwiftUI
import WebKit

// swiftlint:disable force_try

struct GifView: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context _: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        uiView.reload()
    }
}
