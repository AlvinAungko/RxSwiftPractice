//
//  Utils.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 26/09/2022.
//

import Foundation
import UIKit

struct Utils {
    static func addShadowCorners(_ view:UIView)
    {
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.23
        view.layer.shadowOffset = CGSize(width: 5, height: 6)
       
//        view.clipsToBounds = true
        
    }
}
