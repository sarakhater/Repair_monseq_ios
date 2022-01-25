//
//  ConditionNewOrderViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 2/5/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ActionSheetPicker_3_0
import DateTimePicker
import MaterialControls

class ConditionNewOrderViewController: UITableViewController ,  MDDatePickerDialogDelegate, MDTimePickerDialogDelegate  ,UITextFieldDelegate {
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var classNoTextField: UITextField!
    
    @IBOutlet weak var tillerNoTextField: UITextField!
    
    @IBOutlet weak var condtionTypes: UITextField!
    
    @IBOutlet weak var conditionBrand: UITextField!
    
    @IBOutlet weak var descTextField: UITextField!
    
    @IBOutlet weak var levelNoTextField: UITextField!
    
    @IBOutlet weak var requestServiceBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var typesList : [model] = [];
    var brandsList : [model] = [];
    var TypeNames = [String]()
    var BrandNames = [String]()
    var selectedTypeId = "";
    var selectedBrandId = ""
    let userDef = UserDefaults.standard
    var datePicker: DateTimePicker?
    var timePicker: DateTimePicker?
    var selectedDay: Date?
    var selectedDayString: String?
    var selectedTimeString: String?
    var selectedTime: Date?
    let datePickerDialoge: MDDatePickerDialog = MDDatePickerDialog()
    let timePickerDialoge: MDTimePickerDialog = MDTimePickerDialog()
    var ClockMode = "";
    @IBOutlet weak var timeEdt: UITextField!
    
