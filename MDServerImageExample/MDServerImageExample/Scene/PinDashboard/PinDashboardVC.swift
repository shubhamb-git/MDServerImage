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
    
    @IBOutlet weak var collectionViewPins: UICollectionView!
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UI setup
        setupUI()
        
        // api call
        loader(show: true)
        viewModel.fetchPin()
    }
    
    fileprivate func setupUI() {
        PinCollectionViewCell.register(cellTo: collectionViewPins)
        setupRefreshControl()
        
        if let layout = collectionViewPins.collectionViewLayout as? PinterestCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        refreshControl.attributedTitle =
            NSAttributedString(string: AppConstants.PlaceHolder.Text.pullToRefresh,
                               attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1),
                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 9)])
        refreshControl.addTarget(self, action: #selector(reloadPins), for: .valueChanged)
        collectionViewPins.insertSubview(refreshControl, at: 0)
    }
    
    @objc private func reloadPins() {
        loader(show: true)
        viewModel.fetchPin()
    }
}

extension PinDashboardVC: PinterestCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        guard let pin = viewModel.pins?[indexPath.row] else {
            return 0
        }
        
        let cellWidth = (UIScreen.main.bounds.width - 24) / 2
        
        return cellWidth * CGFloat(pin.sizeRatio)
    }
}

extension PinDashboardVC: UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pins?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let pin = viewModel.pins?[indexPath.row] else {
            fatalError("Unexpexted behaviour")
        }
        return PinCollectionViewCell.cell(for: collectionView, at: indexPath, withPin: pin)
    }
}

extension PinDashboardVC: PinResponseDelegate {
    
    func didReceivedResponse() {
        Helper.dispatchAsyncMain { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.loader(show: false)
            strongSelf.collectionViewPins.reloadData()
            
            if strongSelf.refreshControl.isRefreshing {
                strongSelf.refreshControl.endRefreshing()
            }
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
