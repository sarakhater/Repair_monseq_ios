//
//  ChatViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 1/31/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SVProgressHUD

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var chatMessagesList : [MessageModel] = [];
    let reuseIdentifier = "ChatMessagesTableViewCell"
    var user_id = 0;
    let userDef = UserDefaults.standard
    var navTitle: String = NSLocalizedString("menu.chat", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        
        user_id = userDef.integer(forKey: "user_id")
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.show();
        buildSideMenu();
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        getAllMessages();
        
        
    }
    func getAllMessages(){
        var url = Constants.API_ENDPOINT + "show_all_msg/" + "\(user_id)" + "/1"
        print(url);
        Alamofire.request(url).responseObject { (response: DataResponse<ChatMessages>) in
            
            let menuResponse = response.result.value
            if(menuResponse?.data != nil && menuResponse!.data.count > 0){
                self.chatMessagesList = (menuResponse?.data)!;
                self.tableView.reloadData();
                
            }else{
                if(Utils.getcurrentLanguage() == "ar"){
                    Utils.showToast(message: "لا يوجد اي رسايل")

                }else{
                    Utils.showToast(message: "There isn't any message")

                }
            }
            SVProgressHUD.dismiss();
        }
    }
    
    
}

extension ChatViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessagesList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! ChatMessagesTableViewCell;
        cell.sendToNameLabel.text = self.chatMessagesList[indexPath.row].sent_to_name;
        cell.createdLabel.text = self.chatMessagesList[indexPath.row].created;
        cell.messageLabel.text = self.chatMessagesList[indexPath.row].msg;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MessageDetailsViewController")as! MessageDetailsViewController
        
        controller.tech_id = self.chatMessagesList[indexPath.row].sent_to_id;
        controller.userName = self.chatMessagesList[indexPath.row].sent_to_name;
        self.navigationController?.pushViewController(controller, animated: true);
        //self.present(controller, animated: true, completion: nil);
    }
    
    
}
