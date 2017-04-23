//
//  postCell.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit
import Alamofire

class postCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!

    @IBOutlet weak var realName: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post) {
        profilePic.image = post.profileImage
        realName.text = post.realname
        postImage.image = post.postImage
        postDate.text = post.date
    }
    
    

}
