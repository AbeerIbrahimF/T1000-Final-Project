//
//  ViewController.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/15/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class PostVC: UIViewController {

    @IBOutlet weak var LoaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [Post] = []
    
   
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        super.viewDidLoad()
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name("userStackViewTapped"), object: nil)
        
        // Do any additional setup after loading the view.
        let appId = "61b8cf3213a2bd2db557e7d8"
        let url = "https://dummyapi.io/data/v1/post"
        
        let headers: HTTPHeaders = [
            "app-id" : appId
        ]
        LoaderView.startAnimating()
        AF.request(url, headers: headers).responseJSON { response in
            self.LoaderView.stopAnimating()
            let jesonData = JSON(response.value)
            let data = jesonData["data"]
            let decoder = JSONDecoder()
            
            do{
                self.posts = try decoder.decode([Post].self, from: data.rawData())
                self.postsTableView.reloadData()
            }catch let error {
                print(error)
            }
            
        }
    }
    
    @objc func userProfileTapped(notification: Notification) {
        if let cell = notification.userInfo?["cell"] as? UITableViewCell {
            if let indexPath = postsTableView.indexPath(for: cell){
                let post = posts[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                
                vc.user = post.owner
                present(vc, animated: true, completion: nil)
            }
            
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        present(vc, animated: true, completion: nil)
        
    }

}

extension PostVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        cell.postTextLabel.text = post.text
        
        // post image to url
        let imageStringURL = post.image
        cell.postImageView.setImageFromStringURL(stringURL: imageStringURL)
        
        //user image to url
        let userImageString = post.owner.picture
        cell.userImageView.setImageFromStringURL(stringURL: userImageString)
        cell.userImageView.circularImage()
    
        //user data
        cell.userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        cell.likesNumberLabel.text = String(post.likes)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsVC") as! PostDetailsVC
        vc.post = selectedPost
        present(vc, animated: true, completion: nil)
    }
    
}

