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
    }

}
