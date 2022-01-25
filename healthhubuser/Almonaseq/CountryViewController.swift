//
//  CountryViewController.swift
//  AlmonaseqProvider
//
//  Created by unitlabs on 12/12/19.
//  Copyright © 2019 Sara khater. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    var reuseIdentifier = "CountryTableViewCell";
       var CategoriesArr : [Category] = []
       let currentLanguage = L102Language.currentAppleLanguage();
       var selectedCategoriesArr : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.currentLanguage == "en-US" {
                             titleLabel.text = "Choose Country"
                         } else {
                             titleLabel.text = "اختر الدولة"
                         }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        }
        func returnSelectedCatArr() -> [Category]{
            return self.selectedCategoriesArr;
        }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CountryViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.CategoriesArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CountryTableViewCell;
        if(self.CategoriesArr.count > 0){
                   let country = CategoriesArr[indexPath.row];
        if self.currentLanguage == "en-US" {
                       cell.countryLabel.text = country.englishName
                   } else {
                       cell.countryLabel.text = country.name
                   }
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategoriesArr.append(CategoriesArr[indexPath.row]);
    }
    

    
}
