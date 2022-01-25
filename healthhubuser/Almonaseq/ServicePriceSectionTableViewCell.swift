//
//  ServicePriceSectionTableViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 2/2/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
protocol updateCellHeightDelegate{
    func updateCellHeight(isExpanded : Bool)
}

class ServicePriceSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bigView: UIView!
    var delegate : updateCellHeightDelegate!
    var isExpanded = false
    @IBOutlet weak var bigExpandBtn: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var priceCellTableView: UITableView!
    @IBOutlet weak var expandButton: UIButton!
    var priceList : [PriceItem] = []
    let rowReuseIdentifier = "PriceItemTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.layer.cornerRadius =  10
        bigView.layer.borderWidth = 1
        bigView.layer.borderColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1).cgColor
        expandButton.layer.cornerRadius = 3
        priceCellTableView.register(UINib(nibName: rowReuseIdentifier, bundle: nil), forCellReuseIdentifier: rowReuseIdentifier)
        priceCellTableView.delegate = self
        priceCellTableView.dataSource = self
        priceCellTableView.isHidden = true
        expandButton.setImage(UIImage(named: "icons8-expand-arrow-50"), for: .normal)
        bigExpandBtn.setImage(UIImage(named: "icons8-expand-arrow-50"), for: .normal)
    }
    
    @IBAction func expandPressed(_ sender: UIButton) {
        let expandImg = UIImage(named: "icons8-expand-arrow-50")
        let collapseImg = UIImage(named: "ic_arrow_up")

        if(sender.currentImage == expandImg){
            priceCellTableView.isHidden = false
            sender.setImage(collapseImg, for: .normal)
              expandButton.setImage(collapseImg, for: .normal)
            isExpanded = true
            delegate.updateCellHeight(isExpanded: isExpanded)
        }
        else if(sender.currentImage == collapseImg){
            priceCellTableView.isHidden = true
            sender.setImage(expandImg, for: .normal)
            expandButton.setImage(expandImg, for: .normal)

            isExpanded = false
            delegate.updateCellHeight(isExpanded: isExpanded)

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ServicePriceSectionTableViewCell : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = priceCellTableView.dequeueReusableCell(withIdentifier: rowReuseIdentifier, for: indexPath) as! PriceItemTableViewCell
        
        let priceItem = priceList[indexPath.row]
        if(Utils.getcurrentLanguage() == "ar"){
            cell.itemLabel.text = priceItem.name
        }else{
            cell.itemLabel.text = priceItem.englishName
        }
        cell.priceLabel.text = priceItem.price
        return cell
    }
    
    
}
