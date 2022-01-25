//
//  OrdersVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/26/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import SimpleImageViewer
import SDWebImage
import MapKit
import MessageUI

private let reuseIdentifier = "NewOrderTableViewCell"
private let tipReuseIdentifier = "TipInfoOrderTableViewCell"
private let canceledReuseIdentifier = "CanceledOrdersTableViewCell"
private let  completedReuseIdentifier = "RepairCompletedTableViewCell"
private let  waitingReuseIdentifier = "RepairWaitingOrderTableViewCell"
private let schoolOrderTableViewCellIdentifier = "SchoolOrderTableViewCell"


class OrdersVC: UITableViewController, OrderCellDelegate  ,  MFMessageComposeViewControllerDelegate  {
    let fromMenu = true
    var requests = [Request]()
    var navTitle: String = NSLocalizedString("menu.myOrder", comment: "")
    var filter = RequestFilter.waited;
    var requestType = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        if(Utils.getcurrentLanguage() == "ar"){
            
            self.title = "الطلبات"
        }else{
            
            self.title = "Orders"
            
        }
        var image = UIImage(named: "bg-2")!
        self.tableView.backgroundColor = UIColor(patternImage: image);
        if (fromMenu) {
            // buildSideMenu()
        }
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier);
        
        tableView.register(UINib(nibName: tipReuseIdentifier, bundle: nil), forCellReuseIdentifier: tipReuseIdentifier);
        
        tableView.register(UINib(nibName: canceledReuseIdentifier, bundle: nil), forCellReuseIdentifier: canceledReuseIdentifier);
        
        tableView.register(UINib(nibName: completedReuseIdentifier, bundle: nil), forCellReuseIdentifier: completedReuseIdentifier);
        
        tableView.register(UINib(nibName: waitingReuseIdentifier, bundle: nil), forCellReuseIdentifier: waitingReuseIdentifier);
        
        if(L102Language.getRegisterType() == 1){
            tableView.register(UINib(nibName: schoolOrderTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: schoolOrderTableViewCellIdentifier);
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOrders(notification:)), name: .Refreshorders, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.getOrders),
            name: Notification.Name("getOrders"),
            object: nil)
        
    }
    
    
    
    @objc func getOrders (notification: Notification){
        requestType = notification.userInfo?["type"] as? Int ?? 1
        if(requestType == 0){
            filter = RequestFilter.waited
        }else{
            filter = RequestFilter.completed
        }
        getRequests()
        
    }
    @objc func refreshOrders(notification: NSNotification) {
        self.getRequests();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRequests()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //        if(filter == RequestFilter.waited && self.requests .count > 0){
        //            return 2
        //        }else{
        //            return 1
        //
        //        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if(filter == RequestFilter.waited && self.requests.count > 0  && section == 0){
        //            return 1;
        //        }else{
        return requests.count;
        //}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(L102Language.getRegisterType() == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: schoolOrderTableViewCellIdentifier, for: indexPath) as! SchoolOrderTableViewCell
            let currentRequest = requests[indexPath.row]
            cell.delegate = self
            cell.configureCell(request: currentRequest)
            return cell;
        }else{
            if(filter == RequestFilter.waited && self.requests.count > 0 ){
              
                if(filter == RequestFilter.waited){
                    let cell = tableView.dequeueReusableCell(withIdentifier: waitingReuseIdentifier, for: indexPath) as! RepairWaitingOrderTableViewCell
                    let currentRequest = requests[indexPath.row]
                   cell.delegate = self
                    cell.configureCell(request: currentRequest)
                    return cell;
                }
                else if(filter == RequestFilter.canceled){
                    let cell = tableView.dequeueReusableCell(withIdentifier: canceledReuseIdentifier, for: indexPath) as! CanceledOrdersTableViewCell
                    let currentRequest = requests[indexPath.row]
                    cell.delegate = self
                    cell.configureCell(request: currentRequest)
                    return cell;
                }
                else  if(filter == RequestFilter.completed){
                    let cell = tableView.dequeueReusableCell(withIdentifier: completedReuseIdentifier, for: indexPath) as! RepairCompletedTableViewCell
                    let currentRequest = requests[indexPath.row]
                    cell.delegate = self
                    
                    cell.configureCell(request: currentRequest)
                    return cell;
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewOrderTableViewCell
                let currentRequest = requests[indexPath.row]
                cell.delegate = self
                cell.configureCell(request: currentRequest)
                cell.phoneButton.tag = indexPath.row
                cell.smsButton.tag = indexPath.row
                //cell.whatsAppButton.tag = indexPath.row
                cell.phoneButton.addTarget(self, action: #selector(OrdersVC.callProvider), for: .touchUpInside)
                cell.smsButton.addTarget(self, action: #selector(OrdersVC.sendMsgToprovider) , for: .touchUpInside)
                // cell.whatsAppButton.addTarget(self, action: #selector(OrdersVC.whatsAppToProvider) , for: .touchUpInside)
                return cell
                // }
            }
            if(filter == RequestFilter.canceled){
                let cell = tableView.dequeueReusableCell(withIdentifier: canceledReuseIdentifier, for: indexPath) as! CanceledOrdersTableViewCell
                let currentRequest = requests[indexPath.row]
                cell.delegate = self
                cell.configureCell(request: currentRequest)
                return cell;
            } else  if(filter == RequestFilter.completed){
                let cell = tableView.dequeueReusableCell(withIdentifier: completedReuseIdentifier, for: indexPath) as! RepairCompletedTableViewCell
                let currentRequest = requests[indexPath.row]
                cell.delegate = self
                cell.configureCell(request: currentRequest)
                return cell;
            }
            else  if(filter == RequestFilter.waited){
                let cell = tableView.dequeueReusableCell(withIdentifier: waitingReuseIdentifier, for: indexPath) as! WaitingOrdersTableViewCell
                let currentRequest = requests[indexPath.row]
                cell.delegate = self
                cell.configureCell(request: currentRequest)
                return cell;
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewOrderTableViewCell
            cell.filter = self.filter;
            let currentRequest = requests[indexPath.row]
            cell.delegate = self
            cell.configureCell(request: currentRequest)
            cell.phoneButton.tag = indexPath.row
            cell.smsButton.tag = indexPath.row
            //cell.whatsAppButton.tag = indexPath.row
            cell.phoneButton.addTarget(self, action: #selector(OrdersVC.callProvider), for: .touchUpInside)
            cell.smsButton.addTarget(self, action: #selector(OrdersVC.sendMsgToprovider) , for: .touchUpInside)
            // cell.whatsAppButton.addTarget(self, action: #selector(OrdersVC.whatsAppToProvider) , for: .touchUpInside)
            return cell
            
        }
    }
    
    @objc func goToDetails (sender : UIButton){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "WaitingDetailsViewController") as! WaitingDetailsViewController
        controller.requestType = 1
        controller.selectedRequest = self.requests[sender.tag]
        controller.modalPresentationStyle = .fullScreen
        //self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func goToCompletedDetails(sender : UIButton){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let  compController  = storyBoard.instantiateViewController(withIdentifier: "CompletedDetailsViewController") as! CompletedDetailsViewController
        compController.selectedRequest = self.requests[sender.tag]
        compController.modalPresentationStyle = .fullScreen
        //self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(compController, animated: true)
    }
    
    @objc func callProvider (sender : UIButton){
        guard let number = URL(string: "tel://" + (self.requests[sender.tag].userPhone)) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func sendMsgToprovider (sender : UIButton){
        //        if (MFMessageComposeViewController.canSendText()) {
        //            let controller = MFMessageComposeViewController()
        //            controller.body = ""
        //            controller.recipients = [(self.requests[sender.tag].userPhone)]
        //            controller.messageComposeDelegate = self
        //            self.present(controller, animated: true, completion: nil)
        //
        //        }
        
        // var storyBoard =  UIStoryboard(name: "Main", bundle: nil);
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetailsViewController") as! MessageDetailsViewController
        vc.tech_id = self.requests[sender.tag].userId;
        vc.userName = self.requests[sender.tag].userName;
        vc.order_id = self.requests[sender.tag].id ?? "";
        
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    func whatsAppToProvider (sender : UIButton){
        let urlWhats = "whatsapp://send?phone=\(self.requests[sender.tag].userPhone)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    UIApplication.shared.openURL(whatsappURL)
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    
    func getRequests(refresher: Bool = false) {
        //self.refreshControl?.beginRefreshing();
        self.requests = [];
        self.tableView.reloadData();
        UserManager.getUserRequests(filter: filter) { (requests) in
            print(requests)
            if(requests != nil && requests.count > 0){
                self.requests = requests
                self.tableView.reloadData()
            }else{
                Utils.showToast(message: NSLocalizedString("orders.noRequets", comment: ""))
            }
            
            if (refresher) {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func didPressMapButton(sender: Any, request: Request) {
        let latitude: CLLocationDegrees = Double(request.lat)!
        let longitude: CLLocationDegrees = Double(request.lng)!
        
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
                            "comgooglemaps://?saddr=&daddr=\(Double(request.lat)!),\(Double(request.lng)!)&directionsmode=driving")! as URL)
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
    func didPressCancelOrderButton(sender: Any, request: Request) {
        
        let alert = UIAlertController(title: NSLocalizedString("orders.alert.title", comment: ""), message:  NSLocalizedString("orders.alert.deleteTecnician", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.ok", comment: ""), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                UserManager.cancelOrderTech(reqId: request.id){
                    (res) in
                    self.getRequests(refresher: true)
                    
                }
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func didPressDeleteOrderButton(sender: Any, request: Request) {
        
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
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteReasonsArrayInAlert(request: Request){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in
        //            UserManager.deleteOrder(reqId: request.id , reason : DeleteReasonsViewController.selectedReason){
        //                (res) in
        //                self.getRequests(refresher: true)
        //            }
        //        });
        //        alertController.addAction(okAction)
        
        // Create custom content viewController
        let contentViewController = NewDeleteOrdersViewController()
        contentViewController.requestId = request.id;
        var frame = CGSize(width: self.view.frame.width + 300, height: 300);
        contentViewController.preferredContentSize = frame; //contentViewController.view.bounds.size
        
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
        
    }
    
    func didPressActionButton(sender: Any, request: Request) {
        switch request.status {
        case 1:
            // Awaiting approval
            // Go to tech accept page
            let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ServiceAcceptanceVC") as! ServiceAcceptanceVC
            vc.reqId = request.id
            self.navigationController?.pushViewController(vc, animated: true);
            
        case 3 :
            
            // Go to review page
            print("go to review")
            let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
            vc.request = request;
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            //case 2
            print("go to review")
            let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
            vc.request = request;
            self.navigationController?.pushViewController(vc, animated: true)
            
          //  didPressCancelOrderButton(sender: sender, request: request)
//            print("go to review")
//            let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
//            vc.request = request;
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didPressViewImage(sender: Any, request: Request) {        
        let configuration = ImageViewerConfiguration { config in
            if let image = SDImageCache.shared().imageFromDiskCache(forKey: request.image) {
                config.image = image
            } else {
                // config.image = UIImage(named: "Logo")
            }
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        present(imageViewerController, animated: true)
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        getRequests(refresher: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}


extension OrdersVC : SchoolOrderTableViewCellDelegate {
    func search(request: Request) {
                  // Go to review page
                  print("go to review")
                  let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
                  vc.request = request;
                  self.navigationController?.pushViewController(vc, animated: true)
              
    }
    
    func cancelOrder(request: Request) {
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
              self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension OrdersVC : WaitingDetailsTableViewCellDelegate{
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
         //cancelTech(request: request)
            rateTech(request: request)
            
        case 3:
            rateTech(request: request)
        default:
            // completed
            // Go to review page
            print("go to review")
            let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
            vc.request = request;
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func rateTech(request: Request) {
        print("go to review")
        let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        vc.request = request;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
