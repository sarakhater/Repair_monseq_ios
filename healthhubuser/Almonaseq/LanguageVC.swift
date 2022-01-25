//
//  LanguageVC.swift
//  AlmonaseqProvider
//
//  Created by Nada El Hakim on 3/31/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//



import UIKit

class LanguageVC: UIViewController {

    @IBOutlet var languageButtons: [UIButton]!
    
    @IBOutlet weak var arBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    arBtn.layer.cornerRadius = 15;
        
    englishBtn.layer.cornerRadius = 15;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func changeLanguage(_ sender: Any) {
        var lang: String
        if ((sender as AnyObject).tag == 1) {
            lang = "en"
        } else {
            lang = "ar"
        }
        
        print("language set : \(lang)")
        
        L102Language.setAppleLAnguageTo(lang: lang)
        UserDefaults.standard.set(true, forKey: "language_set")
        //self.reloadControllers(lang: lang);
        presentPager(lang: lang);
        //self.reloadControllers(lang: lang);

        
    }
    
    func presentPager(lang : String){
        let mainStory = UIStoryboard(name: "Main", bundle: nil);
        let controller = mainStory.instantiateViewController(withIdentifier: "pagerViewController") as! pagerViewController;
               controller.lang = lang;
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
        //present(controller, animated: true, completion: nil);
    }
    
    func reloadControllers(lang: String) {
        // Reload controllers
        
        L102Localizer.DoTheMagic()
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
