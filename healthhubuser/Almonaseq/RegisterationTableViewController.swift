//
//  RegisterationTableViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 1/21/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import UIKit
import MapKit
import MaterialTextField
import LocationPicker
import CoreLocation
import SwiftValidator


class RegisterationTableViewController: UITableViewController , CLLocationManagerDelegate,MKMapViewDelegate {
    
    var registerType : Int = 0;
    var mapLat : Double = 0.0;
    var mapLang : Double = 0.0;
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation!

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var addressTextField: UITextField!{
        didSet{
            addressTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var minsterialNoTextField: UITextField!{
        didSet{
            minsterialNoTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var phoneNoTextField: UITextField!{
        didSet{
            phoneNoTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var schoolManagerTextField: UITextField!{
        didSet{
            schoolManagerTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!{
        didSet{
            confirmPasswordTextField.layer.cornerRadius = 15;
        }
    }
    
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        registerType = L102Language.getRegisterType()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            if(currentLoc != nil){
                mapLat = currentLoc.coordinate.latitude
                mapLang = currentLoc.coordinate.longitude
                print(currentLoc.coordinate.latitude)
                print(currentLoc.coordinate.longitude)
                setupMap()
            }
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(triggerTouchAction(sender:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        setRegisterType();
        registerBtn.layer.cornerRadius = 15;
        bigView.layer.cornerRadius = 15;
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg-2"))
        
    }
   @objc func triggerTouchAction(sender: UITapGestureRecognizer) {
        //Add alert to show it works
        let locationInView = sender.location(in: mapView)
        let tappedCoordinate = mapView.convert(locationInView , toCoordinateFrom: mapView)
         let allAnnotations = self.mapView.annotations
         self.mapView.removeAnnotations(allAnnotations)
         addAnnotation(coordinate: tappedCoordinate)
         mapLat = tappedCoordinate.latitude
         mapLang = tappedCoordinate.longitude
        print(tappedCoordinate.latitude)
         getAddressFromLatLon(lat: mapLat, long: mapLang)
         
    }
    
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    func setupMap(){
        let baseCoordinate = CLLocationCoordinate2DMake(mapLat,mapLang)

        let region = MKCoordinateRegionMakeWithDistance(baseCoordinate, 500, 500)
        mapView.region = region
    }
    
    func setRegisterType(){
        if(registerType == 1){
            //as a family
            minsterialNoTextField.isHidden = true
            schoolManagerTextField.isHidden = true
        }
        else if(registerType == 2){
            //as school
            minsterialNoTextField.isHidden = false
            schoolManagerTextField.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "My Address"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    
    @IBAction func registerSchoolPressed(_ sender: Any) {
        //validate fields
        if(registerType == 1){
            //register as family
            if(nameTextField.text!.isEmpty || addressTextField.text!.isEmpty || phoneNoTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty){
                //show message plz complete all fields
                SideMenuVC.showErrorMessage(txt: NSLocalizedString("register.completeAllFields", comment: ""),.error)
                
            }else{
                if(passwordTextField.text! != confirmPasswordTextField.text!){
                    
                    // please check password and confirm password
                    SideMenuVC.showErrorMessage(txt: NSLocalizedString("register.checkConfirmPassword", comment: ""),.error)
                    
                }else{
                    // call register api
                    UserManager.registerFamily(name: nameTextField.text ?? "", password: passwordTextField.text ?? "", mobile: phoneNoTextField.text ?? "", map_lat: mapLat ?? 0.0 , map_lang: mapLang ?? 0.0 , address: addressTextField.text ?? "") { (res) in
                        
                        guard let message = res["msg"] as? String else {
                            return
                        }
                        
                        SideMenuVC.showSuccessMessage(txt: message)
                       // Utils.showToast(message: "registration successfull")
                        let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
                        activateVC.fromMenu = false
                        self.navigationController?.pushViewController(activateVC, animated: false)
                    }
                }
            }
            
            
            
        }else if(registerType == 2){
            // register as school
            if(nameTextField.text!.isEmpty || addressTextField.text!.isEmpty || phoneNoTextField.text!.isEmpty || passwordTextField.text!.isEmpty || confirmPasswordTextField.text!.isEmpty || minsterialNoTextField.text!.isEmpty || schoolManagerTextField.text!.isEmpty){
                
                //show message plz complete all fields
                SideMenuVC.showErrorMessage(txt: NSLocalizedString("register.completeAllFields", comment: ""),.error)
                
            }
            else{
                if(passwordTextField.text! != confirmPasswordTextField.text!){
                    
                    // please check password and confirm password are same
                    SideMenuVC.showErrorMessage(txt: NSLocalizedString("register.checkConfirmPassword", comment: ""),.error)
                    
                }else{
                    //call register api
                    UserManager.registerSchool(managerName: schoolManagerTextField.text ?? "", schoolName: nameTextField.text ?? "", password: passwordTextField.text ?? "", mobile: phoneNoTextField.text ?? "", ministerial_number: Int(minsterialNoTextField.text ?? "") ?? 0 , map_lat: mapLat, map_lang: mapLang, address: addressTextField.text ?? ""){ (res) in
                        
                        guard let message = res["msg"] as? String else {
                            return
                        }
                        
                        SideMenuVC.showSuccessMessage(txt: message)
                        Utils.showToast(message: "registration successfull")
                        let activateVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ActivateCodeVC") as! ActivateCodeVC
                        activateVC.fromMenu = false
                        self.navigationController?.pushViewController(activateVC, animated: false)
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        //open login screen
        let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        loginVC.fromMenu = false
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    
    func getAddressFromLatLon(lat: Double, long: Double) -> String {
           var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
           let ceo: CLGeocoder = CLGeocoder()
           center.latitude = lat
           center.longitude = long
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
                    
                       if pm.locality != nil {
                           addressString = addressString + pm.locality! + ", "
                       }
                       if pm.country != nil {
                           addressString = addressString + pm.country!
                       }
                       self.addressTextField.text = addressString;
                       print(addressString);
                   }
                   }
           })
           return addressString;

       }
    
}


