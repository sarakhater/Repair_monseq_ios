//
//  InitialPage.swift
//  Almonaseq
//
//  Created by unitlabs on 3/14/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import Foundation


import Foundation
import ObjectMapper
import Alamofire

class InitialPagerData: Mappable {
    
    var status : String = "";
    var data : [InitialPager] = [];
    
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"];
        data  <- map["data"];
    }
}

class InitialPager : Mappable {
    
    /*
     
     "id": "17",
     "title_ar": "صفحة التعليمات1",
     "title_en": "information page1",
     "content_en": "<p><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer</p>",
     "content_ar": "<p>ريم ايبسوم هو نموذج افتراضي يوضع في التصاميم لتعرض على العميل ليتصور طريقه وضع النصوص بالتصاميم سواء كانت تصاميم مطبوعه ... بروشور او فلاير على سبيل المثال ... او نماذج مواقع انترنت</p>"
     },
     
     */
    
    private var _id: String!
    private var _content_en: String!
    private var _content_ar: String!

    private var _title_ar : String!;
    private var _title_en : String!;
    
    required init?(map: Map) {
          //super.init();
          mapping(map: map);
      }
      
      
      func mapping(map: Map) {
          _id  <- map["id"];
         _title_en  <- map["title_en"];
         _title_ar  <- map["title_ar"];
        _content_en  <- map["content_en"];
        _content_ar  <- map["content_ar"];
    }
    
    
    var id: String {
        if _id == nil {
            return ""
        }
        return _id
    }
    
    
    var title_en: String {
        if _title_en == nil {
            return ""
        }
        return _title_en
    }
    
    var title_ar: String {
        if _title_ar == nil {
            return ""
        }
        return _title_ar
    }
    
    var content_ar: String {
           if _content_ar == nil {
               return ""
           }
           return _content_ar
       }
       
    var content_en: String {
           if _content_en == nil {
               return ""
           }
           return _content_en
       }
       
    
    init(id: String , title_en: String ,  title_ar : String , content_en : String , content_ar : String ) {
        _id = id;
        _title_en = title_en;
        _title_ar = title_ar;
        _content_en = content_en;
        _content_ar = content_ar
        
    }
    
}
