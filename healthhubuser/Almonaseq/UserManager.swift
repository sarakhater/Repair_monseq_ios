//
//  UserManager.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
import SwiftyJSON
class UserManager: ApiManager {
    private static let userDef = UserDefaults.standard
    private static let platform  = 0
    static func register(name: String, password: String, email: String, mobile: String ,countryid : String , cityid : String  , age : String , gender : String , downloadCompeted: @escaping DownloadComplete<[String: Any]>) {
        let user: [String : Any] = ["name": name, "password": password, "email": email, "phone": mobile, "countryid" : countryid, "cityid" : cityid , "age" : age , "gender" : gender , "registrationid": userDef.string(forKey: "fcmToken") ?? ""]
        
//        print(user)
        
        get(url: Constants.REGISTER_FAMILY_ENDPOINT, method: .post, params: user) { res in
//            print(res)
            var registered: Bool
            guard let result = res["status"].string else {
                return
            }
            
            print("result: \(res)")
            
            switch result {
            case "true":
                print("regsitration is true")
                registered = true
                guard let id = res["id"].int else {
                    return
                }
                self.userDef.set(false, forKey: "logged_in")
                print("regsitration is true \(id)")
                
//                getUserProfile(id: id, downloadComplete: { (user) in
//                })
                downloadCompeted(["registered": registered, "id": id])
                
                userDef.set(mobile, forKey: "mobile")
                userDef.set(password, forKey: "password")
                userDef.set(id, forKey: "user_id")
                userDef.set(true, forKey: "registered")                
    
            
                
            default:
                registered = false
                print("registration error")
                print(res)
//                downloadCompeted(["registered": registered, "id": 0])

                guard let msg = res["msg"].string else {
                    return
                }
                Utils.showToast(message: msg)
            }
        }
    }
    
    static func activateAccount(id: Int, code: String, downloadCompleted: @escaping DownloadComplete<Any?>) {
        let code: [String: Any] = [
            "id": id,
            "code": code
        ]
        print(code);
        get(url: Constants.ACTIVATE_ENDPOINT, method: .post, params: code) { res in
         print(res)
            guard let result = res["status"].string else {
                return
            }
            switch result {
                case "true":
                    userDef.set(true, forKey: "activated")
                    downloadCompleted(nil)

                default:
                    guard let msg = res["msg"].string else {
                        return
                    }
                    Utils.showToast(message: msg)
                    
                }
          
        }
    }
    
    static func resendCode(id: Int, downloadCompleted: @escaping DownloadComplete<Any?>) {
        get(url: Constants.RESEND_CODE_ENDPOINT, method: .post, params: ["id": id]) { res in
            print(res)
            guard let result = res["status"].string else {
                return
            }
            guard let msg = res["msg"].string else {
                return
            }
            Utils.showToast(message: msg)
            switch result {
            case "true":
                downloadCompleted(nil);
            default:
               print("false")
            }
            
        }
    }
    
    static func login(email: String, password: String, downloadCompeted: @escaping DownloadComplete<[String: Any]>) {
        let token = userDef.string(forKey: "fcmToken")!
        print("token: \(token)")
        let user: [String : Any] = [
            "phone": email,
            "password": password,
            "type" : L102Language.getRegisterType(),
            "registrationid": userDef.string(forKey: "fcmToken") ?? ""
        ]
        print(user)
        
        get(url: Constants.LOGIN_ENDPOINT, method: .post, params: user) { res in
            print("login \(res)")
            guard let result = res["status"].string else {
                return
            }
            
            switch result {
            case "true":
               print("logged in")
               guard let id = res["id"].string else {
                return
               }
               guard let type = res["type"].string else {
                return
               }
               L102Language.setRegisterType(type: Int(type) ?? 0)
               getUserProfile(id: id, downloadComplete: { (user) in
               })
               downloadCompeted(["id": id])
               self.userDef.set(true, forKey: "registered")
               self.userDef.set(true, forKey: "activated")
               self.userDef.set(true, forKey: "logged_in")
               self.userDef.set(id, forKey: "user_id")
               userDef.set(id, forKey: "user_id")

               NotificationCenter.default.post(name: .login, object: ["id": id])

            default:
                print("login error")
                guard let msg = res["msg"].string else {
                    return
                }
                Utils.showToast(message: msg)
            }
        }
    }
    
