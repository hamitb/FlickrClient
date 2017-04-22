//
//  ViewController.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 22/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // VARIABLES AND OUTLETS
    var posts = [Post]()
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotos {
            print("XYZ: Download completed")
        }
    }
    
    //TABLE VIEW FUNCTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    //DOWNLOAD PHOTOS
    func downloadPhotos(completed: @escaping DownloadComplete) {
        let photoURL = URL(string:"\(BASE_URL)\(GET_RECENT)\(API_KEY)\(FORMAT)")!
        
        Alamofire.request(photoURL).responseJSON{ response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let photosDict = dict["photos"] as? Dictionary<String, AnyObject> {
                    
                    if let photos = photosDict["photo"] as? [Dictionary<String, AnyObject>] {
                        
                        for photo in photos {
                            let post = Post(photoDict: photo)
                            self.posts.append(post)
                            print(post.title)
                        }
                        
                    }
                }
            }
        }
    }
    


}

