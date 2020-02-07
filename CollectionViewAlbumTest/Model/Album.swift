//
//  Album.swift
//  CollectionViewAlbumTest
//
//  Created by Greg Hughes on 2/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

struct Album : Codable {
    let albumId : Int
    let id : Int
    let title : String
    let url : URL
    let thumbnailUrl : URL
}



