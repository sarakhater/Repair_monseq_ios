//
//  PaymentMethodViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 4/9/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit

class PaymentMethodViewController: UIViewController {
    
    @IBOutlet weak var paymentTitle: UILabel!
    
    var PaymentMethodArray : [PaymentMethod] = [];
    
    //1,2,3

    // ["Cash" , "Transfer" , "Visa"];
    var reuseIdentifier = "CountryTableViewCell";
    var selectedPaymentMethod = PaymentMethod();
    var showCashStatus : Bool!;
    var showVisaStatus : Bool!;

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad();
        setPaymentMethod();
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier);
        if(Utils.getcurrentLanguage() == "ar")
        {
            paymentTitle.text = "اختار نوع الدفع ";
            
        }
        else{
            paymentTitle.text = "Choose Payment Method";

        }
        // Do any additional setup after loading the view.
    }
    
  
    
    func setPaymentMethod(){
        if(self.showCashStatus == true){
            if(self.showVisaStatus == true){
                PaymentMethodArray = [
                                PaymentMethod(_methodId: 1, _methodName_Ar: "نقدى", _methodName_En: "Cash"),
                                PaymentMethod(_methodId: 2, _methodName_Ar: "تحويل", _methodName_En: "Transfer"),
                                PaymentMethod(_methodId: 3, _methodName_Ar: "فيزا", _methodName_En: "Visa")];
                                self.tableView.reloadData();
            }else{
                PaymentMethodArray = [
                                PaymentMethod(_methodId: 1, _methodName_Ar: "نقدى", _methodName_En: "Cash")]
                                self.tableView.reloadData();
            }
         
        }else{
            //cash == false
            if(self.showVisaStatus == true){
                           PaymentMethodArray = [
                                           PaymentMethod(_methodId: 2, _methodName_Ar: "تحويل", _methodName_En: "Transfer"),
                                           PaymentMethod(_methodId: 3, _methodName_Ar: "فيزا", _methodName_En: "Visa")];
                                           self.tableView.reloadData();
                       }
            else{
                  PaymentMethodArray = []
                self.tableView.reloadData();
            }
        }
      
    }



}

extension PaymentMethodViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentMethodArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CountryTableViewCell
        if(Utils.getcurrentLanguage() == "ar"){
            if(self.PaymentMethodArray.count > 0){
                let country = PaymentMethodArray[indexPath.row].methodName_Ar;
                cell.countryLabel.text = country;
            }
        }
        
        else{
            let country = PaymentMethodArray[indexPath.row].methodName_En;
            cell.countryLabel.text = country;

        }
          return cell;
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPaymentMethod =  PaymentMethodArray[indexPath.row];
    }

}
