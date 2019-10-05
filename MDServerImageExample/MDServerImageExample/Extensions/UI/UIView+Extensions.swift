//
//  UIView+Extensions.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

extension UIView {
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func makeCircle() {
        setCornerRadius(self.bounds.width/2)
    }
    
    // Adds a view as a subview of another view with anchors at all sides
    func addToView(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        view.layoutIfNeeded()
        let constraintsLeft = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute:.leading, multiplier: 1.0, constant:0.0)
        let constraintsRight = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute:.trailing, multiplier: 1.0, constant:0.0)
        let constraintsTop = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute:.top, multiplier: 1.0, constant:0.0)
        let constraintsBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute:.bottom, multiplier: 1.0, constant:0.0)
        NSLayoutConstraint.activate([constraintsLeft, constraintsRight, constraintsTop, constraintsBottom])
    }
}

