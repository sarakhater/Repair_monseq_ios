//
//  StoresVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 1/18/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ServicesCategoryCollectionViewCell"

class StoresVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var stores = [Store]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSideMenu()

//        self.collectionView?.register(StoreCell.self, forCellWithReuseIdentifier: "StoreCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)

        // Refresher
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl)
        if #available(iOS 10.0, *) {
           self.collectionView?.refreshControl = refreshControl
        } else {
            self.collectionView?.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllStores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ServicesCategoryCollectionViewCell {
            let currentStore: Store = stores[indexPath.row]
            cell.configureStoreCell(store: currentStore)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedStore = stores[indexPath.row]
        print("item selected")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsVC") as? ProductsVC {
            vc.storeId = selectedStore.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LogoHeader", for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize = CGSize()
        let  collectionWidth: CGFloat = (self.collectionView?.frame.size.width)!
        let itemWidth: CGFloat = (collectionWidth / 3) - 32
        let itemHeight: CGFloat = itemWidth * 1.4
        cellSize = CGSize(width: itemWidth, height: itemHeight)
        return cellSize

    }
    
    func getAllStores(refresher: Bool = false) {
        StoreManager.getAllStores { (stores) in
            self.stores = stores
            self.collectionView?.reloadData()
            if (refresher) {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        print("refreshing")
        getAllStores(refresher: true)
    }

}
