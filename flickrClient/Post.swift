//
//  Post.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import Foundation

class Post {
    //Variables
    
    private var _id: String!
    private var _owner: String!
    private var _secret: String!
    private var _server: String!
    private var _farm : String!
    private var _title: String!
    
    
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
    
    var farm: String {
        if _farm == nil {
            return ""
        }
        
        return _farm
    }
    
    var title: String {
        if _title == nil {
            return ""
        }
        
        return _title
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
        
        if let photoFarm = photoDict["farm"] as? String {
            self._farm = photoFarm
        }
        
        if let photoTitle = photoDict["title"] as? String {
            self._title = photoTitle
        }
        
    }
    
}
