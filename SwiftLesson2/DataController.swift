//
//  DataController.swift
//  SwiftLesson2
//
//  Created by Admin on 26.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import Foundation

enum NoteModificationTask {
    case create
    case edit
    case delete
}

protocol DataControllerDelegate {
    func dataSourceChange(dataSource:[Note]?, error:Error?)
}

class DataController {
    var notes:[Note] = []
    
    var delegate:DataControllerDelegate?
    
    var modifyNotesQueue = OperationQueue()
    
    var getNotesQuery = OperationQueue()
    
    func getNotes() {
        let fetchNotes = GetNotesOperation()
        let parseNotesOperation = ParseNotesJSONoperation()
        let adapterOperation = BlockOperation {
            parseNotesOperation.data = fetchNotes.data
            parseNotesOperation.error = fetchNotes.error
        }
        
        let finishOperation = BlockOperation {
            if let notes = parseNotesOperation.notes {
                print("finished")
                print(notes)
                self.notes = notes
                self.delegate?.dataSourceChange(dataSource: self.notes, error: nil)
            }
        }
        
        adapterOperation.addDependency(fetchNotes)
        parseNotesOperation.addDependency(adapterOperation)
        finishOperation.addDependency(parseNotesOperation)
        
        getNotesQuery.addOperations([fetchNotes, adapterOperation, parseNotesOperation, finishOperation], waitUntilFinished: true)
        
    }
    
    func modify(note:Note, task:NoteModificationTask) {
       
        switch task {
        case .create:
            notes.append(note)
            break
        case .edit:
            if let index = notes.index(where: {$0 == note}) {
                notes[index] = note
            }
            break
        case .delete:
            if let index = notes.index(where: {$0 == note}) {
                notes.remove(at: index)
            }
            break
            }
        
        
        self.delegate?.dataSourceChange(dataSource: notes, error: nil)
        let modification = ModifyNoteOperation(note: note, task: task)
        modifyNotesQueue.addOperation(modification)
        
    }
}
