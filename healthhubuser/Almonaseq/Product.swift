//
//  Product.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/18/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class Product {
    private var _id: String!
    private var _storeId: String!
    private var _name: String!
    private var _englishName: String!
    private var _price: String!
    private var _image: String!
    private var _storeNameAR: String!
      private var _storeNameEN: String!
    private var _descAR: String!
    private var _descEN: String!
    
    var id: String {
        if  _id == nil {
            _id = ""
        }
        return _id
    }
    var storeId: String {
        get {
            if  _storeId == nil {
                _storeId = ""
            }
            return _storeId
        }
        set(newValue) {
            _storeId = newValue
        }
        
    }
    
    var name: String {
        if  _name == nil {
            _name = ""
        }
        return _name
    }
    
    var storeNameAr: String {
        if  _storeNameAR == nil {
            _storeNameAR = ""
        }
        return _storeNameAR
    }
    var storeNameEn: String {
        if  _storeNameEN == nil {
            _storeNameEN = ""
        }
        return _storeNameEN
    }
    
    var descAr: String {
        if  _descAR == nil {
            _descAR = ""
        }
        return _descAR
    }
    
    var descEn: String {
        if  _descEN == nil {
            _descEN = ""
        }
        return _descEN
    }
    var englishName: String {
        if  _englishName == nil {
            _englishName = ""
        }
        return _englishName
    }
    
    var price: String {
        if  _price == nil {
            _price = ""
        }
        return _price
    }
    
    var image: String {
        if  _image == nil {
            _image = ""
        }
        return _image
    }
    
    init(id: String, name: String, englishName: String, price: String, image: String , storeNameAr : String ,storeNameEn : String ,  descAr : String , descEn : String) {
        _id = id
        _name = name
        _englishName = englishName
        _price = price
        _image = image
        _storeNameAR = storeNameAr;
        _descAR = descAr
        _storeNameEN = storeNameEn;
        _descEN = descEn
    }
}
