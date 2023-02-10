//
//  ContentView.swift
//  VergeReader
//
//  Created by Frank Anderson on 2/9/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State var feed: V_Feed?
    @State var currentArticle: V_Entry?
    
    var body: some View {
        HStack {
            VStack {
                List(feed?.entries ?? [], id: \.id) { ve in
                    Button {
                        currentArticle = ve
                    } label: {
                        Text("\(ve.title)")
                    }
                }
                .listStyle(.sidebar)
            }
            
            VStack {
                if let ve = currentArticle {
                    WebViewTest(address: ve.id)
                }
            }
        }
        .navigationTitle(feed?.title ?? "Loading...")
        .toolbar {
            Button(action: load) {
                Label("Reload", systemImage: "arrow.counterclockwise")
            }
            
        }
        .padding()
        .task { load() }
    }
    
    func load() {
        Task {
            feed = try await FeedLoader.loadXMLFromRSS()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
