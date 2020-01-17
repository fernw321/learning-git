//
//  SplashScreenViewController.swift
//  JSProject_1
//
//  Created by William Fernandez on 12/6/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    let splashImageView = UIImageView(image: UIImage(named: "Comet")!)
    let splashView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        splashView.backgroundColor = UIColor(red: 193/255, green: 74/255, blue: 255/255, alpha: 1.0)
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        splashImageView.contentMode = .scaleAspectFit
        splashView.addSubview(splashImageView)
        splashImageView.frame = CGRect(x: splashView.frame.maxX/2-100, y: splashView.frame.maxY/2-100, width: 200, height: 200)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.scaleDownAnimation()
        }
    }
    
    
    func scaleDownAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.splashImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (success) in
            self.scaleUpAnimation()
        }
    }
    

    func scaleUpAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: {
            self.splashImageView.transform = CGAffineTransform(scaleX: 30, y: 30)
            self.splashImageView.alpha = 0.5
        }) { (success) in
            self.removeSplashScreen()
        }
    }
    
    func removeSplashScreen() {
        splashView.removeFromSuperview()
    }
}
