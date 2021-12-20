//
//  ShadowView.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/20/21.
//

import UIKit

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpShadow()
    }
    
    func setUpShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 7
    }
}
