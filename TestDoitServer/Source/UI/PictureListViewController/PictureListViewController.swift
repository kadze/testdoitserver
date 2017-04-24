//
//  PictureListViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/21/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PictureUploadViewControllerDelegate
{
    @IBOutlet var collectionView: UICollectionView?
    let cellNibName = String(describing: PictureCollectionViewCell.self)
    var imageCollection = ImageCollection()
    let cellsPerRow = 2
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else { return }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PictureListViewController.addImage))
        
        collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellNibName)
        
        imageCollection.loadHandler = {[unowned self] in
            self.collectionView?.reloadData()
        }
        
        //in two columns
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (CGFloat(cellsPerRow) - 1)
            let itemWidth = (collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow);
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }

        imageCollection.load()
    }
    
    //MARK:- UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellNibName, for: indexPath) as? PictureCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.model = imageCollection[indexPath.row]
        
        return cell
    }
    
    //MARK:- PictureUploadViewControllerDelegate 
    
    func pictureUploadControllerdidFinishLoading(_ controller: PictureUploadViewController) {
        imageCollection.load()
    }
    
    //MARK:-
    
    func addImage() {
        let uploadController = PictureUploadViewController()
        uploadController.delegate = self
        navigationController?.pushViewController(uploadController, animated: true)
    }
}
