//
//  NewViewController.swift
//  CollectionViewAlbumTest
//
//  Created by Greg Hughes on 2/7/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    var album : Album?
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidLayoutSubviews() {
        
        if let album = album {
           
            let cachedImage = AlbumController.urlCache.object(forKey: album.url.absoluteString as NSString)
            dismissButton.backgroundColor = cachedImage?.averageColor?.inverseColor()
            view.backgroundColor = cachedImage?.averageColor
        }
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
