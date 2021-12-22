//
//  PostAPI.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/22/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class PostAPI: API {
    
    static func getAllPosts(completionHandler: @escaping ([Post]) -> ()){
        
        let url = "\(baseURL)/post"
        
        
        AF.request(url, headers: headers).responseJSON { response in
            
            let jesonData = JSON(response.value)
            let data = jesonData["data"]
            let decoder = JSONDecoder()
            
            do{
                let posts = try decoder.decode([Post].self, from: data.rawData())
                completionHandler(posts)
                
            }catch let error {
                print(error)
            }
            
        }
    }
    
    static func getPostComments(id: String, completionHandler: @escaping ([Comment]) -> ()) {
     
        let url = "\(baseURL)/post/\(id)/comment"
        
        AF.request(url, headers: headers).responseJSON { response in
            
            let jesonData = JSON(response.value)
            let data = jesonData["data"]
            let decoder = JSONDecoder()
            
            do{
                let comments = try decoder.decode([Comment].self, from: data.rawData())
                completionHandler(comments)
            }catch let error {
                print(error)
            }
            

        }
    }
}
