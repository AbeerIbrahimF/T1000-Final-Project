//
//  ProfileVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/20/21.
//

import UIKit
import Alamofire
import SwiftyJSON
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
        
        let appId = "61b8cf3213a2bd2db557e7d8"
        let url = "https://dummyapi.io/data/v1/user/\(user.id)"
        
        let headers: HTTPHeaders = [
            "app-id" : appId
        ]
        LoaderView.startAnimating()
        AF.request(url, headers: headers).responseJSON { response in
            self.LoaderView.stopAnimating()
            let jesonData = JSON(response.value)
            let decoder = JSONDecoder()
            
            do{
                self.user = try decoder.decode(User.self, from: jesonData.rawData())
                self.setUI()
            }catch let error {
                print(error)
            }
            
        }

        
    }
    
    
    func setUI(){
        nameLabel.text? = user.firstName + " " + user.lastName
        profileImage.setImageFromStringURL(stringURL: user.picture)
        phoneLabel.text = user.phone
        countryLabel.text = user.location?.country
        genderLabel.text = user.gender
        emailLabel.text = user.email
    }
    
//    @IBAction func backButtonClicked(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
}
