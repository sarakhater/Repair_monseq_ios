//
//  SideMenuVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftMessages
/*
 Menu controller is responsible for creating its content and showing/hiding menu using 'menuContainerViewController' property.
 */
protocol AuthStatus: class {
    func isLoggedIn(loggedIn: Bool)
}

class SideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AuthStatus {
    
    
    
    // Get Initial
    let userDef = UserDefaults.standard
    var loggedIn = false
    var currentVC: UIViewController?
    let kCellReuseIdentifier = "MenuCell"
    let SubMenuCellReuseIdentifier = "SubMenuCell"
    let profileMenuCellReuseIdentifier = "ProfileMenuTableViewCell"
    
    var cellHeight: CGFloat = 60.0
    var menuItemsArray = [Menu]()
    var currentIdentifier: String?
    var isMyOrderclicked = false;
     var showExistNotif = false;
    var user_id = "";
    var user: [String: String]?

    
    let mainNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
    
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    func checkNotification(){
        if(user_id != "0"){
            let url = Constants.API_ENDPOINT + "check_notifications/" + "\(user_id)" + "/" + "2";
            print(url);
            Alamofire.request(url).responseObject { (response: DataResponse<NotificationModel>) in
                
                let menuResponse = response.result.value
                if(menuResponse?.status != nil && menuResponse?.status == "true"){
                    self.showExistNotif = true;
                    self.tableView.reloadData();
                }
                else{
                    self.showExistNotif = false;
                    self.tableView.reloadData();
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser();
        self.navigationController?.navigationBar.titleTextAttributes =
[NSAttributedString.Key.foregroundColor: UIColor.white ,  NSAttributedString.Key.font:UIFont(name: Constants.boldFont, size: 17)!]
        checkNotification();
        if(L102Language.getRegisterType() == 1){
            //school
            menuItemsArray = Utils.buildSchoolMenuItems()
        }else{
            menuItemsArray = Utils.buildFirstMenuItems()
        }
      

        //Utils.initializeGradient(view: gradientLayer)
        print("table view loaded")
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName:kCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: kCellReuseIdentifier)
         tableView.register(UINib(nibName:profileMenuCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: profileMenuCellReuseIdentifier)
        
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin(notification:)), name: .login, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout(notification:)), name: .logout, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLanguageChanged(notification:)), name: .languageChanged, object: nil)
        
