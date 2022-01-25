//
//  StoreManager.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class StoreManager: ApiManager {
   
    static func getAllStores(downloadCompeted: @escaping DownloadComplete<[Store]>) {
        get(url: Constants.STORE_ENDPOINT) { (res) in
            print(res)
            var stores = [Store]()
            guard let data = res["data"].array else {
                return
            }
   
            for store in data {
                stores.append(Store(id: store["id"].string ?? "", name: store["name"].string ?? "", englishName: store["name"].string ?? "", address: store["address"].string ?? "", image: store["image"].string ?? ""))
            }
            downloadCompeted(stores)
        }
    }
    
    static func getStoreProducts(id: String, downloadCompeted: @escaping DownloadComplete<[Product]>) {
        get(url: Constants.STORE_PRODUCTS_ENDPOINT + id) { res in
            print(res)
            var products = [Product]()
            guard let data = res["data"].array else {
                return
            }
            
            for store in data {
                print(store)
                products.append(Product(id: store["id"].string ?? "", name: store["name_ar"].string ?? "", englishName: store["name_en"].string ?? "", price: store["price"].string ?? "", image: store["image"].string ?? "" , storeNameAr: store["stor_name_ar"].string ?? "", storeNameEn: store["stor_name_en"].string ?? "", descAr: store["desc_ar"].string ?? "", descEn: store["desc_en"].string ?? ""))
              
              
            }
            downloadCompeted(products)
        }
    }
    
    static func requestProduct(params: [String: Any], downloadCompleted: @escaping DownloadComplete<Any?>) {
        print("params: \(params)")
        get(url: Constants.REQUEST_PRODUCT_ENDPOINT, method: .post, params: params) { res in
            print(res)
            guard let result = res.dictionary else {
                return
            }
            
            if result["status"] == "true" {
                print("order sent successfully")
                guard let msg = result["msg"]?.string else {
                    return
                }
                Utils.showToast(message: msg)
                downloadCompleted(nil)
            } else {
                
            }
        }
    }
}
