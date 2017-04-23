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
    
    //VARIABLES AND OUTLETS
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadPhotos {
            print("XYZ: Download completed")
        }
    }
    
    //TABLE VIEW FUNCTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("XYZ: \(posts.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? postCell{
            let post = posts[indexPath.row]
            cell.configureCell(post: post)
            return cell
        } else {
            return postCell()
        }
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
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            completed()
        }
    }
    


}

