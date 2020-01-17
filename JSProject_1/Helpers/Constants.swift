//
//  File.swift
//  JSProject_1
//
//  Created by William Fernandez on 12/13/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeViewController"
        static let splashViewController = "SplashScreenViewController"
    }
    
    struct Defaults {
        let deafults = UserDefaults.standard
    }
    
    struct Colors {
        static let darkGrey  = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        static let lightBlue = UIColor(red: 89/255, green: 205/255, blue: 242/255, alpha: 1)
    }
}
