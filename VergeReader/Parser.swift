//
//  Parser.swift
//  VergeReader
//
//  Created by Frank Anderson on 2/9/23.
//

import Foundation

extension String: Error {}

struct FeedLoader {
    static func loadXMLFromRSS() async throws -> V_Feed {
        guard let url = URL(string: "https://www.theverge.com/rss/index.xml") else { throw URLError(.badURL) }
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let xmlParser = XMLParser(data: data)
        let parser = Parser()
        xmlParser.delegate = parser
        xmlParser.parse()
        
        guard let p = parser.feed else {
            throw "Could not decode XML"
        }
        
        return p
    }
}

class Parser: NSObject, XMLParserDelegate {
    var feed: V_Feed?
    var currentElement = ""
    
    init(feed: V_Feed? = nil, currentElement: String = "") {
        self.feed = feed
        self.currentElement = currentElement
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "feed" {
            feed = V_Feed()
        } else if (currentElement == "title") {
            if (feed?.title.isEmpty ?? false) && !string.isEmpty {
                feed?.title = string
            } else if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                feed?.entries.last?.title = string
            }
        } else if (currentElement == "entry") {
            feed?.entries.append(V_Entry())
        } else if (currentElement == "published") {
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                feed?.entries.last?.published = string
            }
        } else if (currentElement == "updated") {
            if (feed?.updated.isEmpty ?? false) && !string.isEmpty {
                feed?.updated = string
            } else if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                feed?.entries.last?.updated = string
            }
        } else if (currentElement == "id") {
            if (feed?.id.isEmpty ?? false) && !string.isEmpty {
                feed?.id = string
            } else if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                feed?.entries.last?.id = string
            }
        } else if (currentElement == "link") {
            if (feed?.link.isEmpty ?? false) && !string.isEmpty {
                feed?.link = string
            } else if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                feed?.entries.last?.link = string
            }
        } else if (currentElement == "author") {
            feed?.entries.last?.author.append(V_Author())
        } else if (currentElement == "name") {
            if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                feed?.entries.last?.author.last?.name = string
            }
        } else if (currentElement == "content") {
            feed?.entries.last?.content += string
        } else if (currentElement == "icon") {
            // do nothing
        } else {
            print(currentElement, string)
        }
        
    }
}
