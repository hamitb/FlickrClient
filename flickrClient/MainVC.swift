//
//  ViewController.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 22/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //VARIABLES AND OUTLETS
    var posts = [Post]()
    var profileImage: UIImage!
    var postImage: UIImage!
    
    @IBOutlet weak var tableView: UITableView!
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadAllData {
            print("ZYX: Done")
        }
        
    }
    //TABLE VIEW FUNCTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return posts.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? postCell{
            let post = posts[indexPath.row]
            cell.configureCell(post: post)
            return cell
        } else {
            return postCell()
        }
        */
        return UITableViewCell()
    }

    //DOWNLOAD PHOTOS
    func downloadAllData(completed: @escaping DownloadComplete) {
        downloadInitialData {
            self.downloadProfileImagesData {
                self.downloadProfileImages {
                    self.downloadPostImages {
                        completed()
                    }
                }
            }
        }

    }
    func downloadInitialData(completed: @escaping DownloadComplete) {
        print("ZYX: downloadData")
        let photosURL = URL(string:"\(BASE_URL)\(GET_RECENT)\(API_KEY)\(FORMAT)")!
        
        Alamofire.request(photosURL).responseJSON{ response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let photosDict = dict["photos"] as? Dictionary<String, AnyObject> {
                    
                    if let photos = photosDict["photo"] as? [Dictionary<String, AnyObject>] {
                        
                        for photo in photos {
                            let post = Post(photoDict: photo)
                            self.posts.append(post)
                            print("ZYX: Downloading initial photo data")
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            completed()
        }
    }
    
    func downloadPostImages(completed: @escaping DownloadComplete) {
        print("ZYX: downloadPostImages")
        for post in posts {
            let photoURL = URL(string: (self.getPostImageURL(farm: post.farm , server: post.server, id: post.id , secret: post.secret)))!
            
            Alamofire.request(photoURL).responseImage { response in
                
                if let image = response.result.value {
                    print("ZYX: Post Images downloaded")
                    post.postImage = image
                }
                
                if(self.AllPostImagesDownloaded()){completed()}
            }
        }
    }
    
    func downloadProfileImagesData(completed: @escaping DownloadComplete) {
        print("ZYX: downloadProfileImagesData")
        for post in posts {
            let dataURL = URL(string: "\(GET_USER)\(post.owner)\(API_KEY)\(FORMAT)")!
            
            Alamofire.request(dataURL).responseJSON { response in
                let result = response.result
                print("ZYX: Downloading profile data")
                if let dict = result.value as? Dictionary<String, AnyObject> {

                    if let person = dict["person"] as? Dictionary<String, AnyObject> {
    
                        if let realname = person["realname"] as? Dictionary<String, AnyObject> {
                            
                            if let content = realname["_content"] as? String {
                                post.realname = content
                            }
                        }
                        
                        if let iconF = person["iconfarm"] as? Int {
                            post.iconfarm = iconF
                        }
                        
                        if let iconS = person["iconserver"] as? String {
                            post.iconserver = iconS
                        }
                    }
                }
                if(self.AllProfileDataDownloaded()){completed()}
            }
        }
        
    }
    
    
    
    func downloadProfileImages(completed: @escaping DownloadComplete) {
        print("ZYX: downloadProfileImages")
        for post in posts {
            let profileURL = URL(string: (self.getProfileImageURL(farm: post.iconfarm, server: post.iconserver, owner: post.owner)))!
            
            Alamofire.request(profileURL).responseImage { response in
                
                if let image = response.result.value {
                    print("ZYX: Profile image added")
                    post.profileImage = image
                } else {
                    print("ZYX: Profile image added")
                    post.profileImage = UIImage(named: "default_profile")
                }
                
                if(self.AllProfileImagesDownloaded()){completed()}
            }
        }
        
    }
    
    func AllProfileImagesDownloaded() -> Bool {
        for post in posts {
            if(post.profileImage == nil){
                return false
            }
        }
        
        return true
    }
    
    func AllPostImagesDownloaded() -> Bool {
        for post in posts {
            if(post.postImage == nil){
                return false
            }
        }
        
        return true
    }
    
    func AllProfileDataDownloaded() -> Bool {
        for post in posts {
            if (post.iconserver == nil){
                return false
            }
        }
        
        return true
    }
    
    
    func getPostImageURL (farm: Int, server: String, id: String, secret: String) -> String{
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    func getProfileImageURL(farm: Int, server: String, owner: String) -> String {
        return "http://farm\(farm).staticflickr.com/\(server)/buddyicons/\(owner).jpg"
    }


}

