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
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    
    
    var refreshControl: UIRefreshControl!
    
    /// This tells us if we have all 50 colors or not, when we do, the collection view will populate
    var viewCounter:  Int! {
        didSet {
            if viewCounter >= 50 {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    AlbumController.albums?.shuffle()
                    self.activityView.stopAnimating()
                     self.reloadData()
                    self.viewCounter = 0
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewCounter = 0
        setUpActivityView()
        setFlowLayout()
        refreshSetup()
        
        // MARK: - initial fetch
        AlbumController.fetchAlbums { (albums) in
            guard let albums = albums else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            for album in albums {
                AlbumController.fetchUrlCache(album: album) {
                    self.viewCounter += 1
                }
            }
        }
    }
    
    
    // MARK: - Setup Activity View
    func setUpActivityView() {
        activityView.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        activityView.layer.position = view.center
        activityView.startAnimating()
    }
    
    
    // MARK: - Refresh Setup
    func refreshSetup() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    
    // MARK: - Refresh function
    @objc func refreshControlPulled() {
        
        AlbumController.fetchAlbums { (albums) in
            guard let albums = albums else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            for album in albums {
                AlbumController.fetchUrlCache(album: album) {
                    DispatchQueue.main.async {
                        self.viewCounter += 1
                    }
                }
            }
        }
    }
    
    // MARK: - Setup Flow Layout
    func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Number of Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AlbumController.albums?.count ?? 0
    }
    // MARK: - CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UICollectionViewCell()}
        
        
        cell.album = AlbumController.albums?[indexPath.row]
        return cell
    }
    // MARK: - SizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 150 )
    }
    
    // MARK: - PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? NewViewController
        guard let indexPath = collectionView.indexPathsForSelectedItems else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        destination?.album = AlbumController.albums?[indexPath[0].row]
    }
    
    func reloadData() {
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            //Do the data reload here
            self.collectionView.reloadData()
        }, completion: nil)
    }
}

// MARK: - Shake Functions
extension ViewController {
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            refreshControlPulled()
        }
    }
}
