//
//  FullActivityIndicatorView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 31..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
import Lottie
class FullActivityIndicatorView: UIView {
    let animationView = LOTAnimationView(name: "loader.json")
    private let backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = UIScreen.main.bounds
        self.animationView.center = self.center
        self.backView.frame = self.bounds
    }
    
    func setUp() {
        self.addSubview(backView)
        self.backView.backgroundColor = .black
        self.backView.alpha = 0.2
        
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        self.addSubview(animationView)
        self.animationView.loopAnimation = true
    }
}

extension FullActivityIndicatorView {
    func play(){
        guard let window = UIApplication.shared.keyWindow else {return}
        window.addSubview(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        }) { (value) in
            self.animationView.play()
        }
    }
    
    func stop() {
        self.animationView.stop()
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (value) in
            self.removeFromSuperview()
        }
    }
}
