//
//  NewServiceViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 4/13/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit
import  Alamofire

class NewServiceViewController: UIViewController {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var sliderCollection: UICollectionView!
    
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    
    var categories = [Category]()
       let userDef = UserDefaults.standard
       var userId: String?
       var loggedIn = false;
       var selectedCategory: Category?
       var refreshControl: UIRefreshControl!
       var imageList : [ImageSlider] = [];
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
           loggedIn = userDef.bool(forKey: "logged_in")
          getImageSlider();
         
       }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if(Utils.getcurrentLanguage() == "ar"){
            self.title = "الخدمات";
        }else{
            self.title = "Services";
        }
       
        //buildSideMenu();
        getShareLinks();
           getImageSlider();
        var image = UIImage(named: "bg-2")!
        self.bigView.backgroundColor = UIColor(patternImage: image);
        
        serviceCollectionView.layer.borderColor = UIColor.lightGray.cgColor;
        //serviceCollectionView.layer.borderWidth = 1;
        serviceCollectionView.layer.cornerRadius = 20;
        
        sliderCollection.delegate = self;
        sliderCollection.delegate = self;
        serviceCollectionView.delegate = self;
        serviceCollectionView.delegate = self;
        
        self.serviceCollectionView?.register(UINib(nibName:"RepairHomeServicesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RepairHomeServicesCollectionViewCell");
               
        self.sliderCollection?.register(UINib(nibName:"RepairHomeImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RepairHomeImageCollectionViewCell");
               
        serviceCollectionView?.register(headerCollectionReusableView.self, forSupplementaryViewOfKind:
                   UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCollectionReusableView");
        
        userId = userDef.string(forKey: "user_id");
        loggedIn = userDef.bool(forKey: "logged_in");
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin(notification:)), name: .login, object: nil)
        
        // Refresher
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.serviceCollectionView?.addSubview(refreshControl)
        if #available(iOS 10.0, *) {
            self.serviceCollectionView?.refreshControl = refreshControl
        } else {
            self.serviceCollectionView?.addSubview(refreshControl)
        }
        
        self.sliderCollection?.addSubview(refreshControl)
        if #available(iOS 10.0, *) {
            self.sliderCollection?.refreshControl = refreshControl
        } else {
            self.sliderCollection?.addSubview(refreshControl)
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
    
    func getCategories(refresher: Bool = false) {
           ServiceManager.getServiceCategories(id: nil) { (categories) in
               self.categories = categories
               self.serviceCollectionView?.reloadData()
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
                if(self.imageList.count > 0){
                    //show collection
                    self.topConstraint.constant = 203
                    self.sliderCollection.reloadData();
                }else{
                    //hide collection
                    self.topConstraint.constant = 10
                }
                          
                           self.getCategories();
                           //self.tableView.reloadData();
                       }
           }
       }
       
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

}

extension NewServiceViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == serviceCollectionView){
            return categories.count;
        }
        else if (collectionView == sliderCollection){
            return imageList.count;
        }
        return 0;
        
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         if(collectionView == serviceCollectionView){
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepairHomeServicesCollectionViewCell", for: indexPath) as? RepairHomeServicesCollectionViewCell {
            cell.configureCell(category: categories[indexPath.row]);

              return cell}
         }else  if(collectionView == sliderCollection){
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepairHomeImageCollectionViewCell", for: indexPath) as? RepairHomeImageCollectionViewCell {
                if(imageList.count > 0){
                   cell.configureCell(imageSlider: self.imageList[indexPath.row]);
                }
            return cell
                
            }
        }
         
            return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if(collectionView == serviceCollectionView){
          
            return  CGSize(width: self.serviceCollectionView?.frame.size.width ?? 300, height: 80); // you can change here
          }
           return CGSize();
        }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
        {
             let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "headerCollectionReusableView",for: indexPath) as! headerCollectionReusableView;
            
            switch kind {
      case UICollectionElementKindSectionHeader:
            if collectionView == serviceCollectionView{
                let label = UILabel(frame: CGRect(x: 0, y: 5, width: (view.frame.width) - 50, height: 40));
                label.center.x = self.serviceCollectionView.center.x - 15
                label.backgroundColor = Constants.SencondColor;
                label.textAlignment = .center
                label.font = UIFont(name: Constants.boldFont, size: 22);
                label.textColor = UIColor.white
                label.layer.masksToBounds = true
                label.layer.cornerRadius = 20;

                if(Utils.getcurrentLanguage() == "en"){
                         label.text = "Services";
                    }else{
                        label.text = "الخدمات";

                }
                headerView.addSubview(label);
                
                   } else {
                   }
            
            default:
                assert(false, "Unexpected element kind");
            }
                   return headerView
            

                
        }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == serviceCollectionView){
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == serviceCollectionView ){
        let yourWidth = serviceCollectionView.bounds.width/2.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
        }else{
            return CGSize(width:  (view.frame.width) - 25, height: 350);
        }
    }
 
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//          if(collectionView == sliderCollection){
//              return CGSize(width:  (view.frame.width) - 20, height: 250);
//          }
//          else{
//              return CGSize(width: 150, height: 120);
//          }
//    }
}
