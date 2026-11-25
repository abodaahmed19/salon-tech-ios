//
//  ChatVC.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import PusherSwift
import SwiftyJSON
import ObjectMapper

class ChatVC: UIViewController {
    @IBOutlet weak var messagesTableView: UITableView!

    @IBOutlet weak var messageTF: UITextView!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!

    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!

    fileprivate var presenter: ChatPresenter?
    
    var messagesList: [ChatMessageModel] = []
    var imagesList: [UIImage] = []
    
    var message_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var image: String = ""
    var clientId: String = ""
    var channelId: Int = 0
    var clientImage: String = ""

    var fromRemoteNotifications: Bool = false
    
    var pusher: Pusher!

    var page: Int = 1
    var lastPage: Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        Helper.setNavColor(nav: self.navigationController!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let options = PusherClientOptions(
            host: .cluster(PucherConstants.CLUSTER)
        )
        
        self.pusher = Pusher(key: PucherConstants.CLIENT_KEY, options: options)
        
        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        image = userDate?.image_url ?? ""
        
        if LanguageManger.shared.currentLanguage == .ar {
            messageTF.text = "Type a message".localiz()
            messageTF.textAlignment = .right
            
            backBtn.image = #imageLiteral(resourceName: "forward")
        }


        initView()
    }
    
    func initView() {
        let userColors = Helper.getObjectDefault(key: UserDefault.userColors) as? ColorsModel
        backBtn.tintColor = Helper.hexStringToUIColor(hex: userColors?.top_div_line ?? "#000000")
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if LanguageManger.shared.currentLanguage == .ar {
            backBtn.image = #imageLiteral(resourceName: "forward")
        }
                
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        
        setupKeyboard()
        
        presenter = ChatPresenter(self)
        GetMessages()
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        messageTF.inputAccessoryView = toolbar
        messageTF.delegate = self
    }
    
    func GetMessages() {
        presenter?.getChat(clientId: "\(clientId)", page: "\(page)")
    }
    
    @objc func keybourdWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo as? [String : AnyObject] else { return }
        
        let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        let keyboardRect = frame?.cgRectValue
        let keyboardHeight = keyboardRect?.height
        stackHeight.constant = keyboardHeight ?? 24
    }
    
    @objc func keybourdWillHide(notification: NSNotification){
        stackHeight.constant = 0
    }
    
    @IBAction func exitChat_tap(_ sender: UIBarButtonItem) {
        if fromRemoteNotifications {
            let main = UIStoryboard(name: Storyboards.main, bundle: nil)
            let mainvc = main.instantiateViewController(withIdentifier: "mainNC")
            mainvc.modalPresentationStyle = .fullScreen
            present(mainvc, animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func sendImageBtn_tapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galaryImage = #imageLiteral(resourceName: "galaryblue")
        let galaryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default, handler: openGalary)
        galaryAction.setValue(galaryImage, forKey: "image")
        
        let cameraImage = #imageLiteral(resourceName: "camerablue")
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default, handler: openCamera)
        cameraAction.setValue(cameraImage, forKey: "image")
        
        alert.addAction(galaryAction)
        alert.addAction(cameraAction)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
    }
    
    @objc func openGalary(alert: UIAlertAction!) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func openCamera(alert: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.modalPresentationStyle = .fullScreen
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        } else {
            Helper.showFloatAlert(title: "Camera is not Available".localiz(), type: .error)
        }
    }
    
    @IBAction func sendBtn_tap(_ sender: Any) {
        if messageTF.text == "Type a message".localiz() ||
            messageTF.text == "" {
            
        }else {
            let parameters = ["message": messageTF.text ?? "",
                              "unique_code": Helper.randomString(length: 20),
                              "type": "message"] as [String : Any]
            
            var data = ChatMessageModel()
            data.message = messageTF.text ?? ""
            data.sender_id = Int(userId)
            data.type = "message"
            data.the_date = "Now".localiz()
            messagesList.insert(data, at: 0)
 
            messagesTableView.reloadData()
            messageTF.text = ""
            
            presenter?.sendChatMessage(clientId: clientId, parameters: parameters, images: imagesList)
        }
    }
    
    public func SetPusher() {
        let channel = self.pusher.subscribe("to_" + "\(self.channelId)")
        let _ = channel.bind(eventName: "client_event_" + "\(self.channelId)", callback: { (data: Any?) -> Void in
            
            if let data = data as? [String: AnyObject] {
                print("author data: ", data)
                
                let json = JSON(data)
                
                print("success", json)
                
                let sender_id = json["sender_id"].intValue
                
                if "\(sender_id)" == self.userId {
                    print("repeate message")
                }else {
                    
                    let message = Mapper<ChatMessageModel>().map(JSON: data)
                    self.messagesList.insert(message ?? ChatMessageModel(), at: 0)
                    self.messagesTableView.reloadData()
                    
                    
                    if !self.messagesList.isEmpty{
                        self.messagesTableView.scrollToRow(at: IndexPath(item: (0), section: 0), at: .bottom, animated: true)
                    }
                }
            }
        })
        self.pusher.connect()
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as?
            ChatCell else {
                return UITableViewCell()
        }
        
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        
        cell.setupClientImage(item: clientImage)
        cell.configureCell(item: messagesList[indexPath.row])
        
        if indexPath.row == messagesList.count - 1 {
            if page < lastPage {
                page = page + 1
                GetMessages()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (messagesList[indexPath.row].type ?? "") == "image" {
            guard let cell = messagesTableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ChatCell else { return }
            let story = UIStoryboard(name: Storyboards.user, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ChatImagesVC") as! ChatImagesVC
            vc.image = cell.messageImage.image
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true)
        }
    }
 
}


extension ChatVC: ChatPresenterView {
    func getChatSuccess(_ response: ChatModel) {
        lastPage = response.data?.last_page ?? 1
        
        if page == 1 {
            messagesList = response.data?.data ?? []
            
            clientImage = response.chat_data?.client_image_url ?? ""
            channelId = response.chat_data?.channel_id ?? 0
            presenter?.openChat(channelId: "\(channelId)")

            SetPusher()
            
        }else {
            messagesList.append(contentsOf: response.data?.data ?? [])
        }

        messagesTableView.reloadData()
    }
    
    func getSendMessageSuccess() {
        
    }
    
    func noMessages() {
        
    }
 
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), type: .error)
    }
    
    
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imagesList.removeAll()
        imagesList.append(image)
        
        let parameters = ["message": "",
                          "unique_code": Helper.randomString(length: 20),
                          "type": "image"] as [String : Any]
        
        var data = ChatMessageModel()
        data.sender_id = Int(userId)
        data.type = "image"
        data.image = ""
        data.sentImage = image
        data.the_date = "Now".localiz()
        messagesList.insert(data, at: 0)
        
        messagesTableView.reloadData()
        messageTF.text = ""
        
        presenter?.sendChatMessage(clientId: clientId, parameters: parameters, images: imagesList)
        
        picker.dismiss(animated: true)

    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTF.text == "Type a message".localiz() {
            messageTF.text = ""
        }
        
        messageTF.textColor = .black
    }
}
