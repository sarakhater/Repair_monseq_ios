//
//  NotificationModel.swift
//  Almonaseq
//
//  Created by unitlabs on 9/23/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//


import Foundation
import ObjectMapper
import Alamofire
class NotificationModel: Mappable {
    
    var status : String = "";
    var msg : String = "";
    var data : [NotificationDetailsModel] = [];
    
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"];
        data  <- map["data"];
    }
}

class NotificationDetailsModel  : Mappable{
    var id: String = "";
    var created : String = "";
    var notification: String = "";
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        id  <- map["id"];
        created  <- map["created"];
        notification  <- map["notification"];
    }
}

