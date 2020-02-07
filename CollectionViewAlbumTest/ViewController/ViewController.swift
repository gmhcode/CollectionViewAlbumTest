//
//  ViewController.swift
//  CollectionViewAlbumTest
//
//  Created by Greg Hughes on 2/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    let flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        AlbumController.fetchAlbums { (albums) in
            guard let albums = albums else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

            for album in albums {
                
                AlbumController.fetchUrlCache(album: album) {
                    print(AlbumController.urlCache)
                }
                AlbumController.fetchThumbnailURL(album: album) {
                    print(AlbumController.thumbnailCache)
                    
                }
            }
            DispatchQueue.main.async {
               self.collectionView.reloadData()
            }
            
        }
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumController.albums?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UICollectionViewCell()}

        
        cell.album = AlbumController.albums?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150 )
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? NewViewController
        guard let indexPath = collectionView.indexPathsForSelectedItems else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

        
        
        destination?.album = AlbumController.albums?[indexPath[0].row]
    }
}

