//
//  UserAPI.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/22/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAPI: API {
    
    static func getUserInfo(id: String, completionHandler: @escaping (User) -> ()){
        
      
        let url = "\(baseURL)/user/\(id)"
        
        AF.request(url, headers: headers).responseJSON { response in
            let jesonData = JSON(response.value)
            let decoder = JSONDecoder()
            
            do{
                let user = try decoder.decode(User.self, from: jesonData.rawData())
                completionHandler(user)
            }catch let error {
                print(error)
            }
            
        }
        
    }
    
    static func registerNewUser(firstName: String, lastName: String, email: String, completionHandler: @escaping (User?, String?) -> ()){
        
        let url = "\(baseURL)/user/create"
        let params = [
            "firstName" : firstName,
            "lastName" : lastName,
            "email" : email
        ]
        
        AF.request(url,method: .post, parameters: params,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                let jesonData = JSON(response.value)
                let decoder = JSONDecoder()
                
                do{
                    let user = try decoder.decode(User.self, from: jesonData.rawData())
                    completionHandler(user, nil)
                }catch let error {
                    print(error)
                }
                
            case .failure(let error):
                let jsonData = JSON(response.data)
                let data = jsonData["data"]
                let emailError = data["email"].stringValue
                completionHandler(nil, emailError)
                
            }
            
            
            
        }
        
    }
    
}
