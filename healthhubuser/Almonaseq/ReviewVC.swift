//
//  ReviewVC.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/21/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import Alamofire

class ReviewVC: UITableViewController, UITextViewDelegate  , UITextFieldDelegate{
    //var initialSetupViewController: PTFWInitialSetupViewController!
    
    var provider: Provider?
    var orderId: String?
    var request: Request?
    var emojiRate = 0;
    var selectedPaymentMethod = PaymentMethod();
    var status = "false";
    var showCashStatus = false;
    var showVisaStatus = false;
    
    @IBOutlet weak var payNowBtn: UIButton!{
        didSet {
            payNowBtn.layer.cornerRadius =  10
            payNowBtn.layer.borderColor = Constants.BORDER_COLOR
            payNowBtn.layer.borderWidth = 2
            
        }
    }
    @IBOutlet weak var sen_feddback_label: UILabel!
    @IBOutlet weak var lbl_excelent: UILabel!
    let currentLanguage = L102Language.currentAppleLanguage();
    
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var lblGood: UILabel!
    @IBOutlet weak var lblVgood: UILabel!
    @IBOutlet weak var lblAcceptable: UILabel!
    @IBOutlet weak var expandImage: UIImageView!
    @IBOutlet weak var lblWeak: UILabel!
    var placeHolderText = NSLocalizedString("review.addComment", comment: "")
    
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var rating: SwiftyStarRatingView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var btnAddRate: UIButton!
    
    
    
    @IBOutlet weak var paymentTextField: UITextField!{
        didSet {
            paymentTextField.layer.cornerRadius =  20
            paymentTextField.layer.borderColor = Constants.BORDER_COLOR
            paymentTextField.layer.borderWidth = 2
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            paymentTextField.leftView = leftView
            paymentTextField.leftViewMode = .always
        }
    }
     
    
    override func viewWillAppear(_ animated: Bool) {
        if(L102Language.getRegisterType() == 1){
            //School
            currencyLbl.isHidden = true
            amount.isHidden = true
            expandImage.isHidden = true
            self.paymentTextField.isHidden = true
            self.tableView.reloadData();
            
        }else{
            currencyLbl.isHidden = false
            amount.isHidden = false
        }
    }
    
    func checkPayment(){
        
        //{"showcash":true,"showvisa":false}
        Alamofire.request(Constants.ShowPayment)
            
            .responseJSON{ (response) in
                if response.result.isSuccess {
                    guard  let data = response.result.value as? [String : Any] else {
                        return
                    }
                    print(data);
                    guard let showcash = data["showcash"] as? Bool else {
                        return
                    }
                    print(showcash)
                    if(showcash == true){
                        //show Payment Method
                        
                        self.showCashStatus = true;
                        guard let showvisa = data["showvisa"] as? Bool else {
                            return
                        }
                        if(showvisa == true){
                            self.showVisaStatus = true;
                        }
                        self.paymentTextField.isHidden = false;
                        self.expandImage.isHidden = false;
                        self.tableView.reloadData();
                    }else{
                        // check visa
                        guard let showvisa = data["showvisa"] as? Bool else {
                            return
                        }
                        if(showvisa == true){
                            self.showVisaStatus = true;
                            self.paymentTextField.isHidden = false;
                            self.expandImage.isHidden = false;
                            self.tableView.reloadData();
                        }
                        else{
                            self.paymentTextField.isHidden = true;
                            self.expandImage.isHidden = true;
                            
                            self.tableView.reloadData();
                        }
                        
                        
                    }
                }
                else{
                    print("there was an error")
                }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        payNowBtn.isHidden = true;
        if(status == "true"){
            //show Payment Method
            
            self.paymentTextField.isHidden = false;
            self.expandImage.isHidden = false;
            self.tableView.reloadData();
        }else{
            self.paymentTextField.isHidden = true;
            self.expandImage.isHidden = true;
            
            self.tableView.reloadData();
        }
        checkPayment();
        amount.isUserInteractionEnabled = true;
        let tapCountryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelectPayment(_:)));
        paymentTextField.addGestureRecognizer(tapCountryGestureRecognizer);
        lbl_excelent.font = UIFont(name: Constants.regularFont, size: 10)
        lblVgood.font = UIFont(name: Constants.regularFont, size: 10)
        
