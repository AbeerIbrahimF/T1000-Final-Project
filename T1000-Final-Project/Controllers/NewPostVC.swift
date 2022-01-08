//
//  NewPostVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/29/21.
//

import UIKit
import TextFieldEffects

class NewPostVC: UIViewController {

    @IBOutlet weak var textTextField: YoshikoTextField!
    @IBOutlet weak var imageTextField: YoshikoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func AddNewPostButtonClicked(_ sender: Any) {
        if let user = UserManager.loggedInUser {
            PostAPI.addNewPost(imageURL: imageTextField?.text , userId: user.id, text: textTextField.text!) {
                NotificationCenter.default.post(name: NSNotification.Name("NewPostAdded"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func CloseButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
