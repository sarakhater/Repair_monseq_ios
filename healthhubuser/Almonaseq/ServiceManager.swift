//
//  ServiceManager.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/27/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import Alamofire
import KVSpinnerView
class ServiceManager: ApiManager {
    static  let userDef = UserDefaults.standard

    static func getServiceCategories(id: String?, downloadCompeted: @escaping DownloadComplete<[Category]>) {
        
        var url = Constants.CATEGORIES_URL
        if (id != nil) {
            url = Constants.GETSUBCATEGORIES_URL + id!
        }
        get(url: url) { (response) in
            var categories = [Category]()
            guard let status = response["status"].string else {
                return
            }
            if (status == "true") {
                if let data = response["data"].array {
                    for category in data {
                        print(category)
                        categories.append(Category(id: category["id"].string!, name: category["name_ar"].string!, englishName: category["name_en"].string!, image: category["image"].string!))
                    }
                    downloadCompeted(categories)
                }
            }
        }
    }
    
    static func getPriceList(downloadCompeted: @escaping DownloadComplete<[categoryPriceItem]?>){
         var url = Constants.GETPriceListURL;
        get(url: url) { (res) in
                       guard let status = res["status"].string else {
                           return
                       }
                       if status == "true" {
                           var categories = [categoryPriceItem]()
                           if let data = res["data"].array {
                               for category in data {
                                   print(category)
                                var pricesList : [PriceItem] = []
                                for item in category["prices"].array ?? []{
                                    print(item["id"].string!)
                                    print(item["name_ar"].string!)
                                    print(item["name_en"].string!)
                                    print(item["price"].string!)
                                    
                                    pricesList.append(PriceItem(id: item["id"].string!, name: item["name_ar"].string!, englishName: item["name_en"].string!, price: item["price"].string!))
                                    
                                }
                                categories.append(categoryPriceItem(id: category["id"].string!, name: category["name_ar"].string!, englishName: category["name_en"].string!,price: pricesList))
                               
                            }
                               downloadCompeted(categories);
                           }
                       } else {
                           downloadCompeted(nil);
                       }
        }
        
    }

       
    static func getServiceCountries(id: String?, downloadCompeted: @escaping DownloadComplete<[Category]?>) {
     var url = Constants.COUNTRY_ENDPOINT;
        
       
            get(url: url) { (res) in
                guard let status = res["result"].string else {
                    return
                }
                if status == "true" {
                    var categories = [Category]()
                    if let data = res["data"].array {
                        for category in data {
                            print(category)
                            categories.append(Category(id: category["id"].string!, name: category["name_ar"].string!, englishName: category["name_en"].string!))
                        }
                        downloadCompeted(categories);
                    }
                } else {
                    downloadCompeted(nil);
                }
                
            }
        
      
    }
    
 

    
    static func requestService(main_category: String, sub_category: String, descrption: String, map_lat: Double, map_lng: Double, address : String ,member_id: String, service_day: String, service_time: String, image: UIImage?, countryId: String , cityId : String , downloadCompeted: @escaping DownloadComplete<Any?>) {
        let request: [String: Any] = [
            "main_category": main_category,
            "sub_category": sub_category,
            "descrption": descrption,
            "map_lat": map_lat,
            "map_lng": map_lng,
            "address" : address,
            "member_id": member_id,
            "service_day": service_day,
            "service_time": service_time,
             "countryid" :  countryId,
              "city" : cityId
        ]
        print(request);
        
        if (image != nil) {
            KVSpinnerView.show()
            let headers = [
                "Content-Type": "application/json"
            ]
            let currentDate = Date().timeIntervalSince1970

            let url = try! URLRequest(url: URL(string: Constants.REQUEST_SERVICE_ENDPOINT)!, method: .post, headers: headers)
            
            let jpegImage = UIImageJPEGRepresentation(image!, 0.1)!
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(jpegImage, withName: "image", fileName: "request\(currentDate).jpg", mimeType: "image/jpeg")
              
                for (key, value) in request {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, with: url, encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        print(response)
                        downloadCompeted(true)
                        KVSpinnerView.dismiss()
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    KVSpinnerView.dismiss()
                    //print encodingError.description
                }
            })
        } else {
            get(url: Constants.REQUEST_SERVICE_ENDPOINT, method: .post, params: request) { res in
                print(res)
                guard let status = res["status"].string else {
                    return
                }
                
                if status == "true" {
                    print("order sent successfully")
                    guard let msg = res["msg"].string else {
                        return
                    }
                    Utils.showToast(message: msg)
                    let id = res["id"].int
                    userDef.set(id, forKey: "request_id")
                    downloadCompeted("")
                   
                } else {
                    
                }
            }
        }
       
    }
    
    static func getAcceptedRequests(reqId: String, downloadCompeted: @escaping DownloadComplete<[Provider]>) {
        let url = Constants.ACCEPTED_REQUESTS + reqId
        get(url: url) { (response) in
            var acceptances = [Provider]()
            guard let data = response["data"].array else {
                 downloadCompeted([])
                return
            }
            print(response)
            for acceptance in data {
                acceptances.append(Provider(id: acceptance["id"].string ?? "", name: acceptance["name"].string ?? "", imageUrl: acceptance["image"].string ?? "", rating: acceptance["rate"].float ?? 0, experience: acceptance["exprince"].string ?? "", nationality: acceptance["nationality"].string ?? "", phone: acceptance["phone"].string ?? "", otherPhone: acceptance["other_phone"].string ?? "", city: acceptance["address"].string ?? "", email: acceptance["email"].string ?? "", dailyPrice: acceptance["price_perday"].string ?? "", hourlyPrice: acceptance["price_perhour"].string ?? "" , lat: acceptance["lat"].double ?? 0.0, long: acceptance["long"].double ?? 0.0 ))
//                acceptan /// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                                                                                                                                                            ////////////////////////////////////////////////////////////////////ces.append(Provider(id: acceptance["id"].string!, name: acceptance["name"].string!, phone: acceptance["phone"].string!, otherPhone: acceptance["other_phone"].string!, email: acceptance["email"].string!, city: acceptance["city"].string!, rating: acceptance["rate"].float!))
            }
            
            downloadCompeted(acceptances);
        }
    }
    
    static func requestConditionService(round_number: String, class_number: String,  guard_mobile : String ,air_type: String, air_brand: String, desc_ar: String,  author : String ,service_day: String, service_time: String, downloadCompeted: @escaping DownloadComplete<Any?>) {
           let request: [String: Any] = [
               "main_category": 1,
               "round_number": round_number,
               "class_number": class_number,
               "guard_mobile": guard_mobile,
               "air_type": air_type,
               "air_brand" : air_brand,
               "desc-ar": desc_ar,
               "author": author,
            "service_day": service_day,
            "service_time": service_time,
            
              
           ]
           print(request);
               get(url: Constants.REQUEST_CONDITION_SERVICE_ENDPOINT, method: .post, params: request) { res in
                   print(res)
                   guard let status = res["status"].string else {
                       return
                   }
                   
                   if status == "true" {
                       print("order sent successfully")
                       guard let msg = res["msg"].string else {
                           return
                       }
                       Utils.showToast(message: msg)
                       downloadCompeted(msg)
                      
                   } else {
                       
                   }
               }
     }
          
       
}
