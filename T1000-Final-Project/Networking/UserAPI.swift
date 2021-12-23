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
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let errorMessage = firstNameError + " " + lastNameError + " " + emailError
                completionHandler(nil, errorMessage )
                
            }
            
            
            
        }
        
    }
    
    static func logInUser(firstName: String, lastName: String, completionHandler: @escaping (User?, String?) -> ()){
        
        let url = "\(baseURL)/user"
        let params = [
            "created" : 1
        ]
        
        AF.request(url,method: .get, parameters: params,encoder: URLEncodedFormParameterEncoder.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                let jesonData = JSON(response.value)
                let decoder = JSONDecoder()
                let data = jesonData["data"]
                
                do{
                    let users = try decoder.decode([User].self, from: data.rawData())
                    
                    var foundUser: User?
                    for user in users{
                        if user.firstName == firstName && user.lastName == lastName{
                            foundUser = user
                            break
                        }
                    }
                    
                    if let user = foundUser{
                        completionHandler(user, nil)
                    }else {
                        completionHandler(nil, "first name or last name doesn't match any user")
                    }
                    
                }catch let error {
                    print(error)
                }
                
            case .failure(let error):
                let jsonData = JSON(response.data)
                let data = jsonData["data"]
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let errorMessage = firstNameError + " " + lastNameError + " " + emailError
                completionHandler(nil, errorMessage )
                
            }
            
            
            
        }
        
    }
    
}
