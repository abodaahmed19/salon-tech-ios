//
//  ArticleDetailsPresenter.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation

protocol ArticleDetailsPresenterView : NSObjectProtocol {
    func setArticleDetailsSuccess(_ response: ArticlesModel)
    func setArticleDetailsFailure()

    func showConnectionErrorMessage()
}

class ArticleDetailsPresenter {
    private weak var presenterView : ArticleDetailsPresenterView?
    private let api = GetInteractors()
    
    init(_ pView: ArticleDetailsPresenterView){
        presenterView = pView
    }
    
    init() {}
    
    func detachView() {
        presenterView = nil
    }
  
    public func getSingleArticle(articleId: String) {
        api.getSingleArticle(articleId: articleId) { [weak self] (response, error) in
            guard let self = self else { return }
            if error == nil {
                if response?.status ?? false {
                    self.presenterView?.setArticleDetailsSuccess(response?.data ?? ArticlesModel())
                }else {
                    self.presenterView?.setArticleDetailsFailure()
                }
            }else {
                self.presenterView?.showConnectionErrorMessage()
            }
        }
    }
}
