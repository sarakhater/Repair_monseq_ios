//
//  ApiManager.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/9/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Toaster
import KVSpinnerView


class ApiManager {
    
    
    static func get(url: String, method: HTTPMethod = .get, params: [String: Any] = [:], showHUD: Bool = true, onSuccess: @escaping OnSuccess) {
        print(url)
        
        if (showHUD) {
            KVSpinnerView.show()
        }
        
        Alamofire.request(
            url,
            method: method,
            parameters: params,
            headers: [:]).validate().responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    onSuccess(JSON(value))
//                                    print(JSON(value))
                case .failure(let error):
                    print("error")
                    debugPrint("error")
                    print(error)
                }
                if (showHUD) {
                    KVSpinnerView.dismiss()
                }
        }
    }
    
    static func getPage(pageId: String, downloadCompleted: @escaping DownloadComplete<[String: JSON]?>) {
        let url = Constants.PAGE_ENDPOINT + pageId
        get(url: url) { (res) in
            print(res)

            guard let status = res["status"].string else {
                return
            }
            switch (status) {
            case "true":
                guard let data = res["data"].array else {
                    return
                }
                downloadCompleted(data[0].dictionaryValue)
            default:
                print("no data")
            }
        }
    }
    
    static func updateApp(version : Int, downloadCompleted: @escaping DownloadComplete<String?>) {
        
        let url = Constants.UpadateApp_Endpoint + "\(version)" + "/2"
        get(url: url) { (res) in
            print(res)

            guard let status = res["status"].string else {
                return
            }
                downloadCompleted(status)
           
        }
    }
    
    
}

