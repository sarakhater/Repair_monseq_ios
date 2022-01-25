//
//  RequestServiceVC.swift
//  Almonaseq
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import UIKit
import LocationPicker
import DateTimePicker
import MobileCoreServices
import CoreLocation
import MaterialControls
import SwiftValidator
import MapKit
import ActionSheetPicker_3_0
import SVProgressHUD
import Alamofire



class RequestVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , MKMapViewDelegate, CLLocationManagerDelegate , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate ,  MDDatePickerDialogDelegate, MDTimePickerDialogDelegate , UITextViewDelegate{
    
    let validator = Validator()
    var requestType: String?
    var selectedProduct: Product?
    var productAmount = 1
    var serviceTypes = [Category]()
    let imagePicker = UIImagePickerController()
    var coords: [String:Double]?
    var selectedAddres: String?
    var userId: String?
    var categoryId: String?
    var datePicker: DateTimePicker?
    var timePicker: DateTimePicker?
    var selectedDay: Date?
    var selectedDayString: String?
    var selectedTimeString: String?
    var selectedTime: Date?
    var selectedImage: UIImage?
    var selectedVideoUrl: URL?
    var selectedServiceId = ""
    var serviceTypeNames = [String]()
    let datePickerDialoge: MDDatePickerDialog = MDDatePickerDialog()
    let timePickerDialoge: MDTimePickerDialog = MDTimePickerDialog()
    let locationManager = CLLocationManager()
    var lat  = 0.0;
    var lang = 0.0;
    var mapIsOpened = false;
    var ClockMode = "";
    var selectedCategoriesList : [Category] = []
    var selectedSubCategoriesList : [Category] = []
    var selectedCountryIds: [String] = []
    var selectedCityIds: [String] = []
    var categories = [Category]()
    var categoryNames = [String]()
    var subCategories = [Category]()
    var subCategoryNames = [String]()
    let currentLanguage = L102Language.currentAppleLanguage()
    
 
    @IBOutlet weak var requestButton: GradientButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectServiceType: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var cityEdt: UITextField!{
        didSet {
            cityEdt.layer.cornerRadius =  20
            cityEdt.layer.borderColor = Constants.MainColor.cgColor
            cityEdt.layer.borderWidth = 1
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            cityEdt.leftView = leftView
            cityEdt.leftViewMode = .always
        }
    }
    
    @IBOutlet weak var timeEdt: UITextField!{
        didSet {
            timeEdt.layer.cornerRadius =  20
            timeEdt.layer.borderColor = Constants.MainColor.cgColor
            timeEdt.layer.borderWidth = 1
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            timeEdt.leftView = leftView
            timeEdt.leftViewMode = .always
        }
    }
    

    
    @IBOutlet weak var dateEdt: UITextField!{
        didSet {
            dateEdt.layer.cornerRadius =  20
            dateEdt.layer.borderColor = Constants.MainColor.cgColor
            dateEdt.layer.borderWidth = 1
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            dateEdt.leftView = leftView
            dateEdt.leftViewMode = .always
        }
    }
    
    @IBOutlet weak var descriptionTxt: UITextView!{
        didSet {
            descriptionTxt.layer.cornerRadius =  25
            descriptionTxt.layer.borderColor = Constants.MainColor.cgColor
            descriptionTxt.layer.borderWidth = 1
            descriptionTxt.text = NSLocalizedString("Description", comment: "")
            descriptionTxt.textColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
           
        }
    }
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        getCitiesBasedCountryId();
        descriptionTxt.delegate = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg-2"))
        mapIcon.setMainColoredImage(name: "order_loc_icon")
        setTextFieldRoundedView();
        requestButton.layer.cornerRadius = 15;
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        if(self.locationManager.location != nil){
            let new_lat =  self.locationManager.location!.coordinate.latitude;
            let new_lang =  self.locationManager.location!.coordinate.longitude;
            //var new address = self.locationManager.location?.addre
            print(new_lat);
            print(new_lang);
            let newAddress =  getAddressFromLatLon(pdblLatitude: ("\(new_lat)"), withLongitude: ("\(new_lang)"))
            print(newAddress);
            address.text =  newAddress;
            lat = new_lat;
            lang = new_lang;
        }
        self.mapView.showsUserLocation = true
        let longPressGesture = UITapGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        self.mapView.addGestureRecognizer(longPressGesture)
        self.mapIcon.isUserInteractionEnabled = true;
        let tapPressGesture = UITapGestureRecognizer(target: self, action: #selector(chooseLocation(_:)))
        self.mapIcon.addGestureRecognizer(tapPressGesture);
        
        address.inputView = UIView()
 
        // Dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        let tapCityGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSelectCity(_:)));
        cityEdt.addGestureRecognizer(tapCityGestureRecognizer);
        
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.descriptionTxt.text = ""
        descriptionTxt.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    
    /* Updated for Swift 4 */
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }

