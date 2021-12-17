//
//  ViewController.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/15/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    
    var posts: [Post] = []
    
   
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appId = "61b8cf3213a2bd2db557e7d8"
        let url = "https://dummyapi.io/data/v1/post"
        
        let headers: HTTPHeaders = [
            "app-id" : appId
        ]
        
        AF.request(url, headers: headers).responseJSON { response in
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

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        cell.postTextLabel.text = post.text
        
        // post image to url
        let imageStringURL = post.image
        if let url = URL(string: imageStringURL){
            if let imageData = try? Data(contentsOf: url){
                cell.postImageView.image = UIImage(data: imageData)
            }
        
        }
        
        //user image to url
        let userImageString = post.owner.picture
        if let url = URL(string: userImageString) {
            if let imageData = try? Data(contentsOf: url){
                cell.userImageView.image = UIImage(data: imageData)
            }
        }
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
    
        //user name
        cell.userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
        
    }
    
}

