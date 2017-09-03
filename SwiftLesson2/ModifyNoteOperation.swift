//
//  ModifyNoteOperation.swift
//  SwiftLesson2
//
//  Created by Admin on 27.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import Foundation

class ModifyNoteOperation: Operation {
    let modification: NoteModificationTask
    let note: Note
    
    var error: Error?
    
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
    
    init(note: Note, task: NoteModificationTask) {
        self.note = note
        self.modification = task
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        let requestMethod: String
        let identifier: String
        let requestData: Data?
        
        switch modification {
        case .create:
            requestMethod = "PUT"
            identifier = UUID().uuidString
            let note = ["notetext": self.note.text, "userID": UserDefaults.standard.value(forKey: "UserIdentifier")]
            requestData = try! JSONSerialization.data(withJSONObject: note, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            break
        case .edit:
            requestMethod = "PUT"
            identifier = self.note.identifier
            let note = ["notetext": self.note.text, "userID": UserDefaults.standard.value(forKey: "UserIdentifier")]
            requestData = try! JSONSerialization.data(withJSONObject: note, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            break
        case .delete:
            requestMethod = "Delete"
            identifier = self.note.identifier
            requestData = nil
            break
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://cRpquh6AL:e71c26be-fbc2-4ee5-888e-8eacb1ab6e32@scalr.api.appbase.io/myNotesBoard/note/\(identifier)")! as URL)
        request.httpBody = requestData
        request.httpMethod = requestMethod
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(deta, response, error) in
            do {
                let str = try JSONSerialization.jsonObject(with: deta!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as! [String: AnyObject]
                print(str)
            } catch {
                print("json parse error: \(error)")
            }
            self.isFinished = true
        }
        task.resume()
    }
    
}
