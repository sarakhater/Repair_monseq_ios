//
//  ChatMessages.swift
//  Almonaseq
//
//  Created by unitlabs on 1/31/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ChatMessages : Mappable{
    
    
    /*
     http://monasiq.com/mobile/show_all_msg/575/2
     
     "status": "true",
     "data": [
     {
     "id": "1",
     "sent_to_id": "87",
     "sent_to_name": "فتحي جعفر",
     "msg": "السلام عليكم ",
     "created": "2019-01-14 16:08:27"
     }
     ]
     }
     */
    
    
    var status : String = "";
    var data : [MessageModel] = [];
    
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"];
        data  <- map["data"];
    }
}

class MessageModel  : Mappable{
    var id: String = "";
    var sent_to_id: String = "";
    var sent_to_name: String = "";
    var msg: String = "";
    var created : String = "";
    var tech_id: String = "";
    var tech_name: String = "";
    var user_id: String = "";
    var user_name: String = "";
    var sent_from: String = "";
    var sent_to: String = "";
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        id  <- map["id"];
        sent_to_id  <- map["sent_to_id"];
        sent_to_name  <- map["sent_to_name"];
        msg  <- map["msg"];
        created  <- map["created"];
        tech_id  <- map["tech_id"];
        tech_name  <- map["tech_name"];
        user_id  <- map["user_id"];
        user_name  <- map["user_name"];
        sent_from  <- map["sent_from"];
        sent_to  <- map["sent_to"];
    }
    
    
    
}
