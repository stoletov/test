//
//  GetNotesOperation.swift
//  SwiftLesson2
//
//  Created by Admin on 28.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import Foundation

class  GetNotesOperation: Operation {
    var data: Data?
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

    override func main() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://cRpquh6AL:e71c26be-fbc2-4ee5-888e-8eacb1ab6e32@scalr.api.appbase.io/myNotesBoard/note/_search")! as URL)
        request.httpMethod = "POST"
        
        let query = ["query" : ["match" : ["userID" : UserDefaults.standard.value(forKey: "UserIdentifier")!]]]
        request.httpBody = try! JSONSerialization.data(withJSONObject: query, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            self.data = data
            self.error = error
            print("GOT NOTES = \(data!)")
           
            self.isFinished = true
        }
        task.resume()
    }
    
}
