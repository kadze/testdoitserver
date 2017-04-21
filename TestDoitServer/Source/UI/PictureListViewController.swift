//
//  PictureListViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/21/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureListViewController: UIViewController {

    var user: User
    
    //MARK:- Initializations and Deallocations
    
    init(_ user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PictureListViewController.addImage))
    }

    //MARK:-
    
    func addImage() {
        
    }
    
    //MARK:- Private
    
    

}
