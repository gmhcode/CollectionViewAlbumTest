//
//  CollectionViewCell.swift
//  CollectionViewAlbumTest
//
//  Created by Greg Hughes on 2/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumIDLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var album : Album? {
        didSet {
            setUp()
        }
    }
    
    func setUp() {
        guard let album = album else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        albumIDLabel.text = "Album ID: " + String(album.albumId)
        idLabel.text = "ID: " + String(album.id)
        titleLabel.text = "Title: " + album.title
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
