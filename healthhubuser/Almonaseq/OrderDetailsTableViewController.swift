//
//  OrderDetailsTableViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 2/5/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class OrderDetailsTableViewController: UITableViewController {
    private let  waitingReuseIdentifier = "WaitingDetailsTableViewCell"
    private let  completedReuseIdentifier = "CompletedDetailsTableViewCell"
    private let headerReuseIdentifier = "DetailsTitleTableViewCell"
    var request : Request!
    var navTitle: String = NSLocalizedString("menu.myOrder", comment: "")
    var filter = RequestFilter.waited;
    var requestType = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        var image = UIImage(named: "bg-2")!
        //self.tableView.backgroundColor = UIColor(patternImage: image);
        tableView.register(UINib(nibName: completedReuseIdentifier, bundle: nil), forCellReuseIdentifier: completedReuseIdentifier);
        
        tableView.register(UINib(nibName: "WaitingDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "WaitingDetailsTableViewCell");
        
        tableView.register(UINib(nibName: headerReuseIdentifier, bundle: nil), forCellReuseIdentifier: headerReuseIdentifier);
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 50
        }
        else{
            return 300
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseIdentifier, for: indexPath)as! DetailsTitleTableViewCell
            cell.delegate = self
            
            return cell
            
        }else if(indexPath.section == 1) {
            if(requestType == 1){
                //waiting status
                let cell = tableView.dequeueReusableCell(withIdentifier: "WaitingDetailsTableViewCell", for: indexPath)as! WaitingDetailsTableViewCell
                cell.filter = self.filter
                cell.cancelBtn.tag = indexPath.row
                cell.cancelBtn.addTarget(self, action: #selector(cancelTechBtn(sender:)), for: .touchUpInside)
                cell.delegate = self
                cell.configureCell(request: self.request!)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: completedReuseIdentifier, for: indexPath) as! CompletedDetailsTableViewCell
                cell.configureCell(request: self.request!)
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

extension OrderDetailsTableViewController : DetailsTitleTableViewCellDelegate  , WaitingDetailsTableViewCellDelegate , CompletedDetailsTableViewCellDelegate{
    @objc  func cancelTechBtn(sender:UIButton){
        let alert = UIAlertController(title: NSLocalizedString("orders.alert.title", comment: ""), message: NSLocalizedString("orders.alert.deleteOrder", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("orders.alert.ok", comment: ""), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                self.showDeleteReasonsArrayInAlert(request: self.request);
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
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
        self.present(alert, animated: true, completion: nil)
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
        self.present(alert, animated: true, completion: nil)
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
            self.navigationController?.pushViewController(vc, animated: true);
            
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
        vc.request = request;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rateTech(request: Request) {
        
    }
}
