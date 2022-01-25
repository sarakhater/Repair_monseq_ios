//
//  Store.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 12/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class Store {
    private var _id: String!
    private var _name: String!
    private var _address: String!
    private var _image: String!
    private var _englishName: String!
    
    var id: String {
        if _id == nil {
            return ""
        }
        return _id
    }
    
    var name: String {
        if _name == nil {
            return ""
        }
        return _name
    }
    
    var englishName: String {
        if _englishName == nil {
            return ""
        }
        return _englishName
    }
    var address: String {
        if _address == nil {
            return ""
        }
        return _address
    }
    
    var image: String {
        if _image == nil {
            _image = ""
        }
        return _image
    }
    
    init(id: String, name: String, englishName: String, address: String, image: String) {
        _id = id
        _name = name
        _englishName = englishName
        _address = address
        _image = image
    }
}