       /* Older versions of Swift */
       func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
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
    func setTextFieldRoundedView(){
        
        address.layer.borderWidth = 1.0;
        self.address.layer.borderColor = Constants.MainColor.cgColor;
        self.address.layer.cornerRadius = 15;
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        selectServiceType.layer.borderWidth = 1.0;
        self.selectServiceType.layer.borderColor = Constants.MainColor.cgColor
        self.selectServiceType.layer.cornerRadius = 15;
      
    }
    
    
    func chooseLocation( gesture: UITapGestureRecognizer) {
        print("choose location")

        let locationPicker = LocationPickerViewController()
        locationPicker.mapType = .standard // default: .Hybrid
        locationPicker.showCurrentLocationInitially = true
        locationPicker.showCurrentLocationButton = true
        locationPicker.selectCurrentLocationInitially = true
        navigationController?.pushViewController(locationPicker, animated: true)
        
        locationPicker.completion = { location in
            // do some awesome stuff with location
            locationPicker.dismiss(animated: true, completion: nil);
            
            print("location is\(String(describing: location?.address)) - ")
            self.address.text = location?.address
            self.coords = ["lat": (location?.coordinate.latitude)!, "long": (location?.coordinate.longitude)!]
            self.lat = (location?.coordinate.latitude)!;
            self.lang = (location?.coordinate.longitude)!;
            print("coords: \(String(describing: self.coords))")
            
        }
        
    }
    
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        var annotation = MKPointAnnotation()
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            //Now use this coordinate to add annotation on map.
            
