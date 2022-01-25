//
//  PageVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/26/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import WebKit

class PageVC: UIViewController {
    var pageId: String = "4"
    var navTitle: String = "";
    var fromMenu = true
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageImage: UIImageView!
    @IBOutlet weak var pageContent: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try self.navigationItem.title = navTitle
        
        if (fromMenu) {
            buildSideMenu()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPageData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getPageData() {
        if (pageId != nil) {
            ApiManager.getPage(pageId: pageId) {
                (res: [String : JSON]?) in
                
                let currentLanguage = Utils.getcurrentLanguage()
                var content: String
                if currentLanguage == "en" {
                    self.pageTitle.text = res?["title_en"]?.string
                    content = (res?["content_en"]?.string!)!
                } else {
                    self.pageTitle.text = res?["title_ar"]?.string
                    content = (res?["content_ar"]?.string!)!
                }
                
                
                if (res?["image"] != nil) {
                    self.pageImage.sd_setImage(with: URL(string: (res?["image"]?.string)!), placeholderImage: UIImage(named: "logo-r"))
                } else {
                    self.pageImage.image = UIImage(named: "logo-r")
                }
                
                if(L102Language.currentAppleLanguage() == "ar"){
                    
                    
                    self.pageContent.loadHTMLString("<html dir=\"rtl\" lang=\"\"><body><font face='JannaLT-Regular' size='2'>" + content + "</body></html>" ,baseURL: nil)
                    
                    
                }else{
                    let content_html = "<font face='JannaLT-Regular' size='2'>"  + content
                    self.pageContent.loadHTMLString(content_html, baseURL: nil)
                }
                
            }
            
        }
        
    }
    
    
}
