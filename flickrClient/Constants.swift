//
//  Constants.swift
//  flickrClient
//
//  Created by Hamit Burak Emre on 23/04/17.
//  Copyright © 2017 Hamit Burak Emre. All rights reserved.
//

import Foundation

let BASE_URL    = "https://api.flickr.com/services/rest/?method="
let GET_RECENT  = "flickr.photos.getRecent"
let SEARCH      = "flickr.photos.search&text="
let HOT_LIST    = "flickr.tags.getHotList"
let GET_INFO    = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&photo_id="
let GET_USER    = "https://api.flickr.com/services/rest/?method=flickr.people.getInfo&user_id="
let API_KEY     = "&api_key=3d9147aee7458c094b9cc286f04dbb42"
let FORMAT      = "&format=json&nojsoncallback=1_m"

typealias DownloadComplete = () -> ()