            annotation.coordinate = coordinate
            //Set title and subtitle if you want
            annotation.title = "My location"
            // annotation.subtitle = "subtitle"
            mapView.removeAnnotations(mapView.annotations)
            self.mapView.addAnnotation(annotation)
            var lat = annotation.coordinate.latitude;
            var longitude = annotation.coordinate.longitude;
            self.lat = lat;
            self.lang = longitude;
            var addressPined =  getAddressFromLatLon(pdblLatitude: ("\(lat)"), withLongitude: ("\(longitude)"))
            // self.address.text = ("\(addressPined)");
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: populate address field with user saved location
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openServiceTypesSelect(_:)))
        selectServiceType.addGestureRecognizer(tapGestureRecognizer)
        self.getServiceTypes()
        
    }
    
    @IBAction func chooseLocation(_ sender: UITextField) {
        print("choose location")
        //        setupLocationPicker()
        if(!mapIsOpened){
            // if((self.address.text?.isEmpty)!){
            mapIsOpened = true;
            let locationPicker = LocationPickerViewController()
            locationPicker.mapType = .standard // default: .Hybrid
            locationPicker.showCurrentLocationInitially = true
            locationPicker.showCurrentLocationButton = true
            locationPicker.selectCurrentLocationInitially = true
            // self.present(locationPicker, animated: true, completion: nil);
            navigationController?.pushViewController(locationPicker, animated: true)
            
            locationPicker.completion = { location in
                // do some awesome stuff with location
                
                self.navigationController?.popViewController(animated: true);
                
                //locationPicker.navigationController?.popToViewController(self, animated: false)
                // locationPicker.dismiss(animated: true, completion: nil);
                self.mapIsOpened = false;
                print("location is\(String(describing: location?.address)) - ")
                self.address.text = location?.address
                
                self.coords = ["lat": (location?.coordinate.latitude)!, "long": (location?.coordinate.longitude)!]
                self.lat = (location?.coordinate.latitude)!;
                self.lang = (location?.coordinate.longitude)!;
                print("coords: \(String(describing: self.coords))")
                // self.address.setError(nil, animated: false)
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        self.view.endEditing(true);
        return true;
    }
    
    
    // Setting location picker
    func setupLocationPicker() {
        let locationPicker = LocationPickerViewController()
        locationPicker.mapType = .standard // default: .Hybrid
        navigationController?.pushViewController(locationPicker, animated: true)
        let location = CLLocation(latitude: 35, longitude: 35)
        
        Utils.geocode(latitude: 30.09901, longitude: 31.31689) { (placemark, error) in
            print("place mark")
            let initialLocation = Location(name: "My home", location: location, placemark: placemark!)
            locationPicker.location = initialLocation
            locationPicker.mapType = .standard // default: .Hybrid
            
        }
        
        locationPicker.completion = { location in
            // do some awesome stuff with location
            print("location is\(String(describing: location?.address)) - ")
            self.address.text = location?.address
            self.selectedAddres = location?.address
            self.coords = ["lat": (location?.coordinate.latitude)!, "long": (location?.coordinate.longitude)!]
            print("coords: \(String(describing: self.coords))")
        }
        
    }
    
    func requestService() {
        print("selected day: \(selectedDayString), selectedTime: \(selectedTimeString)")
        //self.userDef.set(id, forKey: "user_id")
        let userDef = UserDefaults.standard
        self.userId =  userDef.string(forKey: "user_id") ?? ""
        if(self.address.text == "" ){
            //Utils.showAlertWithoutok(message: "من فضلك اختار العنوان")
            Utils.showToast(message: "قم باختيار عنوانك ")
        }else{
            if(  self.selectedCityIds.count > 0){
                ServiceManager.requestService(main_category: categoryId ?? "", sub_category: selectedServiceId, descrption: self.descriptionTxt.text ?? "" , map_lat: self.lat, map_lng: self.lang, address : "" ,member_id: userId!, service_day:  self.selectedDayString ?? "" , service_time: self.selectedTimeString ?? "", image: selectedImage , countryId: "6" , cityId: self.selectedCityIds[0] ,   downloadCompeted: { (res) in
                    print("*********************************")
                    
                    NotificationCenter.default.post(name: Notification.Name.changeTabBar, object: nil, userInfo: nil);
                    
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
//                    // var requestId = ServiceManager.userDef.string(forKey: "request_id")!;
//                    //vc.reqId =  requestId ?? "0";
//                    self.navigationController?.pushViewController(vc, animated: true)
//
                })
            }
            else{
                Utils.showToast(message: "اخترالمدينة من فضلك")
            }
        }
    }
    
    func requestProduct() {
        var params =  [String: Any]();
        if(self.selectedCityIds.count > 0){
            
            params = [
                "store_id": 0,
                "product_id": 0,
                "member_id": userId!,
                "address": "",
                "map_lat": self.lat,
                "map_lng": self.lang,
                "service_day": "",
                "service_time": "",
                "quntity": "",
                "total_price":"",
                "countryid" :  "6",
                "cityid" : self.selectedCityIds[0]
            ]
        }
        
        
        
        StoreManager.requestProduct(params: params) { res in
            print("product request successfull")
            DispatchQueue.main.async() {
                self.dismiss(animated: true, completion: nil)
                //            let vc = UIStoryboard(name: "Service", bundle: nil).instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
                //            self.navigationController?.pushViewController(vc, animated: true)
                let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
                vc.navTitle = NSLocalizedString("menu.waitedOrder", comment: "")
                vc.filter = RequestFilter.waited;
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        self.requestService()
    }
    
    // Get service sub categories and open picker when
    // the sub cats are fetched
    func getServiceTypes() {
        ServiceManager.getServiceCategories(id: categoryId, downloadCompeted: { (subCats) in
            print("sub cats", subCats)
            self.serviceTypes = subCats
            var serviceTypeNames = [String]()
            for type in subCats {
                serviceTypeNames.append(type.name)
                self.serviceTypeNames = serviceTypeNames
            }
            self.tableView.reloadData()
        })
    }
    
    // Open service types select
    @objc func openServiceTypesSelect(_ gesture:UIGestureRecognizer) {
        print("open service types select")
        var title = NSLocalizedString("actionsheet.selectservicetype", comment: "")
        var  myPickerView = UIPickerView(frame:CGRect(x: 0, y: 300, width: self.view.frame.size.width, height: 216))
        myPickerView.delegate = self
        myPickerView.dataSource = self
        //myPickerView.backgroundColor = UIColor.black
        myPickerView.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        self.selectServiceType.inputView = myPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RequestVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(RequestVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.selectServiceType.inputAccessoryView = toolBar
        
        //view.addSubview(myPickerView)
        ActionSheetStringPicker.show(withTitle: title, rows: self.serviceTypeNames, initialSelection: 0, doneBlock: { (picker, index, value) in
            let selectedType = self.serviceTypes[index]
            self.selectServiceType.text = selectedType.name
            self.selectedServiceId = selectedType.id
            
        }, cancel: { (picker) in
            
        }, origin: selectServiceType)
    }
    
    // Form Validation
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            print("error", error)
            if let field = field as? UITextField {
                //field.errorFont = UIFont(name: "Avenir", size: 10)
                //field.setError(FormError.required, animated: true)
            }
        }
    }
   
    func getCountries() {
        ServiceManager.getServiceCountries(id: nil) { (categories) in
            if (categories != nil) {
                var categoryNames = [String]()
                self.categories = categories!
                print("categories\(self.categories)")
                
                for category in categories! {
                    if self.currentLanguage == "en-US" {
                        categoryNames.append(category.englishName)
                    } else {
                        categoryNames.append(category.name)
                    }
                    
                    self.categoryNames = categoryNames
                }
            }
            
        }
    }
    
    
    @objc func onSelectCity(_ gesture:UITapGestureRecognizer) {
        
        showCityBasedCountryInAlert();
    }
    
    
    func showCityBasedCountryInAlert(){
        self.selectedCityIds = [];
        let contentViewController = CityViewController()
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert);
        // height constraint
        let constraintHeight = NSLayoutConstraint(
            item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 500)
        alertController.view.addConstraint(constraintHeight)
        
        // width constraint
        let constraintWidth = NSLayoutConstraint(
            item: alertController.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(constraintWidth)
        
        let okAction = UIAlertAction(title:  NSLocalizedString("alert.ok", comment: ""), style: .default, handler: {
            action in
            self.selectedSubCategoriesList = contentViewController.selectedCityArr;
            for item in self.selectedSubCategoriesList  {
                self.selectedCityIds.append(item.id)
            }
            
            if(self.selectedSubCategoriesList.count > 0){
                if self.currentLanguage == "en-US" {
                    self.cityEdt.text = self.selectedSubCategoriesList[0].englishName
                } else {
                    self.cityEdt.text = self.selectedSubCategoriesList[0].name
                }
                
            }
        })
        alertController.addAction(okAction)
        
        contentViewController.preferredContentSize = contentViewController.view.bounds.size
        alertController.setValue(contentViewController, forKey: "contentViewController")
        
        contentViewController.CityArr = self.subCategories;
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func getCitiesBasedCountryId() {
        self.subCategories = [];
        
        SVProgressHUD.show();
        var url = Constants.CITY_BASED_COUNTRY_ENDPOINT ;
        print(url);
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response.request as Any)  // original URL request
                    print(response.response as Any) // URL response
                    //print(response.result.value as? NSDictionary)
                    if(response.result.value != nil){
                        var json =  (response.result.value as! NSDictionary)
                        var status = json ["result"]
                        print(status)
                        var  dataArr =  json["data"]as? [NSDictionary]
                        if(dataArr != nil){
                            for category in dataArr! {
                                print(category)
                                self.subCategories.append(Category(id: category["id"] as! String!, name: (category["name_ar"] as! String!) ?? "", englishName: category["name_en"] as! String! ?? ""))
                            }
                        }
                        var subCategoryNames = [String]()
                        for category in self.subCategories{
                            if self.currentLanguage == "en-US" {
                                self.subCategoryNames.append(category.englishName)
                                
                            } else {
                                self.subCategoryNames.append(category.name)
                                
                            }
                            self.subCategoryNames = subCategoryNames;
                        }
                    }
                case .failure(let error):
                    print(error)
                    
                }
                
                SVProgressHUD.dismiss();
                //self.tableView.reloadData();
        }
        
    }

    @IBOutlet weak var mapIcon: UIImageView!
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        var addressString : String = ""
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if(placemarks != nil){
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country!
                        }
                        self.address.text = addressString;
                        print(addressString);
                    }
                }
        })
        return addressString;
        
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serviceTypeNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return serviceTypeNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = serviceTypeNames[row]
        
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //  self.txt_pickUpData.text = serviceTypeNames[row]
        
        let selectedType = self.serviceTypes[row]
        self.selectServiceType.text = selectedType.name
        self.selectedServiceId = selectedType.id
        //self.selectServiceType.setError(nil, animated: false)
    }
    
    @objc func doneClick() {
        selectServiceType.resignFirstResponder()
    }
    @objc func cancelClick() {
        selectServiceType.resignFirstResponder()
    }
    
    
}
