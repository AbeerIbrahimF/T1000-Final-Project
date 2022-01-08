//
//  MyProfileVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/31/21.
//

import UIKit
import TextFieldEffects


class MyProfileVC: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: YoshikoTextField!
    @IBOutlet weak var phoneTextField: YoshikoTextField!
    @IBOutlet weak var imageURLTextField: YoshikoTextField!
    
    
    
    // MARK: METHODS LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserManager.loggedInUser == nil {
            let alert = UIAlertController(title: "", message: "hello there, to view your profile you need to log in first", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "log in page", style: .default) { UIAlertAction in
                self.dismiss(animated: true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC")
                self.present(vc!, animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        setupUI()
    }
    
    // MARK: ACTIONS
    @IBAction func doneButtonClicked(_ sender: Any) {
        guard let loggedInUser = UserManager.loggedInUser else {return}
        
        UserAPI.updateUserInfo(userId: loggedInUser.id, firstName: firstNameTextField.text!, phone: phoneTextField.text!, imageUrl: imageURLTextField.text!) { user, errorMessage in
            if let responseUser = user {
                if let image = user?.picture{
                    self.userImageView.setImageFromStringURL(stringURL: image)
                }
                self.userNameLabel.text = responseUser.firstName + " " + responseUser.lastName
            }
        }
    }
    
    func setupUI(){
        if let user = UserManager.loggedInUser{
            if let image = user.picture{
                userImageView.setImageFromStringURL(stringURL: image)
                userImageView.circularImage()
            }
            
            userNameLabel.text = user.firstName + " " + user.lastName
            firstNameTextField.text = user.firstName
            phoneTextField.text = user.phone
        }
    }
    
}
