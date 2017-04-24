//
//  popularCell.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 24/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit

class popularCell: UICollectionViewCell {
   
    
    @IBOutlet weak var popularCell: UILabel!
    
    func configureCell(name: String) {
        popularCell.text = name
    }
}
