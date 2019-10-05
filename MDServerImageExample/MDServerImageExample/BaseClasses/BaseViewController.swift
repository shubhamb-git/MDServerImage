//
//  BaseViewController.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if blackStatusBar {
                return UIStatusBarStyle.default
            } else {
                return UIStatusBarStyle.lightContent
            }
        }
    }
    
    @IBInspectable var blackStatusBar: Bool = false
    
    @IBInspectable var hideNavigationBar: Bool = false {
        didSet {
            self.navigationController?.navigationBar.isHidden = hideNavigationBar
        }
    }
    
    lazy var loadingView = LoadingView.instantiate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    func loader(show status: Bool) {
        if status {
            view.addSubview(loadingView)
            view.bringSubviewToFront(loadingView)
            loadingView.center = view.center
            view.isUserInteractionEnabled = false
        } else {
            loadingView.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingView.center = view.center
    }
}


