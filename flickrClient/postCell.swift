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
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postDate: UILabel!
    
    var usernameString: String = ""
    var iconfarm: Int = 0
    var iconserver: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post) {
        
        getUserProps(owner: post.owner) {
            self.userName.text = self.usernameString
            
            self.profilePic.imageFromServerURL(urlString: self.getProfileImageURL(farm: self.iconfarm, server: self.iconserver, owner: post.owner))
        }
        
        postImage.imageFromServerURL(urlString: getPostImageURL(farm: post.farm, server: post.server, id: post.id, secret: post.secret))
        
        postDate.text = "2 days ago"
    }
    
    func getProfileImageURL(farm: Int, server: String, owner: String) -> String {
        return "http://farm\(farm).staticflickr.com/\(server)/buddyicons/\(owner).jpg"
    }
    
    func getUserProps (owner: String ,completed: @escaping DownloadComplete) {
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.people.getInfo&user_id=\(owner)&api_key=3d9147aee7458c094b9cc286f04dbb42&format=json&nojsoncallback=1")!
        print("XYZ:\(owner)")
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let person = dict["person"] as? Dictionary<String, AnyObject> {
                    
                    if let username = person["username"] as? Dictionary<String, AnyObject> {
                        
                        if let content = username["_content"] as? String {
                            self.usernameString = content
                            
                        }
                    }
                    
                    if let iconF = person["iconfarm"] as? Int {
                        self.iconfarm = iconF
                    }
                    
                    if let iconS = person["iconserver"] as? String {
                        self.iconserver = iconS
                    }
                }
            }
        completed()
        }
    }
    
    func getPostImageURL (farm: Int, server: String, id: String, secret: String) -> String{
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_z.jpg"
    }
}
