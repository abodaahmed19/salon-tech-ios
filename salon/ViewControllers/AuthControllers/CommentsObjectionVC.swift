//
//  CommentsObjectionVC.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 17/04/2023.
//  Copyright © 2023 ALBadr. All rights reserved.
//

import UIKit

protocol CommentsObjectionDelegate: NSObjectProtocol {
    func sendObjectionSuccess()
}

class CommentsObjectionVC: UIViewController {

    @IBOutlet weak var objectionTF: UITextView!
    
    var commentId: Int = 0
    
    private var presenter: ObjectionPresenter?
    
    var type: String = ""
    
    weak var delegate: CommentsObjectionDelegate?

    override func viewWillAppear(_ animated: Bool) {
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        type = userDate?.type ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        type = userDate?.type ?? ""
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            objectionTF.textAlignment = .right
        }

        objectionTF.text = "Objection Reasons".localiz()
        
        presenter = ObjectionPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        objectionTF.inputAccessoryView = toolbar
        objectionTF.delegate = self
    }

    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if objectionTF.text == "" {
            Helper.showFloatAlert(title: "Please enter your objection".localiz(), type: .error)
        }else {
            sendObjection()
        }
    }
    
    func sendObjection() {
        let parameters = ["objection": objectionTF.text ?? ""] as [String : Any]
        
        if type == "provider" {
            presenter?.objectionCommentProvider(comment_id: "\(commentId)", parameters: parameters)
        }else {
            presenter?.objectionCommentClient(comment_id: "\(commentId)", parameters: parameters)
        }
    }

}

extension CommentsObjectionVC: ObjectionPresenterView {
    func getCommentsObjectionSuccess(_ response: String) {
        Helper.showFloatAlert(title: response, type: .success)
                
        self.dismiss(animated: true, completion: nil)
        delegate?.sendObjectionSuccess()
    }
    
    func getCommentsObjectionFailure(_ response: String) {
        Helper.showFloatAlert(title: response, type: .error)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
}

extension CommentsObjectionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if objectionTF.text == "Objection Reasons".localiz() {
            objectionTF.text = ""
            objectionTF.textColor = .black
        }
    }
}

