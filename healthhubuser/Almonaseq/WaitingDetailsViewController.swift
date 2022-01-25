//
//  WaitingDetailsViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 2/5/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import CoreLocation
class WaitingDetailsViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var stackTopConstarint: NSLayoutConstraint!
      @IBOutlet weak var bigView: UIView!
      @IBOutlet weak var orderImageView: UIImageView!
      @IBOutlet weak var orderTitleLabel: UILabel!
      @IBOutlet weak var orderServicesLabel: UILabel!
      @IBOutlet weak var orderServicesTypeLabel: UILabel!
      @IBOutlet weak var orderCityLabel: UILabel!
      @IBOutlet weak var orderCPriceLabel: UILabel!
      @IBOutlet weak var orderStatus: UIButton!
      @IBOutlet weak var cancelBtn: UIButton!
      @IBOutlet weak var selectTechBtn: UIButton!
      @IBOutlet weak var rateLabel: UILabel!
      @IBOutlet weak var proiderNameLabel: UILabel!
      @IBOutlet weak var providerJobLabel: UILabel!
      @IBOutlet weak var providerImageView: UIImageView!
       @IBOutlet weak var orderTimeLabel: UILabel!
      
      @IBOutlet weak var providerView: UIView!
      
      var selectedRequest: Request?
      var filter = RequestFilter.waited;
      var translatedTitles = [String: String]()
      var address = ""
    var requestType = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
         NotificationCenter.default.addObserver(self, selector: #selector(back(notification:)), name: .Refreshorders, object: nil)
    }
    @objc func back(notification : Notification){
        self.dismissView()
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView(){
        bigView.layer.cornerRadius = 10
        bigView.layer.borderWidth = 1
        bigView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        
        providerView.layer.cornerRadius = 10
        providerView.layer.borderWidth = 1
        providerView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        
        orderStatus.layer.cornerRadius = 5
        orderImageView.layer.cornerRadius = 5
        orderImageView.layer.borderWidth = 1
        orderImageView.layer.borderColor = UIColor(red: 112/255 , green: 112/255, blue:112/255 , alpha: 1.0).cgColor
        translatedTitles = [
            "awaiting": NSLocalizedString("orders.awaitingApproval", comment: ""),
            "accept": NSLocalizedString("orders.accept", comment: ""),
            "pending": NSLocalizedString("orders.pending", comment: ""),
            "rate": NSLocalizedString("orders.addRate", comment: ""),
            "completed": NSLocalizedString("orders.completed", comment: ""),
            "Cancel The Technician" :  NSLocalizedString("orders.cancelTechnician", comment: ""),
            "Select The Technician" :  NSLocalizedString("orders.accept", comment: ""),
            "Cancel Order" :  NSLocalizedString("orders.cancelOrder", comment: ""),"canceled" : NSLocalizedString("order.canceled", comment: "")]
        
        
        cancelBtn.layer.cornerRadius = 10
        selectTechBtn.layer.cornerRadius = 10
        if(filter == RequestFilter.waited){
            self.providerView.isHidden = true
            stackTopConstarint.constant = 10
        }
        else{
            self.providerView.isHidden = false
            stackTopConstarint.constant = 100
        }
        configureView(request: selectedRequest!)
         if(Utils.getcurrentLanguage() == "ar"){
                   backBtn.setImage(UIImage(named: "arrow-right"), for: .normal)
                     navTitle.text = "طلباتي"
               }else{
                    backBtn.setImage(UIImage(named: "arrow-left"), for: .normal)
                   navTitle.text = "My Orders"
               }
        
    }
    
      @IBAction func back(_ sender: Any) {
        self.dismissView()
    }

     @IBAction func cancelOrder(_ sender: Any) {
           print("cancelllllllllllll")
         canelOrder(request: selectedRequest!)
       }
       @IBAction func selectOrCancelTech(_ sender: Any) {
        if(filter == RequestFilter.waited){
            chooseTech(request: selectedRequest!)
           } else if(filter == .underProcessing){
            cancelTech(request: selectedRequest!)
           }
       }
 
       func configureView(request: Request) {
           self.selectedRequest = request
        if(selectedRequest?.status  == 1){
               orderStatus.setTitle(translatedTitles["awaiting"], for: .normal)
               orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
               selectTechBtn.setTitle(translatedTitles["Select The Technician"], for: .normal)
            stackTopConstarint.constant = 10
               
               
           }else if(selectedRequest?.status  == 2){
               orderStatus.setTitle(translatedTitles["pending"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
               selectTechBtn.setTitle(translatedTitles["Cancel The Technician"], for: .normal)
            stackTopConstarint.constant = 100
            self.providerView.isHidden = false
            proiderNameLabel.text = request.userName
            providerJobLabel.text = request.userPhone
               
               
           }
        
           else if(request.status == 3){
                 //انتهي التنفيذ
               orderStatus.setTitle(translatedTitles["canceled"], for: .normal)
            orderStatus.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
            selectTechBtn.isHidden = true
            cancelBtn.isHidden = true
            self.providerView.isHidden = false
            stackTopConstarint.constant = 100
            proiderNameLabel.text = request.userName
            providerJobLabel.text = request.userPhone
           }
        orderTimeLabel.text = request.serviceTime
           orderServicesLabel.text = request.main_cat ;
           orderServicesTypeLabel.text =  request.subCat;
           if(request.lat !=  "" || request.lng != ""){
               latLong(lat: Double(request.lat) as! Double, long:  Double(request.lng)  as! Double);
               orderCityLabel.text = self.address;
           }
           else{
               orderCityLabel.text = request.address;
           }
           orderCPriceLabel.text = request.price;
       }
       
       
       func latLong(lat: Double,long: Double) {
           var add_street : String = "" , add_city : String = "" , add_country : String = ""
           let geoCoder = CLGeocoder()
           let location = CLLocation(latitude: lat , longitude: long)
           geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
               
               print("Response GeoLocation : \(placemarks)")
               var placeMark: CLPlacemark!
               placeMark = placemarks?[0]
               
               // Country
               if(placeMark != nil){
                   if let country = placeMark.addressDictionary!["Country"] as? String {
                       print("Country :- \(country)")
                       add_country = country ;
                       // City
                       if let city = placeMark.addressDictionary!["City"] as? String {
                           print("City :- \(city)")
                           add_city =  city;
                           
                       }
                       
                   }
                   self.address = add_city + "," + add_country;
                   if(self.address == ""){
                       self.orderCityLabel.text =  self.selectedRequest?.address;
                   }else{
                       self.orderCityLabel.text =  self.address;
                   }
               }//place mark != nil
               
               
           })
           
       }
       

}

