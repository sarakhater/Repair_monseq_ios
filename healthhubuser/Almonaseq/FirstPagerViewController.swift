//
//  FirstPagerViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 3/13/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


import UIKit
import Alamofire
import SVProgressHUD

class FirstPagerViewController: UIViewController {
    
    @IBOutlet weak var skipView: UIView!
    @IBOutlet weak var bigView: UIView!
    var initialPagerArray : [InitialPager] = [];
    var currentIndex : Int = 0;
    var lang : String = "";
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBAction func nextClicked(_ sender: Any) {
        if(currentIndex == 2){
             reloadControllers(lang: lang);
        }else{
          currentIndex = currentIndex + 1;
           setData();
        }
    }
    
    
    @IBAction func skipClicked(_ sender: Any) {
        
        reloadControllers(lang: lang);
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messgeLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        SVProgressHUD.show();
        bigView.layer.cornerRadius = 15;
        bigView.layer.shadowColor = UIColor.black.cgColor
        bigView.layer.shadowOpacity = 1
        bigView.layer.shadowOffset = .zero
        bigView.layer.shadowRadius = 10
        
        //skipBtn.addTarget(self, action: #selector(skipClicked(_:)), for: .touchUpInside)
        let skipGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //skipView.addGestureRecognizer(skipGesture)

        if(lang == "ar"){
            skipBtn.setTitle("تخطي", for: .normal);
            nextBtn.setTitle("التالي", for: .normal);
        }else{
            skipBtn.setTitle("Skip", for: .normal);
            nextBtn.setTitle("Next", for: .normal);
        }
        getInitialPagesContent();

        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        reloadControllers(lang: lang);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.setData();
    }
    
    func getInitialPagesContent(){
        Alamofire.request(Constants.IntialPages).responseObject { (response: DataResponse<InitialPagerData>) in
                   
                   let menuResponse = response.result.value;
                   if(menuResponse?.data != nil){
                               self.initialPagerArray = (menuResponse?.data)!;

                    self.setData();
                }
            SVProgressHUD.dismiss();

               }
    }
    func setData(){
        if(initialPagerArray.count > 0){
            if(lang == "ar"){
                titleLabel.text = initialPagerArray[currentIndex].title_ar;
                messgeLabel.text = initialPagerArray[currentIndex].content_ar;
                

                //messgeLabel.attributedText = initialPagerArray[currentIndex].content_ar.htmlToAttributedString;
               //let font = UIFont(name: "Janna-LT", size: 20)
               // let attributes = [NSAttributedString.Key.font: font]
                //messgeLabel.attributedText = NSAttributedString(string: initialPagerArray[currentIndex].content_ar.htmlToAttributedString?.string ?? "", attributes: attributes)
//                , attributes:
//                [NSFontAttributeName:UIFont(
//                name: "Georgia",
//                size: 18.0)!]

            }else{
                titleLabel.text = initialPagerArray[currentIndex].title_en;
                //messgeLabel.attributedText = initialPagerArray[currentIndex].content_en.htmlToAttributedString;
                 messgeLabel.text = initialPagerArray[currentIndex].content_en;
                //messgeLabel.font = UIFont(name: "Janna-LT", size: 20)

            }
           
//            let nc = NotificationCenter.default
//            nc.post(name: Notification.Name("RefreshPager"), object: nil)
//            
        }
        
    }
    
     func reloadControllers(lang: String) {
            // Reload controllers
            
            L102Localizer.DoTheMagic()
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        var isloggedIn = UserDefaults.standard.bool(forKey:"logged_in")
        var mainController: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController;
        if(isloggedIn){
            //goTo home
              mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
        }else{
            //go to select register as
            mainController = UIStoryboard.init(name: "Auth", bundle: nil)
                .instantiateViewController(withIdentifier: "SelectRegisterServiceViewController") as! SelectRegisterServiceViewController
            let backItem = UIBarButtonItem()
            if(L102Language.currentAppleLanguage() == "ar"){
                backItem.title = "عودة"

            }else{
                backItem.title = "Back"

            }
          
            self.navigationController?.navigationItem.backBarButtonItem = backItem
            
        }
     
        navigationController.setViewControllers([mainController], animated: false)
            rootviewcontroller.rootViewController = navigationController
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8);
            
            // get a reference to the app delegate
    //        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    //        appDelegate?.setInitialVC()
            NotificationCenter.default.post(name: .languageChanged, object: ["language": lang])
            //
            //        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            //        }) { (finished) -> Void in
            //            NotificationCenter.default.post(name: .languageChanged, object: ["language": lang])
            //        }
        }
    

}
