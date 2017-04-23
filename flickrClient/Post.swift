//
//  Post.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import Foundation
import UIKit

class Post {
    //Variables
    
    private var _id: String!
    private var _owner: String!
    private var _secret: String!
    private var _server: String!
    private var _farm : Int!
    
    
    var postImage: UIImage!
    var profileImage: UIImage!
    var realname: String!
    var iconfarm: Int!
    var iconserver: String!
    var date: String!
    var tags = [String]()
    
    
    var id: String {
        if _id == nil {
            return ""
        }
        
        return _id
    }
    
    var owner: String {
        if _owner == nil {
            return ""
        }
        
        return _owner
    }
    
    var secret: String {
        if _secret == nil {
            return ""
        }
        
        return _secret
    }
    
    var server: String {
        if _server == nil {
            return ""
        }
        
        return _server
    }
    
    var farm: Int {
        if _farm == nil {
            return -1
        }
        
        return _farm
    }
    
    
    //Constructor
    init(photoDict: Dictionary<String, AnyObject>) {
        
        if let photoId = photoDict["id"] as? String {
            self._id = photoId
        }
        
        if let photoOwner = photoDict["owner"] as? String {
            self._owner = photoOwner
        }
        
        if let photoSecret = photoDict["secret"] as? String {
            self._secret = photoSecret
        }
        
        if let photoServer = photoDict["server"] as? String {
            self._server = photoServer
        }
        
        if let photoFarm = photoDict["farm"] as? Int {
            self._farm = photoFarm
        }
    }
    
}
