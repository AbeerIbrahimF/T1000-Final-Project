//
//  Comment.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/17/21.
//

import Foundation
import UIKit

struct Comment: Decodable {
    var id: String
    var message: String
    var owner: User
}
