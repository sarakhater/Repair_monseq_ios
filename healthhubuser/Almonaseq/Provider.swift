//
//  provider.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/14/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class Provider {
    var _id: String!
    var _name: String!
    var _englishName: String!
    var _status: Bool!
    var _price: Float!
    var _imageUrl: String!
    var _rating: Float!
    var _phone: String!
    var _otherPhone: String!
    var _email: String!
    var _city: String!
    var _nationality: String!
    var _experience: String!
    var _providerDescription: String!
    var _comments: Int!
    var _dailyPrice: String!
    var _hourlyPrice: String!
    var _address: String!
    var _lat: Double!
    var _long: Double!
    
    
    var lat: Double {
        if _lat == nil {
            return 0.0
        }
        return _lat
    }
    
    var long: Double {
        if _long == nil {
            return 0.0
        }
        return _long
    }

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
    
    
    var address: String {
        if _address == nil {
            return ""
        }
        return _address
    }
    
    var englishName: String {
        if _englishName == nil {
            return ""
        }
        return _englishName
    }
    
    var phone: String {
        if _phone == nil {
            return ""
        }
        return _phone
    }
    
    var otherPhone: String {
        if _otherPhone == nil {
            return ""
        }
        return _otherPhone
    }
    
    var email: String {
        if _email == nil {
            return ""
        }
        return _email
    }
    
    
    var city: String {
        if _city == nil {
            return ""
        }
        return _city
    }
    
    var experience: String {
        if _experience == nil {
            return ""
        }
        return _experience
    }
    
    var status: Bool {
        if _status == nil {
            return false
        }
        return _status
    }
    
    var price: Float {
        if _price == nil {
            return 0
        }
        return _price
    }
    
    var dailyPrice: String {
        if _dailyPrice == nil {
            return ""
        }
        return _dailyPrice
    }
    
    var hourlyPrice: String {
        if _hourlyPrice == nil {
            return ""
        }
        return _hourlyPrice
    }
    
    var imageUrl: String {
        if _imageUrl == nil {
            return ""
        }
        return _imageUrl
    }
    
    var rating: Float {
        if _rating == nil {
            return 0
        }
        return _rating
    }
    
    
    
    var nationality: String {
        if _nationality == nil {
            return "";
        }
        return _nationality
    }
    
    var providerDescription: String {
        if _providerDescription == nil {
            return ""
        }
        return _providerDescription
    }
    var comments: Int {
        if _comments == nil {
            return 0
        }
        return _comments
    }
    
    init(id: String, name: String, englishName: String, status: Bool, price: Float, imageUrl: String, rating: Float , nationality : String) {
        _id = id
        _name = name
        _englishName = englishName
        _status = status
        _price = price
        _imageUrl = imageUrl
        _rating = rating
         _nationality = nationality
    }
    
    init(id: String, name: String, phone: String, otherPhone:String, email: String, city: String, rating: Float   , nationality : String) {
        _id = id
        _name = name
        _englishName = name
        _rating = rating
        _phone = phone
        _email = email
        _address = city
        _otherPhone = otherPhone
        _nationality = nationality

    }
    
    init(id: String, name: String, englishName: String, status: Bool, price: Float, imageUrl: String, rating: Float, providerDescription:String, comments: Int ,  nationality : String) {
        _id = id
        _name = name
        _englishName = englishName
        _status = status
        _price = price
        _imageUrl = imageUrl
        _rating = rating
        _providerDescription = providerDescription
        _comments = comments;
        _nationality = nationality

    }
    
    
    init(id: String, name: String, imageUrl: String, rating: Float, experience: String, nationality: String, phone: String, otherPhone: String, city: String, email: String, dailyPrice: String, hourlyPrice: String ,lat: Double , long: Double ) {
        _id = id
        _name = name
        _dailyPrice = dailyPrice
        _hourlyPrice = hourlyPrice
        _email = email
        _nationality = nationality
        _address = city
        _imageUrl = imageUrl
        _rating = rating
        _experience = experience
        _phone = phone
        _otherPhone = otherPhone
        _lat = lat;
        _long = long;

    }
    
    
    
}
