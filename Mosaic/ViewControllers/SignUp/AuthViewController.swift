//
//  AuthViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 27..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        self.okButton.titleLabel?.font = UIFont.nanumExtraBold(size: 14)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
        // Do any additional setup after loading the view.
    }
    @IBAction func okButtonDidTapped(_ sender: UIButton) {
        dismissViewController()
    }
    @objc
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
