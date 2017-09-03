//
//  NotesViewController.swift
//  SwiftLesson2
//
//  Created by Admin on 21.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import UIKit

extension NotesViewController: DataControllerDelegate {
    
}

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoginViewControllerDelegate {

    @IBOutlet weak var notesTable: UITableView!
    
    @IBOutlet weak var noNotes: UILabel!
    
    var notes = [Note]()
    
    let dataController = DataController()
    
    var loggedIn = false
    
     
    func deleteNoteAt (index: Int) {
        notes.remove(at: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController.delegate = self
        if UserDefaults.standard.value(forKey: "UserIdentifier") != nil {
            dataController.getNotes()
        }
        
        
        //NotificationCenter.default.addObserver(forName: NSNotification.Name("UserLoggedIn"), object: nil, queue: nil) { (notification) in
            //if let success: Bool = notification.userInfo?["success"] as! Bool? {
               // self.loggedIn = success
               // print ("OKKK")
            //}
            
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataController.delegate = self
        if loggedIn == false && (UserDefaults.standard.value(forKey: "UserIdentifier") == nil) {
            showLoginViewController()
        //} else if UserDefaults.standard.value(forKey: "UserIdentifier") != nil {
        //    dataController.getNotes()
        }
    }
    
    func showLoginViewController() {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle : Bundle.main)
        
        if let loginVC = loginStoryBoard.instantiateInitialViewController() as? LoginViewController {
            loginVC.delegate = self
            present(loginVC, animated: true,completion: nil)

        }

    }
    @IBAction func composeButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "EditNoteSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let notesCount = notes.count
        if notesCount > 0 {
            noNotes.isHidden = true
        } else {
            noNotes.isHidden = false
        }
        
        return notesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell")! as UITableViewCell
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataController.modify(note: notes[indexPath.row], task: .delete)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditNoteSegue", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func didLoggerIn(identifier: String?, success: Bool) {
        loggedIn = success
        UserDefaults.standard.set(identifier, forKey: "UserIdentifier")
    }
    
    func  dataSourceChange(dataSource: [Note]?, error: Error?) {
        if let notes = dataSource {
            self.notes = notes
            notesTable.reloadData()
        }
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let composeVC = segue.destination as? ComposeNoteViewController {
            if segue.identifier == "EditNoteSegue" {
                composeVC.dataController = dataController
                if let index = sender as? Int {
                    composeVC.note = notes[index]
                }
            }
        }
    }
 
}