    @IBOutlet weak var dateEdt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descTextField.delegate = self
        descTextField.enablesReturnKeyAutomatically = true
        descTextField.returnKeyType = .done

        
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg-2"))
        if(Utils.getcurrentLanguage() == "ar"){
            titleLabel.text = "طلب جديد"
            classNoTextField.placeholder = "رقم الفصل"
            requestServiceBtn.setTitle("اطلب خدمة", for: .normal)
            levelNoTextField.placeholder = "رقم الدور"
            tillerNoTextField.placeholder = "جوال الحارس"
            
        }else{
            titleLabel.text = "New Order"
            classNoTextField.placeholder = "Class No"
            levelNoTextField.placeholder = "Level No"
            tillerNoTextField.text = "Guard Phone"
            requestServiceBtn.setTitle("Request Service", for: .normal)
            
        }
        getTypes()
        getBrands()
        bigView.layer.cornerRadius = 15
        bigView.layer.borderWidth = 1
        bigView.layer.borderColor = UIColor(red: 194/255 , green: 194/255, blue:194/255 , alpha: 1.0).cgColor
        requestServiceBtn.layer.cornerRadius =  15
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTypes(_:)))
        condtionTypes.addGestureRecognizer(tapGestureRecognizer)
        
        let tap2GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openBrands(_:)))
        conditionBrand.addGestureRecognizer(tap2GestureRecognizer)
        
        selectedDay = Date()
        let now = Date();
        datePickerDialoge.minimumDate = now;
        datePickerDialoge.delegate = self
        timePickerDialoge.delegate = self
        populateDateField(selectedDate: Date())
        let dateTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDateSelect(_:)))
        dateEdt.addGestureRecognizer(dateTapGestureRecognizer);
        
        let timeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTimeSelect(_:)))
        timeEdt.addGestureRecognizer(timeTapGestureRecognizer);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func  getTypes(){
        SVProgressHUD.show()
        var url = Constants.API_ENDPOINT + "air_types"
        print(url);
        Alamofire.request(url).responseObject { (response: DataResponse<ConditionTypes>) in
            
            let menuResponse = response.result.value
            if(menuResponse?.data != nil && menuResponse!.data.count > 0){
                self.typesList = (menuResponse?.data ?? []);
                for type in self.typesList {
                    if Utils.getcurrentLanguage() == "ar" {
                        self.TypeNames.append(type.name_ar)
                    } else {
                        self.TypeNames.append(type.name_en)
                    }
                }
                self.tableView.reloadData();
                
            }
            SVProgressHUD.dismiss();
        }
    }
    
    func  getBrands(){
        SVProgressHUD.show()
        var url = Constants.API_ENDPOINT + "air_brands/1"
        print(url);
        Alamofire.request(url).responseObject { (response: DataResponse<ConditionTypes>) in
            
            let menuResponse = response.result.value
            if(menuResponse?.data != nil && menuResponse!.data.count > 0){
                self.brandsList = (menuResponse?.data ?? []);
                for brand in self.brandsList {
                    if Utils.getcurrentLanguage() == "ar" {
                        self.BrandNames.append(brand.name_ar)
                    } else {
                        self.BrandNames.append(brand.name_en)
                    }
                }
                self.tableView.reloadData();
                
            }
            SVProgressHUD.dismiss();
        }
    }
    
    @objc func openTypes(_ gesture:UIGestureRecognizer) {
        var done = ""
        var cancel = ""
        if(Utils.getcurrentLanguage() == "ar"){
            done = "تم";
            cancel = "إلغاء";
        }else{
            done = "Done";
            cancel = "Cancel";
        }
        print("open service types select")
        var title = NSLocalizedString("actionsheet.selectTypetype", comment: "")
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancel, style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.condtionTypes.inputAccessoryView = toolBar
        
        //view.addSubview(myPickerView)
        ActionSheetStringPicker.show(withTitle: title, rows: self.TypeNames, initialSelection: 0, doneBlock: { (picker, index, value) in
            let selectedType = self.typesList[index]
            if(Utils.getcurrentLanguage() == "ar"){
                self.condtionTypes.text = selectedType.name_ar
            }else{
                self.condtionTypes.text = selectedType.name_en
            }
            
            self.selectedTypeId = selectedType.id
            
        }, cancel: { (picker) in
            
        }, origin: condtionTypes)
    }
    
    
    @objc func openBrands(_ gesture:UIGestureRecognizer) {
        var done = ""
             var cancel = ""
             if(Utils.getcurrentLanguage() == "ar"){
                 done = "تم";
                 cancel = "إلغاء";
             }else{
                 done = "Done";
                 cancel = "Cancel";
             }
        print("open service types select")
        var title = NSLocalizedString("actionsheet.selectBrandtype", comment: "")
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancel, style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.conditionBrand.inputAccessoryView = toolBar
        
        //view.addSubview(myPickerView)
        ActionSheetStringPicker.show(withTitle: title, rows: self.BrandNames, initialSelection: 0, doneBlock: { (picker, index, value) in
            let selectedType = self.brandsList[index]
            if(Utils.getcurrentLanguage() == "ar"){
                self.conditionBrand.text = selectedType.name_ar
            }else{
                self.conditionBrand.text = selectedType.name_en
            }
            
            self.selectedBrandId = selectedType.id
            
        }, cancel: { (picker) in
            
        }, origin: conditionBrand)
    }
    
    
    @IBAction func requestPressed(_ sender: UIButton) {
        if(classNoTextField.text!.isEmpty  || tillerNoTextField.text!.isEmpty  || conditionBrand.text!.isEmpty  || condtionTypes.text!.isEmpty  || descTextField.text!.isEmpty || levelNoTextField.text!.isEmpty ){
            
            if(Utils.getcurrentLanguage() == "ar"){
                Utils.showToast(message: "من فضلك أدخل جميع البيانات")
            }else{
                Utils.showToast(message: "Please Enter data")
            }
            
        }else{
            //request services
            let userId = userDef.string(forKey: "user_id") ?? ""
            SVProgressHUD.show()
            ServiceManager.requestConditionService(round_number: levelNoTextField.text ?? "", class_number: classNoTextField.text ?? "", guard_mobile: tillerNoTextField.text ?? "", air_type: selectedTypeId, air_brand: selectedBrandId, desc_ar: descTextField.text ?? "", author: userId, service_day: self.selectedDayString ?? "", service_time: self.selectedTimeString ?? "",  downloadCompeted: { (res) in
                print(res)
                print("*********************************")
                SVProgressHUD.dismiss()
                NotificationCenter.default.post(name: Notification.Name.changeTabBar, object: nil, userInfo: nil);
            })
        }
        
    }
    
    
    @objc func doneClick() {
        condtionTypes.resignFirstResponder()
    }
    @objc func cancelClick() {
        condtionTypes.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Open time picker
    @objc func onTimeSelect (_ gesture:UITapGestureRecognizer) {
        dismissKeyboard();
        if (self.selectedDay != nil) {
            timePickerDialoge.show()
        } else {
            Utils.showToast(message: "Please select date first")
        }

    }
    
    // Open date picker
    @objc func onDateSelect (_ gesture:UITapGestureRecognizer) {
        dismissKeyboard();
        datePickerDialoge.show()
    }
    
    func populateDateField(selectedDate: Date) {
        selectedDay = selectedDate
        selectedDayString = self.formatDate(date: selectedDate)
        dateEdt.text = selectedDayString
        populateTimeField(selectedDate: selectedDate)
    }
    
    func populateTimeField(selectedDate: Date) {
        selectedTimeString = formatDate(date: selectedDate, format: "HH:mm")
        selectedTimeString?.append(ClockMode);
        timeEdt.text = selectedTimeString;
    }
    
    func formatDate(date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        let formattedDate: String = dateFormatter.string(from: date)
        return formattedDate
    }
    
    
    func datePickerDialogDidSelect(_ date: Date) {
        print("selected date\(date)")
        populateDateField(selectedDate: date)
    }
    
    func timePickerDialog(_ timePickerDialog: MDTimePickerDialog, didSelectHour hour: Int, andMinute minute: Int) {
        //self.populateTimeField(selectedDate: date)
        var Actualhour = hour;
       // let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: selectedDay!)!
        
        
        if(hour > 12){
            Actualhour = hour - 12;
            ClockMode = " PM";
        }else{
            ClockMode = " AM";
        }
        
         let date = Calendar.current.date(bySettingHour: Actualhour, minute: minute, second: 0, of: selectedDay!)!
        
        self.populateTimeField(selectedDate: date)
    }
}
