//
//  ProfileVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/20/21.
//

import UIKit
import NVActivityIndicatorView

class ProfileVC: UIViewController {

    var user: User!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var LoaderView: NVActivityIndicatorView!
    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage.circularImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        LoaderView.startAnimating()
        UserAPI.getUserInfo(id: user.id) { userResponse in
            self.user = userResponse
            self.setUI()
            self.LoaderView.stopAnimating()
        }

        
    }
    
    
    func setUI(){
        nameLabel.text? = user.firstName + " " + user.lastName
        profileImage.setImageFromStringURL(stringURL: user.picture!)
        phoneLabel.text = user.phone
        countryLabel.text = user.location?.country
        genderLabel.text = user.gender
        emailLabel.text = user.email
    }
    
//    @IBAction func backButtonClicked(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
}