extension WaitingDetailsViewController{
    
       func cancelTech(request: Request) {
           
           let alert = UIAlertController(title: NSLocalizedString("orders.alert.title", comment: ""), message:  NSLocalizedString("orders.alert.deleteTecnician", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
           alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
           
           alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.ok", comment: ""), style: .default, handler: { action in
               switch action.style{
               case .default:
                   print("default")
                   UserManager.cancelOrderTech(reqId: request.id){
                       (res) in
                    self.dismiss(animated: true, completion: nil)
                       
                   }
               case .cancel:
                   print("cancel")
                   
               case .destructive:
                   print("destructive")
               }}))
           present(alert, animated: true, completion: nil)
       }
       
       func canelOrder(request: Request) {
           
           let alert = UIAlertController(title: NSLocalizedString("orders.alert.title", comment: ""), message: NSLocalizedString("orders.alert.deleteOrder", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
           alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
           
           alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.ok", comment: ""), style: .default, handler: { action in
               switch action.style{
               case .default:
                   print("default")
                   self.showDeleteReasonsArrayInAlert(request: request);
                   
               case .cancel:
                   print("cancel")
                   
               case .destructive:
                   print("destructive")
               }}))
           present(alert, animated: true, completion: nil)
       }
       
       func showDeleteReasonsArrayInAlert(request: Request){
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
           let contentViewController = NewDeleteOrdersViewController()
           contentViewController.requestId = request.id;
           var frame = CGSize(width: self.view.frame.width + 300, height: 300);
           contentViewController.preferredContentSize = frame;
           alertController.setValue(contentViewController, forKey: "contentViewController")
           present(alertController, animated: true, completion: nil)
           
       }
       
       
       func chooseTech(request: Request) {
           switch request.status {
           case 1:
               // Awaiting approval
               // Go to tech accept page
               let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ServiceAcceptanceVC") as! ServiceAcceptanceVC
               vc.reqId = request.id
               vc.modalPresentationStyle = .fullScreen
               //self.present(vc, animated: true, completion: nil)
               self.navigationController?.pushViewController(vc, animated: true);
            
           case 2:
            cancelTech(request: request)
            
           default:
               // completed
               // Go to review page
               print("go to review")
               let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
               vc.request = request;
               self.navigationController?.pushViewController(vc, animated: true)
           }
       }
       
       func dismissView() {
           self.dismiss(animated: true, completion: nil)
       }
       func rateTech() {
           print("go to review")
           let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
           vc.request = selectedRequest;
           self.navigationController?.pushViewController(vc, animated: true)
       }
       
}
