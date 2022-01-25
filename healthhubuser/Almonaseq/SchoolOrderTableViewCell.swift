//
//  SchoolOrderTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/18/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit

protocol SchoolOrderTableViewCellDelegate {
    func search(request : Request)
    func cancelOrder(request : Request)
}

class SchoolOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityTitleLbl: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var levelNoLabel: UILabel!
    @IBOutlet weak var classNoLabel: UILabel!
    @IBOutlet weak var guardPhoneLabel: UILabel!
    @IBOutlet weak var conditionTypeLabel: UILabel!
    @IBOutlet weak var conditionBrandLabel: UILabel!
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requestImageView: UIImageView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var providerVide: UIView!
    
    @IBOutlet weak var providerNameLbl: UILabel!
    
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var providerPhoneLbl: UILabel!
    var selectedRequest  : Request?
    var delegate : SchoolOrderTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius = 15
        bigView.layer.borderWidth = 1
        providerVide.layer.cornerRadius = 12
        bigView.layer.borderColor = UIColor(red: 66/255, green: 60/255, blue: 102/255, alpha: 1.0).cgColor
        searchBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(request: Request) {
        self.selectedRequest = request
        let day = selectedRequest?.serviceDay
        self.timelabel.text = day! + "  - " +  selectedRequest!.serviceTime ?? "";
        self.levelNoLabel.text = selectedRequest?.round_number
        self.classNoLabel.text = selectedRequest?.class_number
        self.guardPhoneLabel.text = selectedRequest?.guard_mobile
        self.providerNameLbl.text = request.userName
        self.providerPhoneLbl.text = request.userPhone
        self.rateLbl.text =  "0/5" //request
        statusBtn.layer.cornerRadius =  10
        if(Utils.getcurrentLanguage() == "ar"){
            self.titleLabel.text = selectedRequest?.main_cat
            cityLabel.text = selectedRequest?.cityAr
            //search
            if(request.status == 1){
                self.searchBtn.isHidden = true
                self.statusBtn.setTitle("قيد الانتظار", for: .normal)
                self.statusBtn.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
                providerVide.isHidden = true
                cancelBtn.isHidden = false
                topConstraint.constant = 30

            }else{
                if(request.status == 2){
                    self.statusBtn.setTitle("قيد التنفيذ", for: .normal)
                    self.statusBtn.backgroundColor = UIColor(red: 38/255, green: 122/255, blue: 135/255, alpha: 1.0)
                    providerVide.isHidden = false
                    cancelBtn.isHidden = true
                    searchBtn.isHidden = false
                    topConstraint.constant = 73
                    self.searchBtn.setTitle("أضف تقييم", for: .normal)

                }else if(request.status == 3){
                    self.statusBtn.setTitle("انتهي التنفيذ", for: .normal)
                    self.statusBtn.backgroundColor = UIColor(red: 38/255, green: 122/255, blue: 135/255, alpha: 1.0)
                    self.searchBtn.isHidden = false
                    providerVide.isHidden = false
                    cancelBtn.isHidden = true
                    topConstraint.constant = 73

                   // if(request.feedBack == "false"){
                        self.searchBtn.setTitle("أضف تقييم", for: .normal)
                   /// }else{
                      //  self.searchBtn.setTitle("تعديل التقييم", for: .normal)
                        
                   // }
                }
                else if(request.status == 4){
                    self.statusBtn.setTitle("مكتمل", for: .normal)
                    self.statusBtn.backgroundColor = UIColor(red: 41/255, green: 206/255, blue: 0, alpha: 1.0)
                    cancelBtn.isHidden = true
                    searchBtn.isHidden = true
                    providerVide.isHidden = false
                    topConstraint.constant = 73
                }
                
                
            }
            conditionTypeLabel.text = selectedRequest?.air_type_ar
            conditionBrandLabel.text = selectedRequest?.air_brand_ar
        }else{
            //english
            cityLabel.text = selectedRequest?.cityEN
            self.titleLabel.text = selectedRequest?.main_cat_en
            if(request.status == 1){
                self.searchBtn.isHidden = true
                self.statusBtn.setTitle("Waiting", for: .normal)
                self.statusBtn.backgroundColor = UIColor(red: 38/255, green: 121/255, blue: 135/255, alpha: 1.0)
                providerVide.isHidden = true
                cancelBtn.isHidden = true
                topConstraint.constant = 40

            }else{
                if(request.status == 2){
                    self.statusBtn.setTitle("Under Processing", for: .normal)
                    self.statusBtn.backgroundColor = UIColor(red: 38/255, green: 122/255, blue: 135/255, alpha: 1.0)
                    providerVide.isHidden = false
                    cancelBtn.isHidden = true
                    searchBtn.isHidden = false
                    self.searchBtn.setTitle("Add Review", for: .normal)

                    topConstraint.constant = 96
                }else if(request.status == 3){
                    self.statusBtn.setTitle("Execution Finished", for: .normal)
                    self.statusBtn.backgroundColor = UIColor(red: 38/255, green: 122/255, blue: 135/255, alpha: 1.0)
                    self.searchBtn.isHidden = false
                    providerVide.isHidden = false
                    cancelBtn.isHidden = true
                    topConstraint.constant = 96
                   // if(request.feedBack  == "false"){
                        self.searchBtn.setTitle("Add Review", for: .normal)
                    //}else{
                       // self.searchBtn.setTitle("Edit Review", for: .normal)
                    //}
                }
                else if(request.status == 4){
                    self.statusBtn.setTitle("Completed", for: .normal)
                    self.statusBtn.backgroundColor = UIColor(red: 41/255, green: 206/255, blue: 0, alpha: 1.0)
                    cancelBtn.isHidden = true
                    searchBtn.isHidden = true
                    providerVide.isHidden = false
                    topConstraint.constant = 96
                }
                
                
            }
            
            conditionTypeLabel.text = selectedRequest?.air_type_en
            conditionBrandLabel.text = selectedRequest?.air_brand_en
        }
        descLabel.text = selectedRequest?.desc
        
        
    }
    
    
    @IBAction func search(_ sender: UIButton) {
        delegate?.search(request : self.selectedRequest!)
    }
    
    @IBAction func cancelOrder(_ sender: UIButton) {
        delegate?.cancelOrder(request : self.selectedRequest!)
    }
}