    static func logout() {
        userDef.set(false, forKey: "logged_in")
        self.userDef.removeObject(forKey: "user_id")
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    static func getUserProfile(id: String, downloadComplete: @escaping DownloadComplete<JSON>) {
        let url = Constants.GET_PROFILE_ENDPOINT + "\(id)"
        get(url: url) { (res) in
            downloadComplete(res)
            saveUserLocally(user: res)
        }
    }
    

    static func editUser(params: [String: Any], downloadComplete: @escaping DownloadComplete<String>) {
        get(url: Constants.EDIT_PROFILE_ENDPOINT, method: .post, params: params, showHUD: true) { (res) in
            guard let result = res["status"].string else {
                return
            }
            
            switch result {
            case "true":
                guard let id = res["id"].string else {
                    return
                }
                guard let msg = res["msg"].string else {
                    return
                }
                  downloadComplete(result)
                 Utils.showToast(message: msg)
//                getUserProfile(id: id, downloadComplete: { (user) in
//                   
//                })
                
            default:
                print("login error")
                guard let msg = res["msg"].string else {
                    return
                }
                Utils.showToast(message: msg);
            }
        }
    }
    
    static func acceptRequest(reqId: String, techId: String, downloadComplete: @escaping DownloadComplete<Any?>) {
        let url = Constants.USER_ACCEPT_REQUEST + techId + "/" +  reqId
        get(url: url, onSuccess: { (res) in
            print(res)
            guard let msg = res["msg"].string else {
                return
            }
            Utils.showToast(message: msg)
            downloadComplete(nil)
        })
    }
    
    static func getUserRequests(filter: RequestFilter,downloadCompleted: @escaping DownloadComplete<[Request]>) {
        let userId = userDef.string(forKey: "user_id")
        if (userId != nil) {
              var url = Constants.USER_REQUESTS_ENDPOINT + userId!
            if (filter == RequestFilter.waited) {
                url = Constants.WAITING_REQUESTS_ENDPOINT + userId!;
            }
            else if(filter == RequestFilter.underProcessing){
                url = Constants.PENDING_REQUESTS_ENDPOINT + userId!;
            } else if(filter == RequestFilter.completed){
                url = Constants.COMPLETED_REQUESTS_ENDPOINT + userId!;
            }else if(filter == RequestFilter.canceled){
                url = Constants.CANCELED_REQUESTS_ENDPOINT + userId!;
            }
          
            //url = "http://monasiq.com/mobile2/my_requests_underpross/4471";
            print("url\(url)")
            get(url: url, onSuccess: { (res) in
                print(res)
                var requests = [Request]()
                guard let status = res["status"].string else {
                    return
                }
                if (status == "true") {
                    if let data = res["data"].array {
                        //request["tec_id"].string!
                        
                        
                        for request in data {
                            var techId: String
                            if let techIdString = request["tec_id"].string {
                                techId = techIdString
                            } else {
                                techId = "0"
                            }
                            
                            var RequestFilesArray : [DownloadedFiles] = [] ;
                              if let filesArr = request["files"].array {
                                for file in filesArr{
                                    if let fileImage = file["image"].string {
                                        RequestFilesArray.append(DownloadedFiles.init(image : fileImage));
                                    } else {
                                       
                                    }
                                }
                             }
//                            var techId: String
//                            if (request["tec_id"].string!) {
//                                techId = request["tec_id"].string!
//                            } else {
//                                techId = "0"
//                            }
                            if(L102Language.getRegisterType() == 1){
                                //school
                                requests.append(Request(id: request["id"].string!, userId: techId, desc: request["descrption"].string!, serviceTime: request["service_time"].string!, status: request["status"].int!, class_number: request["class_number"].string!, round_number: request["round_number"].string!, feed_back: request["feed_back"].string!, guard_mobile: request["guard_mobile"].string!, main_cat: request["main_cat"].string ?? "", main_cat_en: request["main_cat_en"].string ?? "", air_brand_en: request["air_brand_en"].string ?? "", air_brand_ar: request["air_brand_ar"].string ?? "", price: request["price"].string ?? "", air_type_ar: request["air_type_ar"].string ?? "", air_type_en: request["air_type_en"].string ?? "" , tec_phone: request["tec_phone"].string ?? "" , tec_name:  request["tec_name"].string ?? "", cityAr: request["city_name_ar"].string ?? "",cityEn : request["city_name_en"].string ?? "" , serviceDay  :request["service_day"].string ?? "") )
                            }else{
                                
                            //family
                            requests.append(Request(id: request["id"].string!, userId: techId, desc: request["descrption"].string!, serviceDay: request["service_day"].string!, serviceTime: request["service_time"].string!, status: request["status"].int!, image: request["image"].string!, lat: request["map_lat"].string!, lng: request["map_lng"].string!, userName: request["tec_name"].string ?? "", userPhone: request["tec_phone"].string ?? "" ,feed_back: request["feed_back"].string!, address: request["address"].string!, main_cat: request["main_cat"].string ?? "", subCat: request["sub_cat"].string ?? "" , price: request["price"].string ?? "",  files : RequestFilesArray , cityAr: request["city_name_ar"].string ?? "",cityEn : request["city_name_en"].string ?? ""))
                        
                            print(RequestFilesArray)
                            }
                        }
                        downloadCompleted(requests)
                    }
                }
                else{
                    downloadCompleted([]);
                }
            })
        }
    }
    
    static func rateTech(id: String, amount: String, techId: String, rate: CGFloat, comment: String , payment_way : Int ,  downloadCompleted: @escaping DownloadComplete<Any?>) {
        let userId = userDef.string(forKey: "user_id")
        let rating: [String: Any] = [
            "id": id,
            "amount": amount,
            "user_id": userId!,
            "tech_id": techId,
            "comment": comment,
            "rate": "\(rate)",
            "payment_way" :payment_way
        ]
        
        print(rating)
        if (userId != nil) {
            let url =  Constants.RATE_TECH_ENDPOINT
            get(url: url, method: .post, params: rating, onSuccess: { (res) in
                print(res)
                guard let status = res["status"].string else {
                    return
                }
                
                guard let msg = res["msg"].string else {
                    return
                }
                
                Utils.showToast(message: msg)
                
                if (status == "true") {
                    downloadCompleted(nil)
                }
            })
        }
    }
    
    static func resetPassword(phone: String, downloadCompleted: @escaping DownloadComplete<Any?>) {
        let url =  Constants.RESET_PASSWORD + phone
        get(url: url, onSuccess: { (res) in
            print(res)
            guard let status = res["status"].string else {
                return
            }
            
            guard let msg = res["msg"].string else {
                return
            }
            
            Utils.showToast(message: msg)
            
            if (status == "true") {
                downloadCompleted(nil)
            }
        })
    }
    
    static func deleteOrder(reqId: String, reason : String , downloadCompleted: @escaping DownloadComplete<Any?>) {
        print(reason);
        let userId = userDef.string(forKey: "user_id");

        let url =  Constants.DeleteUserReq_URL + "\(reqId)" + "/" + userId! + "/"  + reason ;
        
        let urlwithPercentEscapes = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed);

        print(urlwithPercentEscapes);
        
        get(url: urlwithPercentEscapes ?? "", onSuccess: { (res) in
            print(res)
            guard let status = res["status"].string else {
                return
            }
            
            guard let msg = res["msg"].string else {
                return
            }
            
            Utils.showToast(message: msg)
            
            if (status == "true") {
                downloadCompleted(nil)
            }
        })
    }
    
