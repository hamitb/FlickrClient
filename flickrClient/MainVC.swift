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
import DateToolsSwift
import Lottie
import PureLayout

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate{
    
    //VARIABLES AND OUTLETS
    var posts = [Post]()
    var profileImage: UIImage!
    var postImage: UIImage!
    var page: Int = 1
    var perPage: Int = 10
    var isMoreDataLoading: Bool!
    var loadingMoreView: InfiniteScrollActivityView?
    var initialAnimation: InfiniteScrollActivityView?
    var query: String = ""
    var searching: Bool = false
    
    var tableView: UITableView = UITableView()
    var searchBar: UISearchBar = UISearchBar()
    
    var headerView = UIImageView()
    var button = UIButton()


    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupHeader()
        setupButton()
        setupLogo()
        setupSearchBar()
        setupTableView()
        
        setupLoadingAnimation()
        setupInitialAnimation()
        
        startInitialAnimation()
        
        downloadAllData {
            self.stopInitialAnimation()
        }
    }
    
    
    //VIEW SETUPS
    
    func setupHeader() {
        let headerImage = #imageLiteral(resourceName: "background_darker")
        headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        headerView.clipsToBounds = true
        headerView.image = headerImage
        headerView.contentMode = .scaleAspectFill
        headerView.isUserInteractionEnabled = true
        self.view.addSubview(headerView)
    }
    
    func setupButton() {
        button = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        button.setImage(#imageLiteral(resourceName: "home"), for: .normal)
        button.addTarget(self, action: #selector(self.homePressed(sender:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        headerView.addSubview(button)
        
        
        button.autoPinEdge(.left, to: .left, of: headerView, withOffset: 16)
        button.autoPinEdge(.top, to: .top, of: headerView, withOffset: 30)
        
        button.autoSetDimensions(to: CGSize(width: 32, height: 32))
        
        
    }
    
    
    func homePressed(sender: UIButton!) {
            if (searching){
                self.searchBar.text = ""
                self.view.endEditing(true)
                self.searching = false
                self.posts = []
                self.page = 1
                self.refreshUI()
                startInitialAnimation()
                downloadAllData {
                    self.stopInitialAnimation()
                    self.refreshUI()
                    self.tableView.setContentOffset(CGPoint(x: 0.0, y: 0.0) , animated: false)
                }
            }
    }
    
    func setupLogo() {
        let logo1 = UILabel.newAutoLayout()
        logo1.text = "flick"
        logo1.font = UIFont(name: "AvenirNext-Bold", size: 34)
        logo1.textColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
        headerView.addSubview(logo1)
        
        logo1.autoAlignAxis(.vertical, toSameAxisOf: headerView, withOffset: -5)
        logo1.autoPinEdge(.top, to: .top, of: headerView, withOffset: 32)
        logo1.autoSetDimensions(to: CGSize(width: 72, height: 30))
        
        let logo2 = UILabel.newAutoLayout()
        logo2.text = "r"
        logo2.font = UIFont(name: "AvenirNext-Bold", size: 34)
        logo2.textColor = UIColor(red: 254.0/255.0, green: 0.0/255.0, blue: 134.0/255.0, alpha: 1)
        headerView.addSubview(logo2)
        
        logo2.autoPinEdge(.left, to: .right, of: logo1, withOffset: -1.2)
        logo2.autoPinEdge(.top, to: .top, of: headerView, withOffset: 32)
        logo2.autoSetDimensions(to: CGSize(width: 13, height: 30))
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        searchBar.autoSetDimension(.height, toSize: 44.0)
        searchBar.autoPinEdge(.top, to: .bottom, of: headerView)
        searchBar.autoPinEdge(toSuperviewEdge: .leading, withInset: 0.0)
        searchBar.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0.0)
        searchBar.barTintColor = UIColor(red: 234.0/255.0, green: 1.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 0)
        tableView.autoPinEdge(.bottom, to: .bottom, of: self.view, withOffset: 0)
        tableView.autoPinEdge(.left, to: .left, of: self.view, withOffset: 0)
        tableView.autoPinEdge(.right, to: .right, of: self.view, withOffset: 0)
        tableView.allowsSelection = false
        tableView.register(postCell.self, forCellReuseIdentifier: "postCell")
    }
    
    
    //TABLE VIEW FUNCTIONS
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? postCell{
            cell.updateFonts()
            let post = posts[indexPath.row]
            cell.configureCell(post: post)
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            return cell
        } else {
            return postCell()
        }
 
    }
    
    //SEARCH BAR
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        query = searchBar.text!
        
        if(query == "") {
            searching = false
        } else {
            searching = true
            posts = []
        }
        
        if(searching){
            self.refreshUI()
            self.view.endEditing(true)
            self.page = 1
            startInitialAnimation()
            downloadAllData {
                self.stopInitialAnimation()
                self.refreshUI()
                self.tableView.setContentOffset(CGPoint(x: 0.0, y: 0.0) , animated: false)
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 100, width: screenSize.width - 10, height: 10))
        self.view.addSubview(myView)
    }

    
    
    //DOWNLOAD PHOTOS
    func downloadAllData(completed: @escaping DownloadComplete) {
        downloadInitialData {
            self.downloadProfileImagesData {
                self.downloadProfileImages {
                    self.downloadPostImagesData {
                        self.downloadPostImages {
                            completed()
                        }
                    }
                }
            }
        }

    }
    func downloadInitialData(completed: @escaping DownloadComplete) {
        print("ZYX: downloadData")
        let url:String!
        
        if(!searching || query == "") {
            url = "\(BASE_URL)\(GET_RECENT)\(API_KEY)\(FORMAT)&per_page=\(perPage)&page=\(page)"
        } else {
            query = query.replacingOccurrences(of: " ", with: "%20")
            url = "\(BASE_URL)\(SEARCH)\(query)\(API_KEY)\(FORMAT)&per_page=\(perPage)&page=\(page)"
        }
        
        let photosURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
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
            if (post.postImage == nil){
                let photoURL = URL(string: (self.getPostImageURL(farm: post.farm , server: post.server, id: post.id , secret: post.secret)))!
                
                Alamofire.request(photoURL).responseImage { response in
                    
                    if let image = response.result.value {
                        print("ZYX: Post Images downloaded")
                        post.postImage = image
                    }
                    print("HMT: \(self.AllPostImagesDownloaded())")
                    if(self.AllPostImagesDownloaded()){completed()}
                }
            }
        }
    }
    
    func downloadProfileImagesData(completed: @escaping DownloadComplete) {
        print("ZYX: downloadProfileImagesData")
        for post in posts {
            if (post.iconserver == nil){
                let dataURL = URL(string: "\(GET_USER)\(post.owner)\(API_KEY)\(FORMAT)")!
                
                Alamofire.request(dataURL).responseJSON { response in
                    let result = response.result
                    
                    if let dict = result.value as? Dictionary<String, AnyObject> {
                        if let person = dict["person"] as? Dictionary<String, AnyObject> {
                            print("ZYX: Downloading profile data")
                            if let usernameDict = person["username"] as? Dictionary<String, AnyObject> {
                                var nameText = ""
                                if let realnameDict = person["realname"] as? Dictionary<String, AnyObject> {
                                    if let realname = realnameDict["_content"] as? String {
                                        nameText = realname
                                    }
                                }
                                
                                if (nameText == "") {
                                    if let username = usernameDict["_content"] as? String {
                                        nameText = username
                                    }
                                }
                                
                                
                                post.realname = nameText
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
        
    }
    
    func downloadPostImagesData(completed: @escaping DownloadComplete) {
        print("ZYX: downloadPostImagesData")
        for post in posts {
            if (post.date == nil){
                let dataURL = URL(string: "\(GET_INFO)\(post.id)\(API_KEY)\(FORMAT)")!
                
                Alamofire.request(dataURL).responseJSON { response in
                    let result = response.result
                    
                    if let dict = result.value as? Dictionary<String, AnyObject> {
                        if let photos = dict["photo"] as? Dictionary<String, AnyObject> {
                            if let dates = photos["dates"] as? Dictionary<String, AnyObject> {
                                
                                if let date = dates["posted"] as? String {
                                    let dateInt = Int(date)
                                    post.date = self.dateString(givenDate: dateInt!)
                                }
                                
                            }
                            
                            if let tagDict = dict["tags"] as? Dictionary<String, AnyObject> {
                                
                                if let tags = tagDict["tag"] as? [Dictionary<String, AnyObject>] {
                                    
                                    for tag in tags {
                                        
                                        post.tags.append(tag["_content"] as! String)
                                        
                                    }
                                }
                            }

                        }
                    }
                
                    if(self.AllPostImagesDataDownloaded()){completed()}
                }
            }
        }
        
    }
    
    
    
    func downloadProfileImages(completed: @escaping DownloadComplete) {
        print("ZYX: downloadProfileImages")
        for post in posts {
            if (post.profileImage == nil){
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
    
    func AllPostImagesDataDownloaded() -> Bool {
        for post in posts {
            if(post.date == nil){
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
    
    
    //INFINITE SCROLL & ANIMATIONS
    
    func setupLoadingAnimation() {
        isMoreDataLoading = false
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    func setupInitialAnimation() {
        isMoreDataLoading = false
        let frame = CGRect(x: self.view.frame.width/2-10,
                           y: 140,
                           width: tableView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        initialAnimation = InfiniteScrollActivityView(frame: frame)
        initialAnimation!.isHidden = true
        self.view.addSubview(initialAnimation!)
    }
    
    func startInitialAnimation() {
        isMoreDataLoading = true
        initialAnimation!.startAnimating()
    }
    
    func stopInitialAnimation() {
        self.initialAnimation!.stopAnimating()
        self.isMoreDataLoading = false
        self.refreshUI()
    }
    
    func startLoadingAnimation() {
        isMoreDataLoading = true
        let frame = CGRect(x: 0,
                           y: tableView.contentSize.height+15,
                           width: tableView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
    }
    
    func stopLoadingAnimation() {
        self.loadingMoreView!.stopAnimating()
        self.isMoreDataLoading = false
        self.refreshUI()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                startLoadingAnimation()
                page = page + 1
                downloadAllData {
                    self.stopLoadingAnimation()
                }
            }
            
        }
    }
    
    //HELPER FUNCTIONS
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dateString(givenDate: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(givenDate))
        
        return "\(date.shortTimeAgoSinceNow)"
    }
}

