//
//  RegisterVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/22/21.
//

import UIKit
import TextFieldEffects

class RegisterVC: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var firstNameTextField: YoshikoTextField!
    @IBOutlet weak var lastNameTextField: YoshikoTextField!
    @IBOutlet weak var emailTextField: YoshikoTextField!
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: ACTIONS
    @IBAction func loginButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
       
        UserAPI.registerNewUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!) { user, errorMessage in
            
            if errorMessage != nil {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                let alert = UIAlertController(title: "Success", message: "User created successfully", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    

}
