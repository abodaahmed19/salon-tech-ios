//
//  ProfileCommentsVC.swift
//  salon
//
//  Created by AL Badr  on 7/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ProfileCommentsVC: UIViewController {
    @IBOutlet weak var commentsCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: ProfileCommentsPresenter?
    var commentsList: [CommentsModel] = []
    
    var provider_id: Int = 0
    
    var type: String = ""
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        type = userDate?.type ?? ""
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        commentsCV.addSubview(refresher)
        
        initView()
        showComments()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        commentsCV.dataSource = self
        commentsCV.delegate = self
        commentsCV.register(UINib(nibName: "CommentsCell", bundle: nil), forCellWithReuseIdentifier: "CommentsCell")
    }
    
    func showComments() {
        presenter = ProfileCommentsPresenter(self)
        
        if type == "provider" {
            presenter?.getProviderComments()
        }else {
            presenter?.getClientComments()
        }
    }
    
    @objc func populate(){
        showComments()
        refresher.endRefreshing()
    }
}

extension ProfileCommentsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = commentsList[indexPath.row].comment ?? ""
        let cellHeight = heightForLabel(text: text) + 100

        return CGSize(width: UIScreen.main.bounds.width - 16, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        commentsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentsCell", for: indexPath) as?
            CommentsCell else {
                return UICollectionViewCell()
        }
        
        let item = commentsList[indexPath.row]
        cell.configureCell(item: item)
        
        let hasObjection = item.has_objection ?? false
        cell.objectionView.isHidden = hasObjection ? true : false
        
        cell.objectionBtn.addTarget(self, action: #selector(objectionBtn_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.objectionBtn.tag = indexPath.row
        
        return cell
    }
    
    func heightForLabel(text:String) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 16 , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @objc func objectionBtn_tapped(_ sender: UIButton) {
        let story = UIStoryboard(name: Storyboards.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"CommentsObjectionVC") as! CommentsObjectionVC
        vc.commentId = commentsList[sender.tag].rate_id ?? 0
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension ProfileCommentsVC: ProfileCommentsPresenterView {
    func getProviderCommentsSuccess(_ response: [CommentsModel]) {
        commentsList = response
        commentsCV.reloadData()
    }
    
    func getClientCommentsSuccess(_ response: [CommentsModel]) {
        commentsList = response
        commentsCV.reloadData()
    }
    
    func getCommentsFailure() {
        noItemsView.isHidden = false
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension ProfileCommentsVC: CommentsObjectionDelegate {
    func sendObjectionSuccess() {
        showComments()
    }
}
