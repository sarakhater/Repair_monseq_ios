//
//  IntroVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/29/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import GradientView

class IntroVC: UIViewController {

    @IBOutlet weak var labelView: GradientButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // let headerImage = UIImage(named: "Header_Bg");
        //self.navigationController!.navigationBar.setBackgroundImage(headerImage,for: .default)
         labelView.layer.cornerRadius = 25;
       
        //labelView.setViewGradientBackground(view: labelView);
       
        
//        buildSideMenu()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
