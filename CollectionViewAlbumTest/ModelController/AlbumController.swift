//
//  AlbumControll.swift
//  CollectionViewAlbumTest
//
//  Created by Greg Hughes on 2/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class AlbumController {
    static var albums : [Album]?
    static let urlCache = NSCache<NSString, UIImage>()
    static let thumbnailCache = NSCache<NSString,UIImage>()
    
    static func fetchAlbums(completion: @escaping ([Album]?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=1") else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                completion(nil)
                return
            }
            
            guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

            
            do {
                let jsonDecoder = JSONDecoder()
                let albums = try jsonDecoder.decode([Album].self, from: data)
//                print(albums)
                AlbumController.albums = albums
                completion(albums)
                
            }catch let er{
                
                print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                completion(nil)
                return
            }
            
            
            
            
        }.resume()
        
    }
    
    
    static func fetchUrlCache(album: Album, completion: @escaping () -> ()) {
        
        let url = album.url
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                completion()
                return
            }
            guard let data = data, let image = UIImage(data: data) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            AlbumController.urlCache.setObject(image, forKey: url.absoluteString as NSString)
        }.resume()
    }
    
    
    static func fetchThumbnailURL(album: Album, completion: @escaping () -> ()) {
        
        let url = album.thumbnailUrl
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                completion()
                return
            }
            guard let data = data, let image = UIImage(data: data) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            AlbumController.urlCache.setObject(image, forKey: url.absoluteString as NSString)
        }.resume()
    }
    
}
class ASD {
    var blah = "blah"
}
