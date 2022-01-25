//
//  ServicePriceListViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 2/2/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import ExpandableTableViewController

class ServicePriceListViewController: UIViewController , updateCellHeightDelegate {
    func updateCellHeight(isExpanded: Bool) {
        self.isEpanded = isExpanded
    }
    

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var priceTableView: UITableView!
    
    var priceList : [categoryPriceItem] = []
    let sectionReuseIdentifier = "ServicePriceSectionTableViewCell"
    let rowReuseIdentifier = "PriceItemTableViewCell"
    var isEpanded = false
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleView.layer.cornerRadius = 20
        priceTableView.register(UINib(nibName: sectionReuseIdentifier, bundle: nil), forCellReuseIdentifier: sectionReuseIdentifier)
            buildSideMenu()

               if(Utils.getcurrentLanguage() == "ar"){
                   self.title = "قائمة الأسعار";
               }else{
                   self.title = "Price List";
               }
               getPriceList()
        
    }
    
    func getPriceList(){
           ServiceManager.getPriceList( downloadCompeted: { (priceItem) in
               print("sub cats", priceItem)
               self.priceList = priceItem ?? []
               self.priceTableView.reloadData()
           })
       }
}

extension ServicePriceListViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = priceTableView.dequeueReusableCell(withIdentifier: sectionReuseIdentifier, for: indexPath) as! ServicePriceSectionTableViewCell
        
        if(Utils.getcurrentLanguage() == "ar"){
            cell.categoryLabel.text = priceList[indexPath.row].name
                 }else{
            cell.categoryLabel.text = priceList[indexPath.row].englishName
                 }
        cell.selectionStyle = .none

        cell.bigExpandBtn.tag = indexPath.row
        cell.bigExpandBtn.addTarget(self, action:#selector(updateCellHeight(sender:)), for: .touchUpInside)
        if(priceList[indexPath.row].price.count > 0){
            cell.expandButton.isHidden = false;
            cell.bigExpandBtn.isHidden = false;
        }
        else{
            cell.expandButton.isHidden = true;
            cell.bigExpandBtn.isHidden = true;
        }
        cell.priceList = priceList[indexPath.row].price
        cell.priceCellTableView.reloadData()
        cell.delegate = self
               return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.isEpanded && indexPath.row == currentIndex){
                  return 220
              }else{
                  return 80
              }
    }
    @objc func updateCellHeight(sender:UIButton ) {
              currentIndex = sender.tag
              priceTableView.reloadData()
       
       }
    
}
