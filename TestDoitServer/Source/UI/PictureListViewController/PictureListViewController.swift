//
//  PictureListViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/21/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PictureUploadViewControllerDelegate, UIPopoverPresentationControllerDelegate
{
    @IBOutlet var collectionView: UICollectionView?
    let cellNibName = String(describing: PictureCollectionViewCell.self)
    var imageCollection = ImageCollection()
    let cellsPerRow = 2
    let gifOffset = 16
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else { return }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add,
                                                              target: self,
                                                              action: #selector(PictureListViewController.addImage)),
                                              UIBarButtonItem(image: #imageLiteral(resourceName: "gif"),
                                                              style: UIBarButtonItemStyle.plain,
                                                              target: self,
                                                              action: #selector(PictureListViewController.showGif))]
        
        collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellNibName)
        
        imageCollection.loadHandler = {[unowned self] in
            self.collectionView?.reloadData()
        }

        imageCollection.load()
    }
    
    override func viewDidLayoutSubviews() {
        //in two columns
        guard let collectionView = collectionView else { return }
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (CGFloat(cellsPerRow) - 1)
            let itemWidth = (collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow);
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
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
    
    //MARK:- UIAdaptivePresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK:-
    
    func addImage() {
        let uploadController = PictureUploadViewController()
        uploadController.delegate = self
        navigationController?.pushViewController(uploadController, animated: true)
    }
    
    func showGif() {
        let animationImagesNumber = 5
        var images = [UIImage]()
        for imageItem in imageCollection.items {
            if images.count == animationImagesNumber {
                break
            }
            
            if let image = imageItem.image {
                images.append(image)
            }
        }
        
        let gifController = GifViewController()
        gifController.images = images
        
        gifController.modalPresentationStyle = .popover
        guard let collectionView = collectionView else { return }
        
        let width = collectionView.bounds.size.width -  CGFloat(gifOffset * 2)
        gifController.preferredContentSize = CGSize(width: width, height: width)
        
        guard let popcontroller = gifController.popoverPresentationController else {return}
        popcontroller.delegate = self
        popcontroller.sourceView = view
        popcontroller.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        popcontroller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        present(gifController, animated: true, completion: nil)
    }
}
