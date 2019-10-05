//
//  PinDashboardVC.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class PinDashboardVC: BaseViewController {

    lazy var viewModel = PinDashboardViewModel(with: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loader(show: true)
        viewModel.fetchPin()
    }
}

extension PinDashboardVC: PinResponseDelegate {
    
    func didReceivedResponse() {
        Helper.dispatchAsyncMain { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loader(show: false)
        }
    }
    
    func didfailed(with error: String?) {
        Helper.dispatchAsyncMain { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loader(show: false)
            strongSelf.presentAlert(withTitle: error ?? "Internal Server error")
        }
    }
}
