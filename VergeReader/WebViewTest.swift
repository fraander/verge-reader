//
//  WebViewTest.swift
//  VergeReader
//
//  Created by Frank Anderson on 2/10/23.
//

import Foundation
import SwiftUI

// https://github.com/globulus/swiftui-webview

struct WebViewTest: View {
    @State private var action = WebViewAction.idle
    @State private var state = WebViewState.empty
    let address: String
    
    var body: some View {
        VStack {
            Text(address)
            WebView(action: $action,
                    state: $state,
                    restrictedPages: [])
            .task {
                if let url = URL(string: address) {
                    action = .load(URLRequest(url: url))
                }
            }
            .onChange(of: address) { newValue in
                if let url = URL(string: address) {
                    action = .load(URLRequest(url: url))
                }
            }
        }
    }
}
