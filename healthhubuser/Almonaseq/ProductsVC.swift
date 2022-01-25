//
//  ProductsVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 1/18/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductCell"

class ProductsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var storeId: String?
    var products = [Product]()
    var loggedIn = false;
    let userDef = UserDefaults.standard
    var userId: String?
    var requestVC: RequestVC?
    var selectedProduct: Product?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "bg"))
       // self.collectionView?.backgroundView = imageView
        userId = userDef.string(forKey: "user_id")
        loggedIn = userDef.bool(forKey: "logged_in")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
      
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin(notification:)), name: .login, object: nil)
        }

    override func viewWillAppear(_ animated: Bool) {
        getStoreProducts()
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductCell {
            let currentProduct = products[indexPath.row]
            cell.configureCell(product: currentProduct)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        var currentStoryBoard: UIStoryboard
        if (storeId != nil) {
            selectedProduct!.storeId = storeId!
        }
        
        if (userDef.bool(forKey: "registered")) {
            if (userDef.bool(forKey: "activated")) {
                if (!loggedIn) {
                    let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVC.fromMenu = false
                    self.navigationController?.pushViewController(loginVC, animated: true)
                } else {
                    let requestVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
                    initRequestVC(product: selectedProduct!, vc: requestVC)
                }
            } else {
                let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
                activateVC.fromMenu = false
                self.navigationController?.pushViewController(activateVC, animated: true)
            }
            
        } else {
            let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            loginVC.fromMenu = false
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LogoHeader", for: indexPath)
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize()
        let  collectionWidth: CGFloat = (self.collectionView?.frame.size.width)!
        let itemWidth: CGFloat = (collectionWidth / 2) - 26
        let itemHeight: CGFloat = itemWidth * 0.95
        cellSize = CGSize(width: itemWidth, height: itemHeight)
        return cellSize
        
    }
    
    func getStoreProducts(refresher: Bool = false) {
        if (storeId != nil) {
            StoreManager.getStoreProducts(id: storeId!, downloadCompeted: { (products) in
                self.products = products
                self.collectionView?.reloadData()
                if (refresher) {
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    @objc func onLogin(notification: NSNotification) {
        print("on login notification")
        let currentStoryBoard = UIStoryboard(name: "User", bundle: nil)
        if let vc = currentStoryBoard.instantiateViewController(withIdentifier: "RequestVC") as? RequestVC {
            if let product = selectedProduct {
                print("product present")
                initRequestVC(product: product, vc: vc)
                print("on login")
            }
        }
    }
    
    func initRequestVC(product: Product, vc: RequestVC) {
        vc.userId = userId
        vc.selectedProduct = product
        vc.requestType = "product"
        print("on loginnnn")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        print("refreshing")
        getStoreProducts(refresher: true)
    }
 
}
