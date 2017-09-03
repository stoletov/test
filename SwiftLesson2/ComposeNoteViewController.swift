//
//  ComposeNoteViewController.swift
//  SwiftLesson2
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import UIKit

class ComposeNoteViewController: UIViewController {
    
    public var dataController:DataController!
    
    public var note:Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let note = self.note {
            noteText.text = note.text
        }
    }

    @IBOutlet weak var noteText: UITextView!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if noteText.text.characters.count > 0 {
            let task:NoteModificationTask
            var currentNote:Note
            if let note = self.note {
                task = .edit
                currentNote = Note(text: noteText.text, identifier: note.identifier, userID: note.userID)
            } else {
                task = .create
                currentNote = Note(text: noteText.text, identifier: "", userID: "")
            }
            
            dataController.modify(note: currentNote, task: task)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
