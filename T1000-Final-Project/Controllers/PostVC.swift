//
//  ViewController.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/15/21.
//

import UIKit
import NVActivityIndicatorView

class PostVC: UIViewController {

    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var LoaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [Post] = []
    var loggedInUser: User?
   
    override func viewDidLoad() {
        //check if user is logged in or a guest
        if let user = loggedInUser{
            hiLabel.text = "Hi, \(user.firstName)!"
        }else {
            hiLabel.isHidden = true
        }
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        super.viewDidLoad()
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name("userStackViewTapped"), object: nil)
        
        // Do any additional setup after loading the view.
        LoaderView.startAnimating()
        PostAPI.getAllPosts { response in
            self.posts = response
            self.LoaderView.stopAnimating()
            self.postsTableView.reloadData()
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
        cell.userImageView.setImageFromStringURL(stringURL: userImageString!)
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
        vc.loggedInUser = loggedInUser
        present(vc, animated: true, completion: nil)
    }
    
}

