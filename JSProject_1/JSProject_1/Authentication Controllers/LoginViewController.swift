//
//  LoginViewController.swift
//  JSProject_1
//
//  Created by William Fernandez on 12/6/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        
    }
    
    func style() {
        Utilities.styleTextField(usernameField)
        Utilities.styleTextField(passwordField)
        
        Utilities.styleHollowButton(logInButton)
        errorLabel.isHidden = true
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        // Validate text fields
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
            
        } else {
        
            // Create cleaned versions of the data
            let username = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Sign in
            Auth.auth().signIn(withEmail: username!, password: password!) { [weak self] authResult, err in
              
                if err != nil {
                    self?.showError(err!.localizedDescription)
                } else {
                    
                    self?.transitionToHome()

                }
            }
        }
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields."
        }

        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
        
        
    }
}
