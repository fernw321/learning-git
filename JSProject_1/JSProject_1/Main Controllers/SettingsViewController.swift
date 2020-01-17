//
//  SettingsViewController.swift
//  JSProject_1
//
//  Created by William Fernandez on 12/28/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var styleSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForStylePreference()
    
    }
    
    var isDarkMode = false
    let defaults = UserDefaults.standard
    
    @IBAction func didChangeStyleSegmentedControl(_ sender: UISegmentedControl) {
        isDarkMode = sender.selectedSegmentIndex == 1
        saveStylePreference()
        updateStyle()
    }
    
    struct Keys {
        static let prefersDarkMode = "prefersDarkMode"
    }

    // MARK: - Table view data source
    
    func updateStyle() {
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = self.isDarkMode ? .black : .white
        }
    }

    
    
    func saveStylePreference() {
        defaults.set(isDarkMode, forKey: Keys.prefersDarkMode)
    }
    
    func checkForStylePreference() {
        let prefersDarkMode = defaults.bool(forKey: Keys.prefersDarkMode)
        if prefersDarkMode {
            isDarkMode = true
            updateStyle()
            styleSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
}