    static func cancelOrderTech(reqId: String, downloadCompleted: @escaping DownloadComplete<Any?>) {
        let userId = userDef.string(forKey: "user_id")
        let url =  Constants.CancelTech_URL + "\(reqId)" + "/" + userId!;
        get(url: url, onSuccess: { (res) in
            print(res)
            guard let status = res["status"].string else {
                return
            }
            
            guard let msg = res["msg"].string else {
                return
            }
            
            Utils.showToast(message: msg)
            
            if (status == "true") {
                downloadCompleted(nil)
            }
        })
    }
    
    static func saveUserLocally(user: JSON){
        let userDictionary: [String: String] = [
            "name": user["name"].string ?? "",
            "username": user["user_name"].string ?? "",
            "image": user["image"].string ?? "",
            "phone": user["phone"].string ?? "",
            "email": user["email"].string ?? "",
            "active": user["active"].string ?? ""
        ]
        self.userDef.set(userDictionary, forKey: "user")
    }
    
    
    static func registerFamily(name: String, password: String, mobile: String ,map_lat : Double , map_lang : Double , address : String,  downloadCompeted: @escaping DownloadComplete<[String: Any]>) {
        
            let user: [String : Any] = ["name": name, "password": password, "phone": mobile, "map_lat" : map_lat, "map_lang" : map_lang , "address" : address , "platform" : platform , "registrationid": userDef.string(forKey: "fcmToken") ?? ""]
            
    //        print(user)
            
            get(url: Constants.REGISTER_FAMILY_ENDPOINT, method: .post, params: user) { res in
    //            print(res)
                var registered: Bool
                guard let result = res["status"].string else {
                    return
                }
                
                print("result: \(res)")
                
                switch result {
                case "true":
                    print("regsitration is true")
                    registered = true
                    guard let id = res["id"].int else {
                        return
                    }
                    
                     let message = res["msg"].string
                    self.userDef.set(false, forKey: "logged_in")
                    print("regsitration is true \(id)")
                    
    //                getUserProfile(id: id, downloadComplete: { (user) in
    //                })
                    downloadCompeted(["registered": registered, "id": id , "msg" : message ?? ""])
                    
                    userDef.set(mobile, forKey: "mobile")
                    userDef.set(password, forKey: "password")
                    userDef.set(id, forKey: "user_id")
                    userDef.set(true, forKey: "registered")
        
                
                    
                default:
                    registered = false
                    print("registration error")
                    print(res)
    //                downloadCompeted(["registered": registered, "id": 0])

                    guard let msg = res["msg"].string else {
                        return
                    }
                    Utils.showToast(message: msg)
                }
            }
        }
    