        lblGood.font = UIFont(name: Constants.regularFont, size: 10)
        
        lblAcceptable.font = UIFont(name: Constants.regularFont, size: 9)
        
        lblWeak.font = UIFont(name: Constants.regularFont, size: 10);
        
        if self.currentLanguage == "en" {
            amount.text = (request?.price ?? "0");
            
            sen_feddback_label.text = "Send Feedback";
            paymentTextField.placeholder = "Choose Payment Method";
            lbl_excelent.text = "Excellent";
            lblVgood.text = "VeryGood";
            lblGood.text = "Good";
            lblAcceptable.text = "Acceptable";
            lblWeak.text = "Weak";
            btnAddRate.setTitle("Rate and close Order", for: .normal);
            payNowBtn.setTitle("Pay Now", for: .normal);
            
        } else {
            
            amount.text = ( request?.price  ?? "0");
            sen_feddback_label.text = "هل تمت خدمتك بشكل ممتاز؟";
            paymentTextField.placeholder = "اختر طريقة الدفع";
            lbl_excelent.text = "ممتاز";
            lblVgood.text = "جيد جدا";
            lblGood.text = "جيد";
            lblAcceptable.text = "مقبول";
            lblWeak.text = "ضعيف";
            btnAddRate.setTitle("قيم وأغلق الطلب", for: .normal);
            payNowBtn.setTitle("ادفع الان", for: .normal);
            
            
        }
        amount.delegate = self
        
        self.providerName.text = provider?.name
        comment.delegate = self
        comment.text = placeHolderText
        comment.textColor = .lightGray
        comment.returnKeyType = .done
        comment.enablesReturnKeyAutomatically = true
        
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround();
        self.amount.layer.cornerRadius = 20;
        self.amount.layer.borderWidth = 2.0;
        self.amount.layer.borderColor = Constants.BORDER_COLOR;
        
        self.comment.layer.cornerRadius = 20;
        self.comment.layer.borderWidth = 2.0;
        self.comment.layer.borderColor = Constants.BORDER_COLOR;
        rating.addTarget(self, action: #selector(ratingChanged), for: .valueChanged)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    @objc func onSelectPayment(_ gesture:UITapGestureRecognizer) {
        
        showPaymentMethodInAlert();
    }
    
