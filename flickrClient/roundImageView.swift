//
//  roundImageView.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit

class roundImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        self.clipsToBounds = true
        
        /*
        let pinkColor = UIColor(red: 234.0/255.0, green: 1.0/255.0, blue: 126.0/255.0, alpha: 1 )
        
        layer.borderColor = pinkColor.cgColor
        layer.borderWidth = 1
        */
    }

}
