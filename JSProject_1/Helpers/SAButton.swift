//
//  SAButton.swift
//  JSProject_1
//
//  Created by William Fernandez on 12/28/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class SAButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }


    private func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor     = Constants.Colors.lightBlue
        titleLabel?.font    = .boldSystemFont(ofSize: 20)
        layer.cornerRadius  = frame.size.height / 2

    }
}
