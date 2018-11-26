//
//  ViewController.swift
//  Snapchat
//
//  Created by Jeevan on 20/11/18.
//  Copyright © 2018 Jeevan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: LoadingIndicatorViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    var isSignUpMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.email.text = "testuser2@gmail.com"
        self.password.text = "testuser2"
    }
    fileprivate func resetTextFields() {
        self.email.text = ""
        self.password.text = ""
    }
    
    @IBAction func mainButtonClick(_ sender: Any) {
        self.loadingIndicator.startAnimating()
        if isSignUpMode {
            //Switch to login on signup success
            Auth.auth().createUser(withEmail: email.text ?? "", password: password.text ?? "" ) { (user, error) in
                self.loadingIndicator.stopAnimating()
                if let error = error {
                    Utils.showAlert(message: error.localizedDescription, title: "Alert!",viewController: self)
                }else{
                    Utils.showAlert(message: "User has been successfully signed up. Please login to start the chat.", title: "Success!",viewController: self)
                    self.mainButton.setTitle("Login", for: .normal)
                    self.switchButton.setTitle("Switch to SignUp", for: .normal)
                    self.resetTextFields()
                    self.isSignUpMode = false
                    //Add this user to database
                    if let user = user?.user {
                        Database.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                    }
                    
                }
            }
            
        }else {
            // move to first screen upon login success
            Auth.auth().signIn(withEmail: email.text ?? "", password: password.text ?? "") { (user, error) in
                self.loadingIndicator.stopAnimating()
                if let error = error {
                    Utils.showAlert(message: error.localizedDescription, title: "Alert!",viewController: self)
                }else{
                    self.resetTextFields()
                    self.performSegue(withIdentifier: "snapsDashboard", sender: self)
                }
            }
        }
    }
    
    @IBAction func switchButtonClick(_ sender: Any) {
        if isSignUpMode {
            mainButton.setTitle("Login", for: .normal)
            switchButton.setTitle("Switch to SignUp", for: .normal)
        }else {
            mainButton.setTitle("SignUp", for: .normal)
            switchButton.setTitle("Switch to Login", for: .normal)
        }
        isSignUpMode = !isSignUpMode
    }
    
}

