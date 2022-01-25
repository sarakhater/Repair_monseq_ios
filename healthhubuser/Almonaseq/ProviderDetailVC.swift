//
//  ProviderDetailVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 4/22/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyStarRatingView
import MessageUI



class ProviderDetailVC: UITableViewController ,  MFMessageComposeViewControllerDelegate{
    var provider: Provider?
    var orderId: String?
    var imageUrl = "";
    var rating  : Float!
    
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var dailyPrice: UILabel!
    @IBOutlet weak var hourlyPrice: UILabel!
    @IBOutlet weak var otherPhone: UILabel!
    @IBOutlet weak var experience: UILabel!
    
    
    @IBOutlet weak var rateBar: SwiftyStarRatingView!
    @IBOutlet weak var tecImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = provider?.name
        mobile.text = provider?.phone
        email.text = provider?.email
        experience.text = provider?.experience
        otherPhone.text = provider?.otherPhone
        dailyPrice.text = (provider?.dailyPrice)! + " " + NSLocalizedString("app.currency", comment: "")
        hourlyPrice.text = (provider?.hourlyPrice)! + " " + NSLocalizedString("app.currency", comment: "")
        self.tecImageView.sd_setImage(with: URL(string: self.imageUrl), placeholderImage: UIImage(named: "logo-r"))
        self.rateBar.value = CGFloat(self.rating);
    }

  
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func accept(_ sender: Any) {
        if (orderId != nil) {
            UserManager.acceptRequest(reqId: orderId!, techId: (provider?.id)!, downloadComplete: { (res) in
                if let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as? OrdersVC {
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
//                let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
//                self.navigationController?.popToViewController(vc, animated: true)
            })

        }
    }
    
    
    
    
    @IBAction func handleCall(_ sender: Any) {
        
        guard let number = URL(string: "tel://" + (provider?.phone)!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [(provider?.phone)!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openWhatsApp(_ sender: Any) {
        
        let urlWhats = "whatsapp://send?phone=\(provider?.phone))"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    UIApplication.shared.openURL(whatsappURL)
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func startChattingClicked(_ sender: Any) {
        
     
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageDetailsViewController") as! MessageDetailsViewController
        vc.tech_id = (provider?.id)!;
        vc.userName = (provider?.name)!;
        vc.order_id = orderId ?? "";
        self.navigationController?.pushViewController(vc, animated: true);
    }
}
