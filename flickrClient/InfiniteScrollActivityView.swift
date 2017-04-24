//
//  InfiniteScrollActivityView.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit
import Lottie

class InfiniteScrollActivityView: UIView {

    var animationView: LOTAnimationView?
    
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationView?.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        animationView = LOTAnimationView(name: "colorline")
        let frame = CGRect(x: self.bounds.size.width/2,
                           y: self.bounds.size.height/2,
                           width: 120,
                           height: 90)
        
        animationView?.frame = frame
        animationView?.loopAnimation = true
        self.addSubview(animationView!)
    }
    
    func stopAnimating() {
        self.animationView?.pause()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.animationView?.play()
    }

}
