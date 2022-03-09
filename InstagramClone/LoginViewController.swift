//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Luis Morfin on 2/27/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userNameTextView: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardOnTap()
    }
    

    @IBAction func onSignIn(_ sender: Any) {
        let username = userNameTextView.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        //PFUser user = [PFUser user];
        let user = PFUser()
        user.username = userNameTextView.text;
        user.password = passwordField.text;
        
        user.signUpInBackground { (success,error) in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
            
    }
        
}

//hides keyboard when tapped anywhere
extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


