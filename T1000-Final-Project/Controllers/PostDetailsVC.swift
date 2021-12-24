//
//  PostDetailsVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/17/21.
//

import UIKit
import NVActivityIndicatorView

class PostDetailsVC: UIViewController {

    var post: Post!
    var comments: [Comment] = []
    
    
    // MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesNumberLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendCommentSV: UIStackView!
    
    // MARK: LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserManager.loggedInUser == nil {
            sendCommentSV.isHidden = true
        }
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        // Do any additional setup after loading the view.
        userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        postTextLabel.text = post.text
        likesNumberLabel.text = String(post.likes)
        userImageView.setImageFromStringURL(stringURL: post.owner.picture!)
        userImageView.circularImage()
        postImageView.setImageFromStringURL(stringURL: post.image)
        
         //post comments
        getPostComments()

    }
    // MARK: ACTIONS
    
    func getPostComments(){
        loaderView.startAnimating()
        PostAPI.getPostComments(id: post.id) { commentResponse in
            self.comments = commentResponse
            self.commentsTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonClicked(_ sender: Any) {
        let message = commentTextField.text!
        
        if let user = UserManager.loggedInUser {
            PostAPI.addNewComment(postId: post.id, userId: user.id, message: message) {
                self.getPostComments()
                self.commentTextField.text = ""
            }
        }
    }
    
}


extension PostDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let currentComment = comments[indexPath.row]
        
        cell.userNameLabel.text = currentComment.owner.firstName + " " + currentComment.owner.lastName
        if let userImage = currentComment.owner.picture{
            cell.userImageView.setImageFromStringURL(stringURL: userImage)
        }
        
        cell.userImageView.circularImage()
        cell.commentMessageLabel.text = currentComment.message

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }

}

