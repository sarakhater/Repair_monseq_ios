//
//  ServicesVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import Alamofire




class ServicesVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var categories = [Category]()
    let userDef = UserDefaults.standard
    var userId: String?
    var loggedIn = false;
    var selectedCategory: Category?
    var refreshControl: UIRefreshControl!
    var imageList : [ImageSlider] = [];
    
   
    func  getShareLinks(){
        Alamofire.request(Constants.Share_URL)
        .responseJSON{ (response) in
                if response.result.isSuccess {
                    guard  let data = response.result.value as? [String : Any] else {
                        return
                    }
                    print(data);
                    guard let json = data["status"] as? String else {
                        return
                    }
                    print(json)
                    if(json == "true"){
                        //show Payment Method
                        guard let dataLinks = data["data"] as? [String : Any] else{
                            return
                        }
                        ShareAndroidLink = dataLinks["android"] as? String ?? "";
                        ShareIphoneLink = dataLinks["iphone"]  as? String ?? "";
                    }else{
                      
                    }
                }
                else{
                    print("there was an error")
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSideMenu();
        getShareLinks();
       
    self.collectionView?.register(UINib(nibName:"ServicesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCollectionViewCell");
        
    self.collectionView?.register(UINib(nibName:"ImageSliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageSliderCollectionViewCell");
        
    collectionView?.register(headerCollectionReusableView.self, forSupplementaryViewOfKind:
            UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCollectionReusableView");
      
        
        userId = userDef.string(forKey: "user_id");
        loggedIn = userDef.bool(forKey: "logged_in");
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin(notification:)), name: .login, object: nil)
        
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
        loggedIn = userDef.bool(forKey: "logged_in")
        getImageSlider();
      
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0){
            return 1;
        }else{
            return categories.count;
        }
      
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as? ServicesCollectionViewCell;
        
        if(indexPath.section == 0){
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCollectionViewCell", for: indexPath) as? ImageSliderCollectionViewCell {
                cell.configureCell(images: self.imageList);
                       return cell
            
        }
        }
        else if(indexPath.section == 1){
         
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as? ServicesCollectionViewCell {
            cell.configureCell(category: categories[indexPath.row]);

            return cell
        } else {
            return UICollectionViewCell()
        }
        }
        return cell!;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if(section == 0){
            return CGSize(width: 0, height: 0);
        }else{
        return  CGSize(width: self.collectionView?.frame.size.width ?? 300, height: 80); // you can change here
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.section == 0){
            return CGSize(width:  (view.frame.width), height: 210);
        }
        else{
            return CGSize(width: 125.0, height: 130.0);
        }
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let collectionWidth: CGFloat = (self.collectionView?.frame.size.width)!
    //        let itemWidth: CGFloat = (collectionWidth - 40) / 3
    //        let itemHeight: CGFloat = itemWidth * 1
    //        return CGSize(width: itemWidth, height: itemHeight)
    //    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
         let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "headerCollectionReusableView",for: indexPath) as! headerCollectionReusableView;
        switch kind {
  case UICollectionElementKindSectionHeader:
        if indexPath.section == 1{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 45));
            label.center.x = self.view.center.x
            label.backgroundColor = Constants.MainColor;
            label.textAlignment = .center
            label.font = UIFont(name: Constants.boldFont, size: 25);
            label.textColor = UIColor.white
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 10;

            if(Utils.getcurrentLanguage() == "en"){
                     label.text = "Services Type";
                }else{
                    label.text = "التخصصات المتاحة";

            }
                headerView.addSubview(label)
                   //Your Code Here
//            if(Utils.getcurrentLanguage() == "en"){
//                       headerView.lBlTitle.text = "Select Services Type";
//                         }else{
//                       headerView.lBlTitle.text = "إختر نوع الخدمة";
//
//                         }
            
               } else {
               }
        
        default:
            assert(false, "Unexpected element kind")
        }
               return headerView
        

            
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        //self.collectionView?.register(UINib(nibName:"headerCollectionReusableView", bundle: nil), forCellWithReuseIdentifier: "headerCollectionReusableView")
//
//        self.collectionView?.register(UINib(nibName:"headerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "headerCollectionReusableView", withReuseIdentifier: "headerCollectionReusableView")
//        //        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
//        //        return headerView
//
//        var reusableview: UICollectionReusableView? = nil
//        if kind == UICollectionElementKindSectionHeader {
//            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCollectionReusableView", for: indexPath) // cellHea is your identifier
//            var labelHeader = reusableview?.viewWithTag(2) as! UILabel
//
//            if indexPath.section == 0 {
//                labelHeader.text = "Specialist Clinic"
//
//            }}
//        return reusableview!
//
//
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1){
        selectedCategory = categories[indexPath.row]
        print("selected item", indexPath.row)
        if (userDef.bool(forKey: "registered")) {
            if (userDef.bool(forKey: "activated")) {
                if (!loggedIn) {
                    let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVC.fromMenu = false
                    self.navigationController?.pushViewController(loginVC, animated: true)
                } else {
                    let requestVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
                    initRequestVC(category: selectedCategory!, vc: requestVC)
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
    }
    
    
    
    func getCategories(refresher: Bool = false) {
        ServiceManager.getServiceCategories(id: nil) { (categories) in
            self.categories = categories
            self.collectionView?.reloadData()
            if (refresher) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getImageSlider() {
        Alamofire.request(Constants.ImageSlider).responseObject { (response: DataResponse<ImageSliderData>) in
            
            let menuResponse = response.result.value;
            if(menuResponse?.data != nil){
                        self.imageList = (menuResponse?.data)!;
                        self.getCategories();
                       // self.tableView.reloadData();
                    }
        }
    }
    
    @objc func onLogin(notification: NSNotification) {
        print("on login notification")
        let currentStoryBoard = UIStoryboard(name: "User", bundle: nil)
        if let vc = currentStoryBoard.instantiateViewController(withIdentifier: "RequestVC") as? RequestVC {
            print("product present")
            if let category = selectedCategory {
                print("product present")
                initRequestVC(category: category, vc: vc)
                print("on login")
            }
        }
    }
    
    func initRequestVC(category: Category, vc: RequestVC) {
        vc.userId = userId
        vc.categoryId = category.id
        vc.requestType = "service"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        print("refreshing")
        getCategories(refresher: true);
        getImageSlider();
    }
    
  
    
}