    static func registerSchool(managerName: String,schoolName: String, password: String, mobile: String , ministerial_number : Int , map_lat : Double , map_lang : Double , address : String,  downloadCompeted: @escaping DownloadComplete<[String: Any]>) {
          
        let user: [String : Any] = ["name": managerName, "shool_name" : schoolName, "password": password, "phone": mobile,"ministerial_number" : ministerial_number , "map_lat" : map_lat, "map_lang" : map_lang , "address" : address , "platform" : platform , "registrationid": userDef.string(forKey: "fcmToken") ?? ""]
              
      //        print(user)
              
              get(url: Constants.REGISTER_SCHOOL_ENDPOINT, method: .post, params: user) { res in
      //            print(res)
                  var registered: Bool
                  guard let result = res["status"].string else {
                      return
                  }
                  
                  print("result: \(res)")
                  
                  switch result {
                  case "true":
                      print("regsitration is true")
                      registered = true
                      guard let id = res["id"].int else {
                          return
                      }
                      let message = res["msg"].string

                      self.userDef.set(false, forKey: "logged_in")
                      print("regsitration is true \(id)")
                      
      //                getUserProfile(id: id, downloadComplete: { (user) in
      //                })
                      downloadCompeted(["registered": registered, "id": id , "msg" : message ?? ""])
                      userDef.set(mobile, forKey: "mobile")
                      userDef.set(password, forKey: "password")
                      userDef.set(id, forKey: "user_id")
                      userDef.set(true, forKey: "registered")
          
                  
                      
                  default:
                      registered = false
                      print("registration error")
                      print(res)
      //                downloadCompeted(["registered": registered, "id": 0])

                      guard let msg = res["msg"].string else {
                          return
                      }
                      Utils.showToast(message: msg)
                  }
              }
    }

}
