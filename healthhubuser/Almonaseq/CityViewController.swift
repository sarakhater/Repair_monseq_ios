//
//  CityViewController.swift
//  AlmonaseqProvider
//
//  Created by unitlabs on 12/12/19.
//  Copyright © 2019 Sara khater. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var reuseIdentifier = "CountryTableViewCell";
    var CityArr : [Category] = [];
    let currentLanguage = L102Language.currentAppleLanguage();
    var selectedCityArr : [Category] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if self.currentLanguage == "en-US" {
                      titleLabel.text = "Choose City"
                  } else {
                      titleLabel.text = "اختر المدينة"
                  }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    func returnSelectedCatArr() -> [Category]{
        return self.selectedCityArr;
    }
    
}


extension CityViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CityArr.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CountryTableViewCell
        if(self.CityArr.count > 0){
            let country = CityArr[indexPath.row];
            if self.currentLanguage == "en-US" {
                cell.countryLabel.text = country.englishName
            } else {
                cell.countryLabel.text = country.name
            }
        }
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCityArr.append(CityArr[indexPath.row]);
    }
    
    
}

