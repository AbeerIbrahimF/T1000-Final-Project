//
//  LogInVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/23/21.
//

import UIKit
import TextFieldEffects
import Spring

class LogInVC: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var welcomeLabel: SpringLabel!
    @IBOutlet weak var firstNameTextField: YoshikoTextField!
    @IBOutlet weak var lastNameTextField: YoshikoTextField!
    @IBOutlet weak var loginButton: SpringButton!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.animation = "fadeIn"
        welcomeLabel.delay = 0.5
        welcomeLabel.duration = 3
        welcomeLabel.animate()
        firstNameTextField.text = "Abeer"
        lastNameTextField.text = "Beer"
        // Do any additional setup after loading the view.
    }
    
    // MARK: ACTIONS
    @IBAction func logInButtonClicked(_ sender: Any) {
        
        UserAPI.logInUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!) { user, errorMessage in
            
            if let message = errorMessage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                if let loggedInUser = user{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabBarController")
                    UserManager.loggedInUser = loggedInUser
                    self.present(vc!, animated: true, completion: nil)
                }
            }
        }
    }
}
