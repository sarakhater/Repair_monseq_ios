//
//  ImageSlider.swift
//  Almonaseq
//
//  Created by unitlabs on 3/11/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class ImageSliderData: Mappable {
    
    var status : String = "";
    var data : [ImageSlider] = [];
    
    
    required init?(map: Map) {
        //super.init();
        mapping(map: map);
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"];
        data  <- map["data"];
    }
}

class ImageSlider : Mappable {
    
    /*
     "id": "5",
     "title_ar": "مستشفى تجريبي",
     "image": "http://healthhup.com/files/af46dfff1edc434c823c39c000065024_thumb.jpg"
     
     */
    
    private var _id: String!
    private var _image: String!
    private var _title_ar : String!;
     private var _title_en: String!;
    
    required init?(map: Map) {
          //super.init();
          mapping(map: map);
      }
      
      
      func mapping(map: Map) {
          _id  <- map["id"];
         _image  <- map["image"];
         _title_ar  <- map["title_ar"];
        _title_en  <- map["title_en"];

    }
    
    
    var id: String {
        if _id == nil {
            return ""
        }
        return _id
    }
    
    
    var image: String {
        if _image == nil {
            return ""
        }
        return _image
    }
    
    var title_ar: String {
        if _title_ar == nil {
            return ""
        }
        return _title_ar
    }
    
    
      var title_en: String {
          if _title_en == nil {
              return ""
          }
          return _title_en
    }
    
    init(id: String , image: String ,  title_ar : String , title_en: String  ) {
        _id = id;
        _image = image;
        _title_ar = title_ar;
        _title_en = title_en;
    }
    
}
