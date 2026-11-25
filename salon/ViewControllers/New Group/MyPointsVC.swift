//
//  MyPointsVC.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MyPointsVC: UIViewController {
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: MyPointsPresenter?
    var pointsList: [PointsModel] = []
    
    var refresher: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        pointsCV.addSubview(refresher)
        
        initView()
        showPoints()
    }
    
    @objc func populate(){
        presenter?.getPoints()
        refresher.endRefreshing()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        pointsCV.dataSource = self
        pointsCV.delegate = self
        pointsCV.register(UINib(nibName: "MyPointsCell", bundle: nil), forCellWithReuseIdentifier: "MyPointsCell")
        pointsCV.alwaysBounceVertical = true
    }
    
    func showPoints() {
        presenter = MyPointsPresenter(self)
        presenter?.getPoints()
    }
}

extension MyPointsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pointsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPointsCell", for: indexPath) as?
                MyPointsCell else {
            return UICollectionViewCell()
        }
        
        cell.configCell(item: pointsList[indexPath.row])
        
        return cell
    }
}

extension MyPointsVC: MyPointsPresenterView {
    func setPointsCountSuccess(_ points: Int) {
        pointsLabel.text = String(points)
    }
    
    func setPointsSuccess(_ response: [PointsModel]) {
        pointsList = response
        pointsCV.reloadData()
    }
    
    func setPointsFailure() {
        noItemsView.isHidden = false
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}
