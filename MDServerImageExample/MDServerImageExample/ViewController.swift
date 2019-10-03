//
//  ViewController.swift
//  MDServerImageExample
//
//  Created by Shubham Bairagi on 02/10/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit
import MDServerImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.setImage(withUrl: "https://www.gstatic.com/webp/gallery/1.jpg")
        
        print("Test")
    }


}

