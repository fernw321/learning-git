//
//  HomeViewController.swift
//  JSProject_1
//
//  Created by William Fernandez on 12/15/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    var categories = ["Roommate", "Gym Partner", "Activities", "Tours", "Events"]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set transparent navigation bar when scrolling
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        navigationController?.hidesBarsOnSwipe = true

        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        // remove extra space at the top and bottom of the homepage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let prefersDarkMode = defaults.bool(forKey: "prefersDarkMode")
        if prefersDarkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell set up
        let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainTableViewCell
        cell.mainButton.setTitle(categories[indexPath.row], for: .normal)
        cell.mainImage.image = UIImage(named: "Screen_Shot_2019_06_11_at_6.47.17_PM.png")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
    }
}
