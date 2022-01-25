//
//  SelectRegisterServiceViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 1/20/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

class SelectRegisterServiceViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.setNavigationBarHidden(true, animated: true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectServices(_ sender: UIButton) {
        //open register based on button tag
        
        if(sender.tag == 1){
            //school
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")as! LoginVC
            L102Language.setRegisterType(type: sender.tag)
               controller.modalPresentationStyle = .fullScreen
            //self.present(controller, animated: true, completion: nil)
            self.navigationController?.pushViewController(controller, animated: true);

        }else{
            //family
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController")as! MainTabBarViewController
            L102Language.setRegisterType(type: sender.tag)
               controller.modalPresentationStyle = .fullScreen
            //self.present(controller, animated: true, completion: nil)
            self.navigationController?.pushViewController(controller, animated: true);

        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         //self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    
}
