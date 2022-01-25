//
//  review.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/15/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class Review {
    var _id: String!
    var _date: String!
    var _username: String!
    var _reviewDetails: String!
    var _rating: Float!
    
    var id: String {
        if _id == nil {
            return ""
        }
        return _id
    }
    
    
    var date: String {
        if _date == nil {
            return ""
        }
        return _date
    }
    
    var username: String {
        if _username == nil {
            return ""
        }
        return _username
    }
    
    var reviewDetails: String {
        if _reviewDetails == nil {
            return ""
        }
        return _reviewDetails
    }
    
    var rating: Float {
        if _rating == nil {
            return 0.0
        }
        return _rating
    }
    
    init(id: String, date: String, username: String, reviewDetails: String, rating: Float) {
        _id = id
        _date = date
        _username = username
        _reviewDetails = reviewDetails
        _rating = rating
    }
}
