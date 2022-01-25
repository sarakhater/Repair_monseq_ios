//
//  NotificationsVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 1/22/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class NotificationsVC: UITableViewController {
    
    
    var notifiactionMessagesList : [NotificationDetailsModel] = [];
    let reuseIdentifier = "NotificationTableViewCell"
    var user_id = 0;
    let userDef = UserDefaults.standard
    var navTitle: String = NSLocalizedString("menu.notification", comment: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSideMenu()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
      
        self.navigationItem.title = navTitle
        
        user_id = userDef.integer(forKey: "user_id");
        openNotification();
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.show();
        buildSideMenu();
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        getAllNotification();
    }
    
    func openNotification(){
        //http://monasiq.com/mobile2/open_notifications/1442/1
        if(user_id != 0){
            let url = Constants.API_ENDPOINT + "open_notifications/" + "\(user_id)" + "/" + "2";
            print(url);
            Alamofire.request(url).responseObject { (response: DataResponse<NotificationModel>) in
                
                let menuResponse = response.result.value;
                
            }
        }
    }

    func getAllNotification(){
        var url = Constants.API_ENDPOINT + "user_notifications/" + "\(user_id)";
        Alamofire.request(url).responseObject { (response: DataResponse<NotificationModel>) in
            
            let menuResponse = response.result.value
            if(menuResponse?.data != nil && menuResponse!.data.count > 0 ){
                self.notifiactionMessagesList = (menuResponse?.data)!;
                self.tableView.reloadData();
            }else{
                    if(Utils.getcurrentLanguage() == "ar"){
                        Utils.showToast(message: "لا يوجد اي إشعارات ")

                    }else{
                        Utils.showToast(message: "There isn't any Notifications")

                    }
                }
            SVProgressHUD.dismiss();
        }
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifiactionMessagesList.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! NotificationTableViewCell;
        cell.configureCell(notifiaction: self.notifiactionMessagesList[indexPath.row]);
        
        return cell;
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let notificationDetailsVC = storyboard.instantiateViewController(withIdentifier: "NotificationDetailsViewController") as! NotificationDetailsViewController;
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
