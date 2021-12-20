//
//  User.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/16/21.
//

import Foundation
import UIKit

struct User: Decodable {
    var id: String
    var firstName: String
    var lastName: String
    var picture: String
    var phone: String?
    var gender: String?
    var email: String?
    var location: Location?
    
}
