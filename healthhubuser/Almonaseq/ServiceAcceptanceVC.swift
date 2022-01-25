//
//  ServiceProvidersVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ServiceAcceptanceVC: UITableViewController, ProviderCellDelegate , DetailsTitleTableViewCellDelegate {
    
    private let headerReuseIdentifier = "DetailsTitleTableViewCell"

    var reqId: String = ""
    var acceptances = [Provider]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProviderCell", bundle: nil), forCellReuseIdentifier: "ProviderCell")

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
           tableView.register(UINib(nibName: headerReuseIdentifier, bundle: nil), forCellReuseIdentifier: headerReuseIdentifier);
    }

    override func viewWillAppear(_ animated: Bool) {
        getAcceptances()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         if(section == 0){
//            return 1
//        }
        return acceptances.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(indexPath.section == 0){
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier, for: indexPath)as! DetailsTitleTableViewCell
//            if(Utils.getcurrentLanguage() == "ar"){
//                cell.titleLabel.text = "قائمة الفنيين"
//            }else{
//                cell.titleLabel.text = " Accepted Providers"
//            }
//
//            cell.delegate = self
//
//            return cell
//
//        }else if(indexPath.section == 1) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCell", for: indexPath)
            as? ProviderCell {
            cell.delegate = self
            
            cell.configureCell(provider: acceptances[indexPath.row])
            return cell
        }
       // }
            return UITableViewCell()
        
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }*/
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

 
    func getAcceptances(refresher: Bool = true) {
        if (reqId != "") {
            ServiceManager.getAcceptedRequests(reqId: reqId) { (acceptances) in
                print("acceptances \(acceptances)")
                self.acceptances = acceptances
                if(acceptances.isEmpty){
                    if(Utils.getcurrentLanguage() == "ar"){
                    Utils.showToast(message: "لا يوجد قبول حتى الان")
                    }else{
                        Utils.showToast(message: "No acceptance till now")
                    }
                }
                self.tableView.reloadData()
                if (refresher) {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    
 
    // Accept technicican request
    func didPressAcceptButton(sender: UIButton, provider: Provider) {
        
        if (reqId != nil) {
            UserManager.acceptRequest(reqId: reqId, techId: (provider.id), downloadComplete: { (res) in
                NotificationCenter.default.post(name: .Refreshorders, object: nil)
                self.navigationController?.popViewController(animated: true)
              //  self.dismiss(animated: true, completion: nil)
                //if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as? OrdersVC {
                    //vc.filter = RequestFilter.underProcessing;
                   //vc.navTitle = NSLocalizedString("menu.pendingOrder", comment: "")
                  //  self.navigationController?.setViewControllers([vc], animated: true)
                
                //                let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                //                self.navigationController?.popToViewController(vc, animated: true)
            })
            
        }
//        let vc = UIStoryboard(name: "Service", bundle: nil).instantiateViewController(withIdentifier: "ProviderDetailVC") as! ProviderDetailVC
//        vc.provider = provider
//        if (reqId != nil) {
//            vc.orderId = reqId
//            vc.imageUrl = acceptances[sender.tag].imageUrl;
//           vc.rating = acceptances[sender.tag].rating;
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
//        if (reqId != nil) {
//            UserManager.acceptRequest(reqId: reqId!, techId: provider.id, downloadComplete: { (res) in
//                self.getAcceptances()
//                let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "DealVC") as! DealVC
//                vc.provider = provider
//                vc.orderId = self.reqId
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//
//        }

    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        getAcceptances(refresher: true)
    }
    

    func openMapForPlace(latitude: Double, longitude: Double) {
     
                  
                  let regionDistance:CLLocationDistance = 10000
                  let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                  let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                  let options = [
                      MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                      MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                  ]
                  let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                  let mapItem = MKMapItem(placemark: placemark)
                  let loc: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
                  
                  let ceo: CLGeocoder = CLGeocoder()
                  var addressString : String = ""
                  ceo.reverseGeocodeLocation(loc, completionHandler:
                      {(placemarks, error) in
                          if (error != nil)
                          {
                              print("reverse geodcode fail: \(error!.localizedDescription)")
                          }
                          let pm = placemarks! as [CLPlacemark]
                          
                          if pm.count > 0 {
                              let pm = placemarks![0]
                              print(pm.country)
                              print(pm.locality)
                              //print(pm.thoroughfare)
                              print(pm.subThoroughfare)
                              
                              
                              if pm.thoroughfare != nil {
                                  addressString = addressString + pm.thoroughfare! + ", "
                              }
                              if pm.locality != nil {
                                  addressString = addressString + pm.locality! + ", "
                              }
                              if pm.country != nil {
                                  addressString = addressString + pm.country!
                              }
                              
                              print(addressString)
                              mapItem.name = addressString
                              //mapItem.openInMaps(launchOptions: options)
                              if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
                              {
                                  UIApplication.shared.openURL(NSURL(string:
                                   "comgooglemaps://?saddr=&daddr=\(Double(latitude)),\(Double(longitude))&directionsmode=driving")! as URL)
                              } else
                              {
                                  NSLog("Can't use com.google.maps://");
                                  let alert = UIAlertController(title: "تنبيه", message: "برجاء تحميل تطبيق خرائط جوجل (Google Maps)لتفعيل الاتجاهات", preferredStyle: UIAlertControllerStyle.alert)
                                  alert.addAction(UIAlertAction(title: "تم", style: UIAlertActionStyle.default, handler: nil))
                                  self.present(alert, animated: true, completion: nil)
                              }
                          }
                  })
              
    }
    

}
