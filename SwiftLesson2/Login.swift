//
//  Login.swift
//  SwiftLesson2
//
//  Created by Admin on 22.08.17.
//  Copyright © 2017 DemkivVova. All rights reserved.
//

import Foundation
import Accounts

protocol Loginable {
    func login(completion: @escaping (String?, Error?) -> Void)
    
}

extension Loginable {
    func getIdentifier(from account: ACAccount?, response:(success: Bool, error: Error?)) -> String? {
        let identifier: String?
        
        if response.success {
            identifier = account?.identifier as String?
            print ("ACC DESCRIPTION = \(identifier!)")
        } else {
            if let error = response.error {
                print("ACC ERROR = \(String(describing: error.localizedDescription))")
            }
            identifier = nil
            
        }
        return identifier
    }
}

class FacebookLogger: Loginable {
    internal func login(completion: @escaping (String?, Error?) -> Void) {
        let accountStore = ACAccountStore()
        let facebook = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierFacebook)
        let apiKey = "183312432211968"
        let options = [ACFacebookAppIdKey: apiKey, ACFacebookPermissionsKey: ["email"]] as [String : Any]
        accountStore.requestAccessToAccounts(with: facebook, options: options) { (success, error) in
            let accounts = accountStore.accounts(with: facebook)
            let identifier: String?
            if let account = accounts?.last as? ACAccount {
                identifier = self.getIdentifier(from: account, response: (success: success, error: error))
            } else {
                identifier = nil
            }
            
            completion (identifier, error)
        }
    }
}

class TwitterLogger: Loginable {
    internal func login(completion: @escaping (String?, Error?) -> Void) {
        let accountsStore = ACAccountStore()
        let  twitter = accountsStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
    
        accountsStore.requestAccessToAccounts(with: twitter, options: nil) { (success, error) in
            let accounts = accountsStore.accounts(with: twitter)
            let identifier: String?
            if let account = accounts?.last as? ACAccount {
                identifier = self.getIdentifier(from: account, response: (success: success, error: error))
            } else {
                identifier = nil
            }
            
            completion (identifier, error)
        }
    }
}

