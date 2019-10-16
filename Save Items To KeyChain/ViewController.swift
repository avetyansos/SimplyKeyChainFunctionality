//
//  ViewController.swift
//  Save Items To KeyChain
//
//  Created by Sos Avetyan on 16/10/2019.
//  Copyright © 2019 Sos Avetyan. All rights reserved.
//

import UIKit

typealias successResponseWithoutData = () -> Void
typealias failureAuthHandler = (_ bitAuthError :BioAuthError) -> Void


enum BioAuthError: Error {
    case userCancel
    case authFailure
    case passwordSaveError
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getPasswordForUser(username: String) -> String {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: username,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    func saveUserPassword(username: String?, password: String?, _ success : @escaping successResponseWithoutData, _ failure : @escaping failureAuthHandler ){
            guard let newAccountName = username,
                let newPassword = password,
                newAccountName != "",
                newPassword != "" else {
                    
                    return
            }
            
            
            do {
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: newAccountName,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(newPassword)
                success()
            } catch {
                failure(.passwordSaveError)
                fatalError("Error updating keychain - \(error)")
            }
        }


}