    func showPaymentMethodInAlert(){
        
        let contentViewController = PaymentMethodViewController();
        contentViewController.showCashStatus = self.showCashStatus ;
        contentViewController.showVisaStatus = self.showVisaStatus;
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        // height constraint
        let constraintHeight = NSLayoutConstraint(
            item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(constraintHeight);
        
        // width constraint
        let constraintWidth = NSLayoutConstraint(
            item: alertController.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(constraintWidth);
        
        let okAction = UIAlertAction(title:  NSLocalizedString("alert.ok", comment: ""), style: .default, handler: {
            action in
            
            
            self.selectedPaymentMethod = contentViewController.selectedPaymentMethod;
            
            //            if(self.selectedPaymentMethod.methodId == 3){
            //                self.payNowBtn.isHidden = false;
            //            }else{
            //                  self.payNowBtn.isHidden = true;
            //            }
            
            if(Utils.getcurrentLanguage() == "ar"){
                self.paymentTextField.text = self.selectedPaymentMethod.methodName_Ar;
            }else{
                self.paymentTextField.text = self.selectedPaymentMethod.methodName_En;
            }
            
        })
        alertController.addAction(okAction)
        
        // Create custom content viewController
        
        contentViewController.preferredContentSize = contentViewController.view.bounds.size
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil);
        
    }
    
    
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == amount {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789١٢٣٤٥٦٧٨٩٠ ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @objc func ratingChanged(){
        var alert = UIAlertController();
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        if(rating.value == 1.0){
            lblWeak.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lblGood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            //Utils.showToast(message: "ضعيف")
           // alert =  Utils.showAlertWithoutok(message: "ضعيف")
           // self.present(alert, animated: true, completion: nil)
        }
        else if(rating.value == 2.0){
            //Utils.showToast(message: "مقبول")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
           // alert =  Utils.showAlertWithoutok(message: "مقبول")
           // self.present(alert, animated: true, completion: nil)

        }
        else if(rating.value == 3.0){
            //Utils.showToast(message: "جيد")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor =  UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
           // alert =  Utils.showAlertWithoutok(message: "جيد")
           // self.present(alert, animated: true, completion: nil)
        }
        else if(rating.value == 4.0){
            //Utils.showToast(message: "جيد جدا")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor =  UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
           // alert =  Utils.showAlertWithoutok(message: "جيد جدا")
           // self.present(alert, animated: true, completion: nil)
        }
        else if(rating.value == 5.0){
            //Utils.showToast(message: "ممتاز")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor =  UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            //alert =  Utils.showAlertWithoutok(message: "ممتاز")
            //self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func emojiClicked(_ sender: UIButton) {
        emojiRate = sender.tag;
//        var alert = UIAlertController();
//        let delay = 5.0 * Double(NSEC_PER_SEC)
//        let when = DispatchTime.now() + 2
//        DispatchQueue.main.asyncAfter(deadline: when){
//            // your code with delay
//            alert.dismiss(animated: true, completion: nil)
//        }
//        if(emojiRate == 1){
//            //Utils.showToast(message: "ضعيف")
//            alert =  Utils.showAlertWithoutok(message: NSLocalizedString("rating.vbad", comment: ""));
//
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if(emojiRate == 2){
//            //Utils.showToast(message: "مقبول")
//            alert =  Utils.showAlertWithoutok(message: NSLocalizedString("rating.bad", comment: ""));
//            self.present(alert, animated: true, completion: nil)
//
//        }
//        else if(emojiRate == 3){
//            //Utils.showToast(message: "جيد")
//            alert =  Utils.showAlertWithoutok(message: NSLocalizedString("rating.good", comment: ""));
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if(emojiRate == 4){
//            //Utils.showToast(message: "جيد جدا")
//            alert =  Utils.showAlertWithoutok(message: NSLocalizedString("rating.vgood", comment: ""));
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if(emojiRate == 5){
//            //Utils.showToast(message: "ممتاز")
//            alert =  Utils.showAlertWithoutok(message: NSLocalizedString("rating.excellent", comment: ""));
//            self.present(alert, animated: true, completion: nil)
//        }
//        
//        
        if(emojiRate == 1){
            lblWeak.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lblGood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            //Utils.showToast(message: "ضعيف")
           // alert =  Utils.showAlertWithoutok(message: "ضعيف")
           // self.present(alert, animated: true, completion: nil)
        }
        else if(emojiRate == 2){
            //Utils.showToast(message: "مقبول")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
           // alert =  Utils.showAlertWithoutok(message: "مقبول")
           // self.present(alert, animated: true, completion: nil)

        }
        else if(emojiRate == 3){
            //Utils.showToast(message: "جيد")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor =  UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
           // alert =  Utils.showAlertWithoutok(message: "جيد")
           // self.present(alert, animated: true, completion: nil)
        }
        else if(emojiRate == 4){
            //Utils.showToast(message: "جيد جدا")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor =  UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
           // alert =  Utils.showAlertWithoutok(message: "جيد جدا")
           // self.present(alert, animated: true, completion: nil)
        }
        else if(emojiRate == 5){
            //Utils.showToast(message: "ممتاز")
            lblWeak.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblGood.textColor =  UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblVgood.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lblAcceptable.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
            lbl_excelent.textColor = UIColor(red: 253/255, green: 58/255, blue: 105/255, alpha: 1.0)
            //alert =  Utils.showAlertWithoutok(message: "ممتاز")
            //self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func addRating(_ sender: Any) {
        addRating()
    }
    
    func addRating() {
        var amount = NSNumber();
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        if let final = Formatter.number(from: self.amount.text!) {
            print(final)
            amount = final;
            print(amount.stringValue);
        }
        
        
        if (request != nil) {
            
            UserManager.rateTech(id: request!.id, amount: amount.stringValue , techId: request!.userId, rate: CGFloat(emojiRate), comment: comment.text ?? "", payment_way : 0  ,downloadCompleted: { (res) in
                    // Go to my requests page
                    print(res)
                    
                    self.navigationController?.popViewController(animated: true)
                    //self.dismiss(animated: true, completion: nil);
                    //                 let vc = UIStoryboard(name: "Service", bundle: nil).instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
                    //                self.navigationController?.popToViewController(vc, animated: true)
                })
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text != "")
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeHolderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    
    @IBAction func payNowClicked(_ sender: UIButton) {
        let bundle = Bundle(url: Bundle.main.url(forResource: "Resources", withExtension: "bundle")!)
        //         self.initialSetupViewController = PTFWInitialSetupViewController.init(applePayWith: bundle, andWithViewFrame:  self.view.frame, andWithAmount: (request?.price ?? "0").floatValue, andWithCustomerTitle: "PayTabs", andWithCurrencyCode: "SAR", andWithCountryCode: "SA", andWithSDKLanguage: "en", andWithOrderID: "", andIsPreAuth: true, andWithMerchantEmail: "", andWithMerchantSecretKey: "", andWithMerchantApplePayIdentifier: "merchant.com.paytabs.healthubuser", andWithAssigneeCode: "")
        
        //               self.initialSetupViewController = PTFWInitialSetupViewController.init(
        //                   bundle: bundle,
        //                andWithViewFrame: self.view.frame,
        //                              andWithAmount: 5.0,
        //                              andWithCustomerTitle: "PayTabs Sample App",
        //                              andWithCurrencyCode: "USD",
        //                              andWithTaxAmount: 0.0,
        //                              andWithSDKLanguage: "en",
        //                              andWithShippingAddress: "Manama",
        //                              andWithShippingCity: "Manama",
        //                              andWithShippingCountry: "BHR",
        //                              andWithShippingState: "Manama",
        //                              andWithShippingZIPCode: "123456",
        //                              andWithBillingAddress: "Manama",
        //                              andWithBillingCity: "Manama",
        //                              andWithBillingCountry: "BHR",
        //                              andWithBillingState: "Manama",
        //                              andWithBillingZIPCode: "12345",
        //                              andWithOrderID: "12345",
        //                              andWithPhoneNumber: "0097333109781",
        //                              andWithCustomerEmail: "rhegazy@paytabs.com",
        //                              andIsTokenization:false,
        //                              andIsPreAuth: false,
        //                              andWithMerchantEmail: "rhegazy@paytabs.com",
        //                              andWithMerchantSecretKey: "BIueZNfPLblJnMmPYARDEoP5x1WqseI3XciX0yNLJ8v7URXTrOw6dmbKn8bQnTUk6ch6L5SudnC8fz2HozNBVZlj7w9uq4Pwg7D1",
        //                              andWithAssigneeCode: "SDK",
        //                              andWithThemeColor:UIColor.red,
        //                              andIsThemeColorLight: false)
        //
        //
        //               self.initialSetupViewController.didReceiveBackButtonCallback = {
        //
        //               }
        //
        //               self.initialSetupViewController.didStartPreparePaymentPage = {
        //                   // Start Prepare Payment Page
        //                   // Show loading indicator
        //               }
        //               self.initialSetupViewController.didFinishPreparePaymentPage = {
        //                   // Finish Prepare Payment Page
        //                   // Stop loading indicator
        //               }
        //
        //               self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
        //                   print("Response Code: \(responseCode)")
        //                   print("Response Result: \(result)")
        //
        //                   // In Case you are using tokenization
        //                   print("Tokenization Cutomer Email: \(tokenizedCustomerEmail)");
        //                   print("Tokenization Customer Password: \(tokenizedCustomerPassword)");
        //                   print("TOkenization Token: \(token)");
        //               }
        //
        //        self.view.addSubview(initialSetupViewController.view)
        //        self.addChildViewController(initialSetupViewController)
        //
        //        initialSetupViewController.didMove(toParentViewController: self);
        
        //        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        //               // height constraint
        //               let constraintHeight = NSLayoutConstraint(
        //                   item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
        //                   NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 800)
        //               alertController.view.addConstraint(constraintHeight);
        //
        //               // width constraint
        //               let constraintWidth = NSLayoutConstraint(
        //                   item: alertController.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
        //                   NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 1000)
        //               alertController.view.addConstraint(constraintWidth);
        //
        //
        //
        //               // Create custom content viewController
        //
        //               initialSetupViewController.preferredContentSize = initialSetupViewController.view.bounds.size
        //               alertController.setValue(initialSetupViewController, forKey: "contentViewController")
        //               present(alertController, animated: true, completion: nil);
        
        
        //  self.navigationController?.pushViewController(initialSetupViewController, animated: false);
    }
}
