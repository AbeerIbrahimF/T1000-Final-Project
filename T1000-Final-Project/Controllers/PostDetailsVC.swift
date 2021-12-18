//
//  PostDetailsVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/17/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class PostDetailsVC: UIViewController {

    var post: Post!
    var comments : [Comment] = []
    // MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesNumberLabel: UILabel!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.shadowColor = UIColor.gray.cgColor
            backView.layer.shadowOpacity = 0.3
            backView.layer.shadowOffset = CGSize(width: 0, height: 10)
            backView.layer.shadowRadius = 10
            backView.layer.cornerRadius = 7
        }
    }
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        // Do any additional setup after loading the view.
        userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        postTextLabel.text = post.text
        likesNumberLabel.text = String(post.likes)
        userImageView.setImageFromStringURL(stringURL: post.owner.picture)
        userImageView.circularImage()
        postImageView.setImageFromStringURL(stringURL: post.image)
        
         //post comments
        let appId = "61b8cf3213a2bd2db557e7d8"
//        let url = "https://dummyapi.io/data/v1/post/60d21af267d0d8992e610b8d/comment"
        let url = "https://dummyapi.io/data/v1/post/\(post.id)/comment"

        let headers: HTTPHeaders = [
            "app-id" : appId
        ]
        
        loaderView.startAnimating()
        AF.request(url, headers: headers).responseJSON { response in
            self.loaderView.stopAnimating()
            let jesonData = JSON(response.value)
            let data = jesonData["data"]
            let decoder = JSONDecoder()
            
            do{
                self.comments = try decoder.decode([Comment].self, from: data.rawData())
                self.commentsTableView.reloadData()
            }catch let error {
                print(error)
            }
            

        }
        
        
        
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        cell.userImageView.setImageFromStringURL(stringURL: currentComment.owner.picture)
        cell.userImageView.circularImage()
        cell.commentMessageLabel.text = currentComment.message

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }

}

