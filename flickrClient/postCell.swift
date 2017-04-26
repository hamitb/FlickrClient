//
//  postCell.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit
import PureLayout

class postCell: UITableViewCell {
    
    var profilePic: UIImageView = UIImageView.newAutoLayout()

    var realName: UILabel = UILabel.newAutoLayout()
    
    var postImage: UIImageView = UIImageView.newAutoLayout()
    
    var postDate: UILabel = UILabel.newAutoLayout()
    
    var didSetupConstraints = false
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews()
    {
        
        realName.numberOfLines = 1
        realName.textAlignment = .left
        realName.textColor = UIColor.darkGray
        
        
        postDate.numberOfLines = 1
        postDate.textAlignment = .right
        postDate.textColor = UIColor.darkGray
        
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = 20.0
        
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        
        
        updateFonts()
        
        contentView.addSubview(realName)
        contentView.addSubview(postDate)
        contentView.addSubview(profilePic)
        contentView.addSubview(postImage)
        
    }

    
    func configureCell(post: Post) {
        profilePic.image = post.profileImage
        realName.text = post.realname
        postDate.text = post.date
        postImage.image = post.postImage
    }
    
    override func updateConstraints()
    {
        if !didSetupConstraints {
            
            
            
            postDate.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8.0)
            postDate.autoPinEdge(toSuperviewEdge: .top, withInset: 18.0)
            postDate.autoSetDimension(.height, toSize: 24.0)
            
            profilePic.autoPinEdge(toSuperviewEdge: .leading, withInset: 8.0)
            profilePic.autoPinEdge(toSuperviewEdge: .top, withInset: 8.0)
            profilePic.autoSetDimensions(to: CGSize(width: 40, height: 40))
            
            realName.autoPinEdge(toSuperviewEdge: .top, withInset: 18.0)
            realName.autoPinEdge(.leading, to: .trailing, of: profilePic, withOffset: 8.0)
            
            postImage.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0.0)
            postImage.autoPinEdge(.top, to: .bottom, of: profilePic, withOffset: 8.0)
            postImage.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0.0)
            postImage.autoPinEdge(toSuperviewEdge: .leading, withInset: 0.0)
            
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func updateFonts()
    {
        realName.font = UIFont(name: "Avenir-Heavy", size: 16.0)
        postDate.font = UIFont(name: "AvenirNext-Regular", size: 13.0)
    }
}
