//
//  Request.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 2/26/18.
//  Copyright © 2018 Nada El Hakim. All rights reserved.
//

import Foundation
class Request {
    private var _id: String!
    private var _status: Int!
    private var _userId: String!
    private var _desc: String!
    private var _serviceDay: String!
    private var _serviceTime: String!
    private var _image: String!
    private var _lat: String!
    private var _lng: String!
    private var _userName: String?
    private var _userPhone: String?
    private var _feedBack : String!
    private var _address : String!
    private var _subCat: String!
    private var _main_cat : String!;
    private var _price : String!;
    private var _files : [DownloadedFiles]!;
    private var  _round_number : String!;
    private var  _class_number : String!;
    private var  _guard_mobile : String!;
    private var  _air_type_ar : String!;
    private var  _air_type_en : String!;
    private var  _air_brand_ar : String!;
    private var  _air_brand_en : String!;
    private var _main_cat_en : String!;
    private var _cityAr : String!;
    private var _cityEN : String!;

    
    
    
    //    private var _subCat: String!
    
    var cityAr: String {
        if _cityAr == nil {
            _cityAr = ""
        }
        return _cityAr
    }
    
    var cityEN: String {
        if _cityEN == nil {
            _cityEN = ""
        }
        return _cityEN
    }
    var main_cat_en: String {
        if _main_cat_en == nil {
            _main_cat_en = ""
        }
        return _main_cat_en
    }
    
    var round_number: String {
        if _round_number == nil {
            _round_number = ""
        }
        return _round_number
    }
    
    var class_number: String {
        if  _class_number == nil {
            _class_number = ""
        }
        return _class_number
    }
    
    var guard_mobile: String {
        if  _guard_mobile == nil {
            _guard_mobile = ""
        }
        return _guard_mobile
    }
    
    var air_type_ar: String {
        if  _air_type_ar == nil {
            _round_number = ""
        }
        return _round_number
    }
    
    var air_type_en: String {
        if  _air_type_en == nil {
            _air_type_en = ""
        }
        return _air_type_en
    }
    
    var air_brand_ar: String {
        if  _air_brand_ar == nil {
            _air_brand_ar = ""
        }
        return _air_brand_ar
    }
    
    
    var air_brand_en: String {
        if  _air_brand_en == nil {
            _air_brand_en = ""
        }
        return _air_brand_en
    }
    
    var files: [DownloadedFiles] {
        if  _files == nil {
            _files = []
        }
        return _files
    }
    
    
    var id: String {
        if  _id == nil {
            _id = ""
        }
        return _id
    }
    
    var price: String {
        if  _price == nil {
            _price = ""
        }
        return _price
    }
    var address: String {
        if  _address == nil {
            _address = ""
        }
        return _address
    }
    
    var feedBack: String {
        if  _feedBack == nil {
            _feedBack =  "";
        }
        return _feedBack
    }
    
    
    var status: Int {
        if  _status == nil {
            _status = 0
        }
        return _status
    }
    
    var userId: String {
        if  _userId == nil {
            _userId = ""
        }
        return _userId
    }
    
    var desc: String {
        if  _desc == nil {
            _desc = ""
        }
        return _desc
    }
    
    var serviceDay: String {
        if  _serviceDay == nil {
            _serviceDay = ""
        }
        return _serviceDay
    }
    
    var serviceTime: String {
        if  _serviceTime == nil {
            _serviceTime = ""
        }
        return _serviceTime
    }
    
    var image: String {
        if  _image == nil {
            _image = ""
        }
        return _image
    }
    
    var lat: String {
        if  _lat == nil {
            _lat = ""
        }
        return _lat
    }
    
    var lng: String {
        if  _lng == nil {
            _lng = ""
        }
        return _lng
    }
    
    var userName: String {
        if  _userName == nil {
            _userName = ""
        }
        return _userName ?? "";
    }
    
    var userPhone: String {
        if  _userPhone == nil {
            _userPhone = ""
        }
        return _userPhone ?? "";
    }
    
    var main_cat: String {
        if  _main_cat == nil {
            _main_cat = ""
        }
        return _main_cat
    }
    
    var subCat: String {
        if  _subCat == nil {
            _subCat = ""
        }
        return _subCat
    }
    
    //    var subCat: String {
    //        if  _subCat == nil {
    //            _subCat = ""
    //        }
    //        return _subCat
    //    }
    
    init(id:String ,  userId: String, desc: String , serviceTime: String , status: Int , class_number : String ,  round_number : String , feed_back : String , guard_mobile : String , main_cat : String ,main_cat_en : String  , air_brand_en : String , air_brand_ar : String ,price: String , air_type_ar  :String ,  air_type_en : String ,tec_phone : String , tec_name : String  ,  cityAr : String , cityEn : String , serviceDay  : String) {
        _id = id
        _userId  = userId
        _desc = desc
        _serviceTime = serviceTime
        _status = status
        _class_number = class_number
        _round_number = round_number
        _feedBack  = feed_back;
        _guard_mobile = guard_mobile
        _main_cat = main_cat;
        _main_cat_en = main_cat_en
        _air_brand_en = air_brand_en
        _air_brand_ar = air_brand_ar
        _price = price;
        _air_type_ar = air_type_ar
        _air_type_en = air_type_en
        _userName =  tec_name
        _userPhone =  tec_phone
        _cityAr = cityAr;
        _cityEN = cityEn;
        _serviceDay = serviceDay

        
        
    }
    
    init(id: String, userId: String, desc: String, serviceDay: String, serviceTime: String, status: Int, image: String, lat: String, lng: String, userName: String, userPhone: String , feed_back : String , address: String, main_cat : String , subCat : String , price: String , files : [DownloadedFiles]  , cityAr : String , cityEn : String) {
        _id = id
        _userId  = userId
        _desc = desc
        _serviceDay = serviceDay
        _serviceTime = serviceTime
        _status = status
        _image = image
        _lat = lat
        _lng = lng
        _userName = userName
        _userPhone = userPhone
        _feedBack  = feed_back;
        _address = address;
        _main_cat = main_cat;
        _subCat = subCat
        _price = price;
        _files = files;
        _cityAr = cityAr;
        _cityEN = cityEn;
    }
}

class DownloadedFiles {
    var _image : String!;
    
    var image: String {
        if  _image == nil {
            _image = ""
        }
        return _image
    }
    
    init(image : String) {
        self._image = image;
    }
    
    
}
