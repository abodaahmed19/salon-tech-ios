//
//  ChatImagesVC.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit
import SDWebImage
import WebKit

class ChatImagesVC: UIViewController, UIScrollViewDelegate  {
    @IBOutlet var webView: WKWebView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chatImage: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    //var imageURL: String = ""
    var image: UIImage?
    var fileType: String = "image"
    var fileLink: String = ""

    var gestureRecognizer: UITapGestureRecognizer!
    
    var blackColor = UIColor(red:0.11, green:0.13, blue:0.15, alpha:1.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if LanguageManger.shared.currentLanguage == .ar {
            backBtn.setImage(#imageLiteral(resourceName: "foewardwhite"), for: .normal)
        }
        
        if fileType == "image" {
            chatImage.isHidden = false
            webView.isHidden = true
            
            chatImage.image = image ?? UIImage(named: "logo")
            //chatImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
            
            self.scrollView.delegate = self
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 1.5
            
            setupGestureRecognizer()

        }else {
            chatImage.isHidden = true
            webView.isHidden = false
            
            let url = URL(string: fileLink)
            webView.load(URLRequest(url: url!))
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        self.chatImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @objc func handleDoubleTap() {
        if self.scrollView.zoomScale == 1 {
            self.scrollView.zoom(to: zoomRectForScale(self.scrollView.maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            self.scrollView.setZoomScale(1, animated: true)
        }
    }
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = chatImage.frame.size.height / scale
        zoomRect.size.width = chatImage.frame.size.width / scale
        let newCenter = chatImage.convert(center, from: chatImage)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 1.5)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 1.5)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.chatImage
    }

    
}
