//  Localizer.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//
import Foundation
import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
let Register_Type_KEY = "RegisterType"

let userdef = UserDefaults.standard;

/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
          // let userdef = UserDefaults.shared ;
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        if #available(iOS 11.0, *) {
            return current.components(separatedBy: "-")[0]
        } else {
            return current
        }
        
//        return Utils.getcurrentLanguage()
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        
        //let userdef = UserDefaults.shared ;
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY);
        userdef.synchronize();
    }
    
    class func setRegisterType(type : Int){
        userdef.set(type ,forKey: Register_Type_KEY);
        userdef.synchronize();
    }
    
    class func getRegisterType()-> Int{
           return userdef.object(forKey: Register_Type_KEY) as? Int ?? 1
    }
}

extension UIApplication {
    class func isRTL() -> Bool{

        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    class func isLTR() -> Bool{

           return UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
       }
}

class L102Localizer: NSObject {
    class func DoTheMagic() {
        if L102Language.currentAppleLanguage() == "en" {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else  if L102Language.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        MethodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
        
        MethodSwizzleGivenClassName(cls: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.cstm_userInterfaceLayoutDirection))
        
                MethodSwizzleGivenClassName(cls: UITextField.self, originalSelector: #selector(UITextField.layoutSubviews), overrideSelector: #selector(UITextField.cstmlayoutSubviews))
        
                MethodSwizzleGivenClassName(cls: UILabel.self, originalSelector: #selector(UILabel.layoutSubviews), overrideSelector: #selector(UILabel.cstmlayoutSubviews))

        
    }
}

extension UILabel {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.textAlignment == .center {
            return
        }
        if self.tag <= 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}


extension UITextField {
    @objc public func cstmlayoutSubviews() {
        self.cstmlayoutSubviews()
        if self.textAlignment == .center {
            return
        }
        if self.tag <= 0 {
            if UIApplication.isRTL()  {
                if self.textAlignment == .right { return }
                self.textAlignment = .right
            } else {
                if self.textAlignment == .left { return }
                self.textAlignment = .left
            }
        }
    }
}


var numberoftimes = 0
extension UIApplication {
    @objc var cstm_userInterfaceLayoutDirection : UIUserInterfaceLayoutDirection {
        get {
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if L102Language.currentAppleLanguage() == "ar" {
                direction = .rightToLeft
            }
            else  if L102Language.currentAppleLanguage() == "en" {
                direction = .leftToRight;
            }
            return direction
        }
    }
}
extension Bundle {
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
          var bundle = Bundle();
        if let languageDirectoryPath = Bundle.main.path(forResource:  L102Language.currentAppleLanguage(), ofType: "lproj")  {
            bundle = Bundle.init(path: languageDirectoryPath)!
        } else {
            bundle = Bundle.main;
        }
        if self == Bundle.main {
            
            let currentLanguage = L102Language.currentAppleLanguage();
            print(currentLanguage);
            var bundle = Bundle();
            
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
                print(_path);
            }else
//                if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
//                    bundle = Bundle(path: _path)!
//                       print(_path);
//                } else {
            { let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                    bundle = Bundle(path: _path)!
                       print(_path);
            }
            print((bundle.specialLocalizedStringForKey(key, value: value, table: tableName)));
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName));
        } else {
            print((self.specialLocalizedStringForKey(key, value: value, table: tableName)));
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName));
        }
    }
}
func disableMethodSwizzling() {
    
}


/// Exchange the implementation of two methods of the same Class
func MethodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    let origMethod: Method = class_getInstanceMethod(cls, originalSelector)!;
    let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!;
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}
