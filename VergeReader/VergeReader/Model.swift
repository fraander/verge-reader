//
//  Model.swift
//  VergeReader
//
//  Created by Frank Anderson on 2/9/23.
//

import Foundation

class V_Feed: Hashable, Equatable, Identifiable {
    static func == (lhs: V_Feed, rhs: V_Feed) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var title: String
    var updated: String
    var link: String
    var id: String
    var entries: [V_Entry]
    
    init(title: String = "", id: String = "", link: String = "", entries: [V_Entry] = [], updated: String = "") {
        self.title = title
        self.entries = entries
        self.updated = updated
        self.link = link
        self.id = id
    }
}

class V_Entry: Hashable, Equatable, Identifiable {
    static func == (lhs: V_Entry, rhs: V_Entry) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var published: String
    var updated: String
    var title: String
    var content: String
    var link: String
    var id: String
    var author: [V_Author]
    
    init(
        published: String = "",
        updated: String = "",
        title: String = "",
        content: String = "",
        id: String = "",
        link: String = "",
        author: [V_Author] = []
    ) {
        self.published = published
        self.updated = updated
        self.title = title
        self.content = content
        self.id = id
        self.link = link
        self.author = author
    }
}

class V_Author: Hashable, Equatable, Identifiable {
    static func == (lhs: V_Author, rhs: V_Author) -> Bool {
        lhs.name == rhs.name
    }
    
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(name: String = "") {
        self.name = name
    }
}
