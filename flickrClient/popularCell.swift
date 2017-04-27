//
//  popularCell.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 27/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit
import PureLayout

class popularCell: UITableViewCell {
    
    var hotTag: UILabel = UILabel.newAutoLayout()
    var tagImageView: UIImageView = UIImageView.newAutoLayout()
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
        
        hotTag.numberOfLines = 1
        hotTag.textAlignment = .left
        hotTag.textColor = UIColor.black
        
        tagImageView.image = #imageLiteral(resourceName: "tagImage")
        
        contentView.addSubview(hotTag)
        contentView.addSubview(tagImageView)

        updateFonts()        
    }
    
    override func updateConstraints()
    {
        if !didSetupConstraints {

            tagImageView.autoSetDimensions(to: CGSize(width: 16, height: 16))
            tagImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 16.0)
            tagImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
            
            hotTag.autoSetDimensions(to: CGSize(width: 200, height: 18.0))
            hotTag.autoPinEdge(toSuperviewEdge: .trailing, withInset: 8.0)
            hotTag.autoPinEdge(.left, to: .right, of: tagImageView, withOffset: 8.0)
            hotTag.autoPinEdge(toSuperviewEdge: .top, withInset: 9.0)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func configureCell(tagName: String) {
        hotTag.text = tagName
    }
    
    func updateFonts()
    {
        hotTag.font = UIFont(name: "AvenirNext-Regular", size: 15.0)
    }

}
