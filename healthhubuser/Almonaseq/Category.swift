//
//  category.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/14/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class Category {
    private var _id: String!
    private var _name: String!
    private var _englishName: String!
    private var _image: String!
    
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
    
    var image: String {
        if _image == nil {
            _image = ""
        }
        return _image
    }
    
    init(id: String, name: String, englishName: String) {
        _id = id
        _name = name
        _englishName = englishName
    }
    
    init(id: String, name: String, image: String) {
        _id = id
        _name = name
        _image = image
    }
    
    init(id: String, name: String, englishName: String, image: String) {
        _id = id
        _name = name
        _englishName = englishName
        _image = image
    }
}