        //        loggedIn = userDef.bool(forKey: "logged_in")
        // TODO: Listen to auth status and hide cells accordingly
        
    }
    
    func getUser(refresher: Bool = false) {
        let userId = userDef.string(forKey: "user_id")

           if(userId != nil){
            UserManager.getUserProfile(id: userId ?? "") { (res) in
               self.user = self.userDef.dictionary(forKey: "user") as? [String : String];
            self.tableView.reloadData()
              
           }
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
        loggedIn = userDef.bool(forKey: "logged_in")
        user_id = userDef.string(forKey: "user_id") ?? ""
        checkNotification();
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else{
            print(menuItemsArray.count);
                 return menuItemsArray.count
        }
     
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: profileMenuCellReuseIdentifier, for: indexPath) as! ProfileMenuTableViewCell
              cell.selectionStyle = .none
            if(Utils.getcurrentLanguage() == "ar"){
                cell.userNameLabel.text =  "مرحبا" + (self.user?["name"] ?? "")
            }else{
                cell.userNameLabel.text = "Welcome" + (self.user?["name"] ?? "")
            }
           
            cell.phoneLabel.text = self.user?["phone"]
            return cell
        }else{
        print("adding cells")
        if let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as? MenuCell {
            //cell.backgroundColor = UIColor.clear
            
            cell.configureCell(showExistNotif : self.showExistNotif ,menu: menuItemsArray[indexPath.row]);
            //            cell.menuItemTitle.text = menuItemsArray[indexPath.row].englishName
            //cell.menuItemTitle.textColor = UIColor.white
            cell.selectionStyle = .none
            return cell
        } else {
            print("empty cells")
            return UITableViewCell()
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 100
        }else{
        if (loggedIn) {
            if indexPath.row == 10 {
                return 60
            } else {
                return 60
            }
        } else {
            if indexPath.row == 11 {
                return 0
            } else {
                return 60
            }
        }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("menu item selected")
        let currentItem = menuItemsArray[indexPath.row]
        let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC;
        let currentStoryboard: UIStoryboard = UIStoryboard(name: currentItem.storyBoard, bundle: nil);
        
        let identifier = currentItem.id;
        currentIdentifier = currentItem.vc;
        if(L102Language.getRegisterType() == 1){
            //school
            menuItemsArray = Utils.buildSchoolMenuItems()
        }else{
        if(identifier == "5"){
            if(isMyOrderclicked){
                //close sub menu
                menuItemsArray = Utils.buildFirstMenuItems();
                isMyOrderclicked = false;
            }else{
                //open sub Menu
                isMyOrderclicked = true;
                menuItemsArray = Utils.buildMenuItems();
            }
            self.tableView.reloadData();
            
        }else{
            if(isMyOrderclicked){
                menuItemsArray = Utils.buildFirstMenuItems();
                isMyOrderclicked = false;
            }
        }
            
            self.tableView.reloadData();
        }
            
            switch identifier {
            
            // signout vc
            case "8":
                print("logout user from menu")
                UserManager.logout()
                currentVC = nil
                loggedIn = false
               
                break;
            // Faq and questions
            case "2":
                let vc = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "PageVC") as! PageVC
                if (identifier == "2") {
                    print("about page")
                    vc.pageId = "4"
                } else {
                    vc.pageId = "15"
                    
                }
                vc.navTitle = currentItem.name
                setViewController(vc: vc)// , currentItem: currentItem);
                break;
            case "7":
                // Share app
                _ = Utils.share(tableView, context: self)
                //            self.dismiss(animated: true, completion: nil)
                break;
                
            case "21":
                let orderVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                setViewController(vc: orderVC , currentItem: currentItem)
            case "22":
                let orderVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                setViewController(vc: orderVC , currentItem: currentItem)
            case "23":
                let orderVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                setViewController(vc: orderVC , currentItem: currentItem)
            case "24":
                let orderVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                setViewController(vc: orderVC , currentItem: currentItem)
            default:
                currentVC = currentStoryboard.instantiateViewController(withIdentifier: currentIdentifier!)
                if currentVC != nil {
                    handleLoginStatus(currentItem: currentItem, loginVC: loginVC, vc: currentVC!)
                }
            }
        

    }
    
    func setViewController(vc: UIViewController, currentItem: Menu) {
        switch currentItem.id {
    
        case "21":
            let vc = vc as! OrdersVC
            vc.filter = RequestFilter.waited
            vc.navTitle = NSLocalizedString("menu.waitedOrder", comment: "")
            break;
        case "22":
            let vc = vc as! OrdersVC
            vc.filter = RequestFilter.underProcessing
            vc.navTitle = NSLocalizedString("menu.pendingOrder", comment: "")
            break;
        case "23":
            let vc = vc as! OrdersVC
            vc.filter = RequestFilter.completed
            vc.navTitle = NSLocalizedString("menu.CompletedOrder", comment: "")
            break;
        case "24":
            let vc = vc as! OrdersVC
            vc.filter = RequestFilter.canceled
            vc.navTitle = NSLocalizedString("menu.canceledOrder", comment: "")
            break;
            
        default:
            print("nl")
        }
        if(loggedIn == true){
        if let nav = self.navigationController as? UISideMenuNavigationController,
            let presentingNav = nav.presentingViewController as? UINavigationController {
            print("vc from set view \(vc)")
            dismiss(animated: true, completion: nil)
            presentingNav.setViewControllers([vc], animated: false)
        }
        }else{
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
              self.setViewController(vc: vc)
        }
    }
    
    func setViewController(vc: UIViewController){
        if let nav = self.navigationController as? UISideMenuNavigationController,
            let presentingNav = nav.presentingViewController as? UINavigationController {
            print("vc from set view \(vc)")
            dismiss(animated: true, completion: nil)
            presentingNav.setViewControllers([vc], animated: false)
        }
    }
    func isLoggedIn(loggedIn: Bool) {
        self.loggedIn = loggedIn
    }
    
    @objc func onLogin(notification: NSNotification) {
        print("on login")
        self.loggedIn = true
        self.tableView.reloadData()
        //        if currentVC != nil {
        //
        //            self.setViewController(vc: currentVC!)
        //            self.navigationController?.pushViewController(currentVC!, animated: true)
        //        } else {
        //            if currentIdentifier == "SettingsVC" {
        //                let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        //                vc.editProfile = true
        //                self.setViewController(vc: vc)
        //                self.navigationController?.pushViewController(currentVC!, animated: true)
        //            }
        //        }
    }
    
    @objc func onLogout(notification: NSNotification) {
        self.loggedIn = false
        self.tableView.reloadData()
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SelectRegisterServiceViewController") as! SelectRegisterServiceViewController
        self.setViewController(vc: vc)
//        let vc = UIStoryboard(name: "Service", bundle: nil).instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        self.setViewController(vc: vc)
    }
    
    func handleLoginStatus(currentItem: Menu, loginVC: LoginVC, vc: UIViewController) {
        let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
        
        if(currentItem.showLoggedIn == true) {
            // If user is registered check if the account is activated, else handle login
            //             && userDef.bool(forKey: "registered")) || (!userDef.bool(forKey: "activated") && userDef.bool(forKey: "registered"))
            if (userDef.bool(forKey: "registered")) {
                if (userDef.bool(forKey: "activated")) {
                    if (!loggedIn) {
                        loginVC.fromMenu = true
                        loginVC.currentVC = vc
                        setViewController(vc: loginVC )
                    } else {
                        setViewController(vc: vc )
                    }
                } else {
                    setViewController(vc: activateVC )
                }
                
            } else {
                loginVC.fromMenu = true
                loginVC.currentVC = vc
                setViewController(vc: loginVC)
            }
            
        } else {
            setViewController(vc: vc )
        }
    }
    
    @objc func onLanguageChanged(notification: NSNotification) {
        viewDidLoad();
        //self.menuItemsArray = Utils.buildMenuItems()
        //tableView.reloadData()
    }
    
    static  func showSuccessMessage(txt:String?){
           var actual_txt = "";
           actual_txt = txt ?? "";
           
           if(actual_txt == nil || (actual_txt.isEmpty)){
               return
           }
           var config = SwiftMessages.Config()
           //config.duration = .seconds(seconds: 30);
           
           // Slide up from the bottom.
           config.presentationStyle = .top
           
           // Display in a window at the specified window level: UIWindowLevelStatusBar
           // displays over the status bar while UIWindowLevelNormal displays under.
           config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        
           
           // Disable the default auto-hiding behavior.
           config.duration = .automatic
           
           // Dim the background like a popover view. Hide when the background is tapped.
           config.dimMode = .gray(interactive: true)
           
           
           
           // Specify a status bar style to if the message is displayed directly under the status bar.
           config.preferredStatusBarStyle = .lightContent
           
           // Specify one or more event listeners to respond to show and hide events.
           
           // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
           // files in the main bundle first, so you can easily copy them into your project and make changes.
           let view = MessageView.viewFromNib(layout: .cardView);
           
           // Theme message elements with the warning style.
           
           view.configureTheme(.success);
           
           // Add a drop shadow.
           view.configureDropShadow()
           
           // Set message title, body, and icon. Here, we're overriding the default warning
           // image with an emoji character.
           view.configureContent(title: "", body:actual_txt.deleteHTMLTag())
           view.button?.isHidden = true
           
           // Show the message.
           
           SwiftMessages.show(config: config, view: view)
           
           
       }
       
       
       static  func showErrorMessage(txt:String? , _ theme: Theme){
           var actual_txt = "";
           actual_txt = txt ?? "";
           
           if(actual_txt == nil || (actual_txt.isEmpty)){
               return
           }
           var config = SwiftMessages.Config()
           //config.duration = .seconds(seconds: 30);
           
           // Slide up from the bottom.
           config.presentationStyle = .top
           
           // Display in a window at the specified window level: UIWindowLevelStatusBar
           // displays over the status bar while UIWindowLevelNormal displays under.
          
       config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)

           
           // Disable the default auto-hiding behavior.
           config.duration = .automatic
           
           // Dim the background like a popover view. Hide when the background is tapped.
           config.dimMode = .gray(interactive: true)
           
           
           
           // Specify a status bar style to if the message is displayed directly under the status bar.
           config.preferredStatusBarStyle = .lightContent
           
           // Specify one or more event listeners to respond to show and hide events.
           
           // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
           // files in the main bundle first, so you can easily copy them into your project and make changes.
           let view = MessageView.viewFromNib(layout: .cardView);
           
           // Theme message elements with the warning style.
           
           view.configureTheme(.error);
           
           // Add a drop shadow.
           view.configureDropShadow()
           
           // Set message title, body, and icon. Here, we're overriding the default warning
           // image with an emoji character.
           view.configureContent(title: "", body:actual_txt.deleteHTMLTag())
           view.button?.isHidden = true
           
           // Show the message.
           
           SwiftMessages.show(config: config, view: view)
           
           
       }
    
    
}
