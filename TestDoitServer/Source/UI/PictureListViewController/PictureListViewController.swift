//
//  PictureListViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/21/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView?
    let reuseIdentifier = String(describing: PictureCollectionViewCell.self)
    var imageCollection = ImageCollection()
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PictureListViewController.addImage))
        collectionView?.register(PictureCollectionViewCell.self,
                                 forCellWithReuseIdentifier: reuseIdentifier)
        
        imageCollection.loadHandler = {[unowned self] in
            if (self.collectionView?.dataSource) != nil {
                self.collectionView?.reloadData()
            } else {
                print ("?")
            }
        }
        
        imageCollection.load()
    }
    
    //MARK:- UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureCollectionViewCell else
        {
            return UICollectionViewCell()
        }
        
        cell.model = imageCollection[indexPath.row]
        
        return cell
    }
    
    //MARK:-
    
    func addImage() {
        navigationController?.pushViewController(PictureUploadViewController(), animated: true)
    }
}
