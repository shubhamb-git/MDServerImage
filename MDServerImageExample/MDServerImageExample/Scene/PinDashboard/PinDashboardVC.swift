//
//  PinDashboardVC.swift
//  MDServerImageExample
//
//  Created by Shubham on 10/5/19.
//  Copyright © 2019 sb. All rights reserved.
//

import UIKit

class PinDashboardVC: BaseViewController {

    lazy var viewModel = PinDashboardViewModel()
    
    @IBOutlet weak var collectionViewPins: UICollectionView!
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UI setup
        setupUI()
        bindViewModel()
    }
    
    fileprivate func setupUI() {
        PinCollectionViewCell.register(cellTo: collectionViewPins)
        CollectionViewLoadingFooter.register(cellTo: collectionViewPins)
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
        viewModel.reloadPins()
    }
    
    // api call status binding with viewcontroller
    func bindViewModel() {
        viewModel.onChange = viewModelStateChange
        reloadPins()
    }
}

extension PinDashboardVC {
    // method will call when api call status changed
    func viewModelStateChange(change: PinListState.Change) {
        switch change {
        case .none:
            break
        case .fetchStateChanged:
            if !viewModel.state.pins.isEmpty {
                loader(show: false)
                break
            }
            loader(show: self.viewModel.state.fetching)
            break
        case .pinsChanged(let collectionChange):
            switch collectionChange {
            case .deletion:
                break
            default:
                (collectionViewPins.collectionViewLayout as! PinterestCollectionViewLayout).clearCacheAndPrepare()
                collectionViewPins.applyCollectionChange(collectionChange, toSection: 0)
                break
            }
        case .error(let userError):
            switch userError {
            case .connectionError(_):
                presentAlert(withTitle: AppConstants.PlaceHolder.Text.connectionError, description: AppConstants.PlaceHolder.Text.connectionErrorMessage)
            case .mappingFailed:
                presentAlert(withTitle: AppConstants.PlaceHolder.Text.invalidData, description: AppConstants.PlaceHolder.Text.invalidDataErrorMessage)
            case .reloadFailed:
                presentAlert(withTitle: AppConstants.PlaceHolder.Text.invalidData, description: AppConstants.PlaceHolder.Text.invalidDataErrorMessage)
            }
            break
        }
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension PinDashboardVC: PinterestCollectionViewLayoutDelegate {
    
    func numberOfItemsInSection(section: Int) -> Int {
        return viewModel.state.pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        guard !viewModel.state.pins.isEmpty else {
            return 0
        }
        let pin = viewModel.state.pins[indexPath.item]
        let cellWidth = (UIScreen.main.bounds.width - 24) / 2
        
        return cellWidth * CGFloat(pin.sizeRatio) + 41
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForFooterAtIndexPath indexPath: IndexPath) -> CGFloat? {
        if viewModel.state.page.hasNextPage {
            return 44
        }
        return 0
    }
}

extension PinDashboardVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewLoadingFooter", for: indexPath)
            return footerView
        default:
            assert(false, "Unexpected element CollectionViewLoadingFooterkind")
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionView.elementKindSectionFooter {
            print("Load more")
            if viewModel.state.page.hasNextPage {
                self.viewModel.loadMorePins()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PinCollectionViewCell.cell(for: collectionView, at: indexPath, withPin: viewModel.state.pins[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PinCollectionViewCell {
                cell.pinInfoView.transform = .init(scaleX: 0.90, y: 0.90)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PinCollectionViewCell {
                cell.pinInfoView.transform = .identity
            }
        }
    }
}
