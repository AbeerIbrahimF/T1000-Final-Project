//
//  UIImage+StringUrlToImage.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/18/21.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromStringURL(stringURL: String){
        if let url = URL(string: stringURL){
            if let imageData = try? Data(contentsOf: url){
               self.image = UIImage(data: imageData)
            }
        
        }
    }
    
    func circularImage() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}
