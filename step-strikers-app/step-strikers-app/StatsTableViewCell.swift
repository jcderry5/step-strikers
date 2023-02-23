//
//  StatsTableViewCell.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit

class MyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var myCollectionView:UICollectionView?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height:60)
        
         myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
         myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
         myCollectionView?.backgroundColor = UIColor.clear
         myCollectionView?.dataSource = self
         myCollectionView?.delegate = self
         view.addSubview(myCollectionView ?? UICollectionView())
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 // how many cells to display
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        // need to change this to have the data we want to display
        myCell.backgroundColor = UIColor.black
        return myCell
    }
    
    
}
