//
//  menu.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import Foundation
class Menu {
    var _id: String
    var _name: String
    var _icon: String
    var _vc: String
    var _storyBoard: String
    var _showLoggedIn: Bool
    
    var id: String {
        return _id
    }

    var icon: String {
        return _icon
    }
    
    var showLoggedIn: Bool {
        return _showLoggedIn
    }
    
    var storyBoard: String {
        return _storyBoard
    }
    
    
    var name: String {
        return _name
    }
    
    var vc: String {
        return _vc
    }
    
    init(id: String, name: String, icon: String, vc: String, storyboard: String, showLoggedIn: Bool) {
        _id = id
        _name = name
        _icon = icon
        _vc = vc
        _storyBoard = storyboard
        _showLoggedIn = showLoggedIn
    }
}
