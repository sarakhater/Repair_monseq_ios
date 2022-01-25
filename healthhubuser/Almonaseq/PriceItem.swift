//
//  PriceItem.swift
//  Almonaseq
//
//  Created by unitlabs on 1/29/21.
//  Copyright © 2021 Sara Khater. All rights reserved.
//

import Foundation

class categoryPriceItem{
    private var _id: String!
    private var _name: String!
    private var _englishName: String!
    private var _price: [PriceItem]
    var id: String {
              if  _id == nil {
                  _id = ""
              }
              return _id
          }
          
          
          var name: String {
              if  _name == nil {
                  _name = ""
              }
              return _name
          }
          
         
          
          var englishName: String {
              if  _englishName == nil {
                  _englishName = ""
              }
              return _englishName
          }
          
          var price: [PriceItem] {
              return _price
          }
          
          
          init(id: String, name: String, englishName: String, price: [PriceItem]) {
              _id = id
              _name = name
              _englishName = englishName
              _price = price
              
          }
}

class PriceItem {
    
     private var _id: String!
       private var _name: String!
       private var _englishName: String!
       private var _price: String!

       
       var id: String {
           if  _id == nil {
               _id = ""
           }
           return _id
       }
       
       
       var name: String {
           if  _name == nil {
               _name = ""
           }
           return _name
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
       
       
       init(id: String, name: String, englishName: String, price: String) {
           _id = id
           _name = name
           _englishName = englishName
           _price = price
           
       }
}
