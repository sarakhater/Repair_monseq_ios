//
//  ProfileVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 4/10/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {
    let userDef = UserDefaults.standard
    var userId: String?
    var user: [String: String]?
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        buildSideMenu();
        setTextViewRounded(textField: name);
        setTextViewRounded(textField: username);
        setTextViewRounded(textField: email);
        setTextViewRounded(textField: phone);
        setTextViewRounded(textField: password);
        
        userId = userDef.string(forKey: "user_id");
        getUser();
        phone.isUserInteractionEnabled = false;
        refreshControl = UIRefreshControl();
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh");
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged);
    }
    
    
    func setTextViewRounded(textField : UITextField){
        
        textField.layer.borderWidth = 2.0;
        textField.layer.borderColor = Constants.BORDER_COLOR;
        textField.layer.cornerRadius = 25;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    @IBAction func editProfile(_ sender: Any) {
        self.view.endEditing(true);
        if(password.text!.isEmpty){
            let params: [String: Any] = [
                "user_id": userId!,
                "name": name.text ?? "",
                "user_name": username.text ?? "",
                "email": email.text ?? "",
                "phone": phone.text ?? ""
            ]
            UserManager.editUser(params: params) { (res) in
                if(res == "true"){
                    UserManager.getUserProfile(id:  self.userId!, downloadComplete: { (user) in
                        
                        
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController {
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        
                    })
                    
                }
            }
        }else{
            let params: [String: Any] = [
                "user_id": userId!,
                "name": name.text ?? "",
                "user_name": username.text ?? "",
                "email": email.text ?? "",
                "password": password.text ?? "",
                "phone": phone.text ?? ""
            ]
            UserManager.editUser(params: params) { (res) in
                
                if(res == "true"){
                    UserManager.getUserProfile(id: self.userId!, downloadComplete: { (user) in
                        
                        
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController {
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        
                    })
                    //self.dismiss(animated: true, completion: nil);
                }
            }
        }
    }
    
    func getUser(refresher: Bool = false) {
        if(userId != nil){
            UserManager.getUserProfile(id: userId!) { (res) in
                self.user = self.userDef.dictionary(forKey: "user") as? [String : String];
                DispatchQueue.main.async {
                    self.name.text = self.user?["name"];
                    self.username.text = self.user?["username"];
                    self.phone.text = self.user?["phone"];
                    self.email.text = self.user?["email"];
                    if (refresher) {
                        self.refreshControl?.endRefreshing();
                    }
                }
                
            }
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        getUser(refresher: true)
    }
}
