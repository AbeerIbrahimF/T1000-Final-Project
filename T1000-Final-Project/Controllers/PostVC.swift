//
//  ViewController.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/15/21.
//

import UIKit
import NVActivityIndicatorView

class PostVC: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var LoaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var tagLabel: UILabel!
    
    var posts: [Post] = []
    var tag: String?
    var page = 0
    var total = 0
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        //check if user is logged in or a guest
        if let user = UserManager.loggedInUser{
            hiLabel.text = "Hi, \(user.firstName)!"
        }else {
            hiLabel.isHidden = true
        }
        
        if let myTag = tag {
            tagLabel.text = " #\(myTag) "
        }else {
            tagLabel.isHidden = true
        }
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        super.viewDidLoad()
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name("userStackViewTapped"), object: nil)
        
        // Do any additional setup after loading the view.
        getPosts()
        
    }
    
    func getPosts(){
        LoaderView.startAnimating()
        PostAPI.getAllPosts(page: page,tag: tag) { response, total in
            self.total = total
            self.posts.append(contentsOf: response)
            self.LoaderView.stopAnimating()
            self.postsTableView.reloadData()
        }
    }
    
    // MARK: ACTIONS
    @IBAction func exitButtonClicked(_ sender: Any) {
        if tag == nil{
            self.dismiss(animated: true) {
                UserManager.loggedInUser = nil
            }
        }else {
            self.dismiss(animated: true)
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
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 && posts.count < total {
            page += 1
            getPosts()
        }
    }
    
}

