//
//  config.swift
//  Almonaseq
//
//  Created by Nada El Hakim on 11/17/17.
//  Copyright © 2017 Nada El Hakim. All rights reserved.
//

import UIKit
import SwiftyJSON

var ShareAndroidLink = "";
var ShareIphoneLink = "";

// App colors
//80,37,105 DarkPurble
let primaryColor = UIColor(red:65.0/255.0, green:46/255.0, blue:170/255.0, alpha:1.0);
//baby purple

//160,125,181
let secondaryColor = UIColor(red:65.0/255.0, green:46/255.0, blue:170/255.0, alpha:1.0);

let gradientColor1: CGColor = secondaryColor.cgColor;
let gradientColor2: CGColor = primaryColor.cgColor;



typealias OnSuccess = (_: JSON) -> ()
typealias DownloadComplete<T> = (_: T) -> ()
typealias Failure<T> = (_: T) -> ()

public enum FormError: Error {
    case required
    case match
}

extension FormError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .required:
            return NSLocalizedString("formErrors.required", comment: "");
        case .match:
            return NSLocalizedString("formErrors.match", comment: "");
        }
    }
}

class Constants {
    // Web services
    
    //rgb(160,125,181)
    static let babyPurble = UIColor(red:160.0/255.0, green:125/255.0, blue:181/255.0, alpha:1.0);
    
    
    //Purple
    static let MainColor = UIColor(red:65.0/255.0, green:46/255.0, blue:170/255.0, alpha:1.0);
    
    //torkoaz
    static let SencondColor = UIColor(red:253.0/255.0, green:58.0/255.0, blue:105.0/255.0, alpha:1.0);
    
    static let BORDER_COLOR = Constants.SencondColor.cgColor;
    
    static let COUNTRY_ENDPOINT: String = API_ENDPOINT + "countries";
    static let ShowPayment : String = API_ENDPOINT + "show_payment";
    static let CITY_BASED_COUNTRY_ENDPOINT: String = API_ENDPOINT + "cites/6";
    static let API_ENDPOINT = "https://masae-sa.com/app/mobile3/";
    static let APP_LINK = "https://masae-sa.com/app/";
    
    
    
    static let Grey_BORDER_COLOR = UIColor.init(red:128/255, green:128/255 , blue: 128/255 , alpha: 1.0).cgColor;
    
    static let CATEGORIES_URL: String = API_ENDPOINT + "usercats/";
    static let REGISTER_FAMILY_ENDPOINT: String = API_ENDPOINT + "user_register/";
    static let REGISTER_SCHOOL_ENDPOINT: String = API_ENDPOINT + "school_register/";
    
    static let LOGIN_ENDPOINT: String = API_ENDPOINT + "login/";
    static let ACTIVATE_ENDPOINT: String = API_ENDPOINT + "active_user_code/";
    static let RESEND_CODE_ENDPOINT: String = API_ENDPOINT + "resend_user_code/";
    static let STORE_ENDPOINT: String = API_ENDPOINT + "stors/";
    static let STORE_PRODUCTS_ENDPOINT: String = API_ENDPOINT + "stors_products/";
    static let GETSUBCATEGORIES_URL: String = API_ENDPOINT + "cats/";
    
    static let REQUEST_SERVICE_ENDPOINT: String = APP_LINK + "service_request3.php";
    
      static let REQUEST_CONDITION_SERVICE_ENDPOINT: String = API_ENDPOINT + "school_request";
    static let REQUEST_PRODUCT_ENDPOINT: String = API_ENDPOINT + "product_request/";
    static let GET_PROFILE_ENDPOINT: String = API_ENDPOINT + "user_profile/";
    static let EDIT_PROFILE_ENDPOINT: String = API_ENDPOINT + "edit_user/";
    static let ACCEPTED_REQUESTS: String = API_ENDPOINT + "all_tech_accepted/";
    static let USER_ACCEPT_REQUEST: String = API_ENDPOINT + "user_accept/";
    static let PAGE_ENDPOINT: String = API_ENDPOINT + "page/";
    static let UpadateApp_Endpoint = API_ENDPOINT + "must_update_user/"
    static let USER_REQUESTS_ENDPOINT: String = API_ENDPOINT + "my_requests/";
    static let RATE_TECH_ENDPOINT: String = API_ENDPOINT + "user_rate/";
    static let RESET_PASSWORD: String = API_ENDPOINT + "forgot_pass_user/";
    
    static let Share_URL : String = API_ENDPOINT + "shar_user";
    
    static let  DeleteUserReq_URL = API_ENDPOINT + "delete_user_req/";
    static let  CancelTech_URL = API_ENDPOINT + "cancel_tec/";
    static let checkUpdateURL = API_ENDPOINT + "must_update_user";
    
    static let WAITING_REQUESTS_ENDPOINT: String = API_ENDPOINT + "my_requests_wating/";
    static let PENDING_REQUESTS_ENDPOINT: String = API_ENDPOINT + "my_requests_underpross/"
    static let COMPLETED_REQUESTS_ENDPOINT: String = API_ENDPOINT + "my_requests_completed/"
    static let CANCELED_REQUESTS_ENDPOINT: String = API_ENDPOINT + "my_requests_canceled/"
    //static let BORDER_COLOR =  UIColor.init(red: 38.0/255.0, green: 131.0/255.0, blue: 77.0/255.0, alpha: 1.0).cgColor;
    static let regularFont = "JannaLT-Regular";
    static let boldFont = "JannaLT-Bold";
    
    static let ImageSlider =  API_ENDPOINT +  "slide_images";
    static let IntialPages =  API_ENDPOINT +  "static_pages";
    
    //Repair API//
    
    static let   SchoolRegisterURL = "school_register"
    static let   UserRegisterURL = "user_register"
    static let   PagerPagesURL = "static_pages"
    static let   SchoolRequestURL = "school_request"
    static let   GetAirBrandsURL = "air_brands"
    static let GETPriceListURL =  API_ENDPOINT + "price_list"
    
}

enum RequestFilter {
    case waited
    case underProcessing
    case completed
    case canceled
}
