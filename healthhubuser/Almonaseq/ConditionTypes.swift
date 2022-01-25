//
//  ConditionTypes.swift
//  Almonaseq
//
//  Created by unitlabs on 2/5/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class ConditionTypes: Mappable {
    var status : String = "";
    var data : [model] = [];
    
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"];
        data  <- map["data"];
    }
}
class model  : Mappable{
    
    var id: String = "";
    var name_ar: String = "";
    var name_en: String = "";
    
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        id  <- map["id"];
        name_ar  <- map["name_ar"];
        name_en  <- map["name_en"];
        
    }
    
    
    
}




