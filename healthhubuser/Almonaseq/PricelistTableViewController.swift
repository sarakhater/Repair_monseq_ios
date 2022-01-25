//
//  PricelistTableViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 1/29/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import ExpandableTableViewController

class PricelistTableViewController: ExpandableTableViewController  {
    
    let priceCellIdentifier = "PriceTableViewCell"
    var priceList : [categoryPriceItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSideMenu()
        if(Utils.getcurrentLanguage() == "ar"){
            self.title = "قائمة الأسعار";
        }else{
            self.title = "Price List";
        }
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg-2"))
        getPriceList()
    }
    
    func getPriceList(){
        ServiceManager.getPriceList( downloadCompeted: { (priceItem) in
            print("sub cats", priceItem)
            self.priceList = priceItem ?? []
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return priceList.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: priceCellIdentifier, for: indexPath) as! PriceTableViewCell
       
        if(Utils.getcurrentLanguage() == "ar"){
            cell.itemLabel.text = priceList[indexPath.row].name
        }else{
            cell.itemLabel.text = priceList[indexPath.row].englishName
        }
        //cell.itemPriceLabel.text = priceList[indexPath.row].price
        
        
        
        
        return cell
    }
    
    
    
    
}
