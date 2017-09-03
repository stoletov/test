//
//  LoginViewController.swift
//  SwiftLesson2
//
//  Created by Admin on 22.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func didLoggerIn(identifier: String?, success: Bool)
}


class LoginViewController: UIViewController {
    
    var delegate:LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func twitterButton(_ sender: Any) {
        let twitterLogger = TwitterLogger()
        twitterLogger.login { (identifier, error) in
            self.proccesLoginResult(identifier: identifier, error: error)
        }
    }
    
    @IBAction func facebookButton(_ sender: Any) {
        let facebookLogger = FacebookLogger()
        facebookLogger.login { (identifier, error) in
            self.proccesLoginResult(identifier: identifier, error: error)
        }

    }
    
    func proccesLoginResult (identifier: String?, error: Error?) {
        let success: Bool
        if let error = error {
            print("can't logg in to account \(error.localizedDescription)")
            success = false
        } else {
            print ("twitter ID = \(identifier!)")
            success = true
        }
        self.delegate?.didLoggerIn(identifier: identifier, success: success)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoggedIn"), object: nil, userInfo: ["idn" : identifier!, "success" : success])
        dismiss(animated: true, completion: nil)
    }

}
