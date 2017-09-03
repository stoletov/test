//
//  ParseNotesOperation.swift
//  SwiftLesson2
//
//  Created by Admin on 28.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import Foundation

class ParseNotesJSONoperation: Operation {
    var data: Data?
    var error: Error?
    var notes:[Note]?
    
    var currentState: Bool = false
    
    override var isFinished: Bool {
        get {
            return currentState
        }
        set (newValue) {
            willChangeValue(forKey: "isFinished")
            currentState = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let responseData = data
            else {
                print("parse notes failed")
                return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                if let notes = Notes(JSON: json){
                    self.notes = notes.notes
                }
                
            }
        } catch {
            print("json error: \(error)")
        }
        self.isFinished = true
        
    }
}

