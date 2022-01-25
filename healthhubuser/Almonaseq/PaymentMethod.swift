//
//  PaymentMethod.swift
//  Almonaseq
//
//  Created by unitlabs on 4/9/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import Foundation


class  PaymentMethod {
    
    var methodName_Ar : String!;
    var methodName_En : String!;
    var methodId : Int!;
    
    
    init() {
        
    }
    
    init( _methodId : Int , _methodName_Ar : String , _methodName_En : String ) {
        self.methodId = _methodId;
        self.methodName_Ar = _methodName_Ar;
        self.methodName_En = _methodName_En;
    }
    
    
    
    
    
    
}
