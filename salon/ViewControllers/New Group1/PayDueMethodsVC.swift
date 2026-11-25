//
//  PayDueMethodsVC.swift
//  salon
//
//  Created by AL Badr  on 10/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PayDueMethodsVC: UIViewController {

    @IBOutlet weak var ePaymentView: UIStackView!
    
    var enable: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if enable {
            ePaymentView.isHidden = false
        }else {
            ePaymentView.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ePayBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ePayNotification"), object: nil, userInfo: nil)
    }
    
    @IBAction func bankBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bankNotification"), object: nil, userInfo: nil)
    }
 

}
