//
//  Note.swift
//  SwiftLesson2
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    init?(JSON:Any)
}

public struct Note: JSONDecodable {
    public let text: String
    public let identifier: String
    public let userID: String
    
    public init(text: String, identifier: String, userID: String) {
        self.text = text
        self.identifier = identifier
        self.userID = userID
    }
    
    static func == (left: Note, right: Note) -> Bool {
        return left.identifier == right.identifier
    }
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else {return nil}
        
        guard let idn = JSON["_id"] as? String else {return nil}
        guard let text = JSON["_source"]?["notetext"] as? String else {return nil}
        guard let userID = JSON["_source"]?["userID"] as? String else {return nil}
        
        self.identifier = idn
        self.text = text
        self.userID = userID
    }
}

public struct Notes: JSONDecodable {
    let notes: [Note]
    
    public init(notes: [Note]) {
        self.notes = notes
    }
    init?(JSON:  Any) {
        guard let JSON = JSON as? [String: AnyObject] else {return nil}
        guard let hits = JSON["hits"]?["hits"] as? [AnyObject] else {return nil}
        
        var buffer = [Note]()
        for hitData in hits {
            if let hit = Note(JSON: hitData) {
                buffer.append(hit)
            }
        }
        
        self.notes = buffer
    }
}

