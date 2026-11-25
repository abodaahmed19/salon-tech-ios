//
//  ChatCell.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderImage: CircleImage!
    @IBOutlet weak var messageTF: UITextView!
    
    @IBOutlet weak var chatView: UIStackView!
    @IBOutlet weak var avatarMessageView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageImageView: UIView!

    var colorOrange = UIColor(red: 0.96, green: 0.37, blue: 0.56, alpha: 1.00)
    
    var token: String = ""
    var userId: String = ""
    var userImage: String = ""
    var clientImage: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let userDate = Helper.getObjectDefault(key: UserDefault.userData) as? LoginData
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        userImage = userDate?.image_url ?? ""
        
        messageView.layer.cornerRadius = 16
        messageImageView.layer.cornerRadius = 16

        senderName.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupClientImage(item: String){
        clientImage = item
    }
    
    func configureCell(item: ChatMessageModel){
        messageTF.text = ""
        
        if item.sender_id ?? 0 == Int(userId) {
            chatView.alignment = .trailing
            messageView.backgroundColor = colorOrange
            messageImageView.backgroundColor = colorOrange

            messageTF.textColor = UIColor.white
            
            senderImage.sd_setImage(with: URL(string: userImage))
            
        }else {
            chatView.alignment = .leading
            messageView.backgroundColor = UIColor.white
            messageImageView.backgroundColor = UIColor.white

            messageTF.textColor = UIColor.black
            
            senderImage.sd_setImage(with: URL(string: clientImage))

        }
        
        if item.type == "message" {
            avatarMessageView.isHidden = false
            messageImageView.isHidden = true
            messageTF.text = item.message ?? ""
        }
        
        if item.type == "image" {
            avatarMessageView.isHidden = true
            messageImageView.isHidden = false
            
            let itemImage = item.image ?? ""
            
            if itemImage == "" {
                messageImage.image = item.sentImage
            }else {
                messageImage.sd_setImage(with: URL(string: SITE_URL + itemImage))
            }
        }
    }

    
    

}
