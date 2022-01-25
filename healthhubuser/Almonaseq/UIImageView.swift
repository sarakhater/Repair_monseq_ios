//
//  UIImageView.swift
//  Almonaseq
//
//  Created by unitlabs on 12/11/19.
//  Copyright © 2019 Sara Khater. All rights reserved.
//

import UIKit
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
extension UIImageView
{
    func setMainColoredImage(name:String)  {
        
        self.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = Constants.MainColor
    }
    func setColoredImage(name:String , colorName : UIColor)  {
        
        self.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = colorName;
    }
}


extension UIButton
{
    func setMainColoredButton(name:String)  {
        
        self.imageView?.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = Constants.MainColor
    }
    
    var substituteFontName : String {
           
           get { return self.titleLabel?.font!.fontName ?? "" }
           set { self.titleLabel?.font = UIFont(name: newValue, size: ((self.titleLabel?.font.pointSize)!))! }
        }
}

extension UILabel{
    func setRegularFont(){
        self.font = UIFont(name: "Janna-LT-Regular.ttf", size: self.font.pointSize);
        
    }
    func setBoldFont(){
         
        self.font = UIFont(name: "Janna-LT-Bold.ttf", size: self.font.pointSize);

        print(self.font.pointSize);
        print(self.font.fontName);

    }
}


extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "ameen.app")!
    }
}

extension UIFont {
class func appRegularFontWith( size:CGFloat ) -> UIFont{
    print(UIFont(name:Constants.regularFont, size: 14.0))
    return  UIFont(name: Constants.regularFont, size: size)!;

}
class func appBoldFontWith( size:CGFloat ) -> UIFont{
    return  UIFont(name: Constants.boldFont, size: size)!;
}

}

extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            
                self.font = UIFont(name: newValue, size: 14)// self.font.pointSize)
            
        }
    }
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
          
                self.font = UIFont(name: newValue, size: 14)// self.font.pointSize)
            
        }
    }
}
extension UITextField {
    var substituteFontName : String {
        get { return self.font!.fontName }
        set { self.font = UIFont(name: newValue, size: 14.0)}// (self.font?.pointSize)!) }
    }
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    
}

extension String {
    
    func validatePhoneNumber() -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.unicode, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data,
                                                        options: [.documentType : NSAttributedString.DocumentType.html],
                                                        documentAttributes: nil) else { return nil }
        
        return html
    }
    
    
    func deleteHTMLTag() -> String {
        
        do {
            let regex =  "<[^>]+>&nbsp;&nbsp;&nbsp;"
            let expr = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            var replacement = expr.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: " ");
            
            //replacement is the result
            var attrStr = try! NSAttributedString(
                data: replacement.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            replacement = attrStr.string;
            return replacement
        } catch {
            // regex was bad!
        }
        return self
        
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for _ in tags {
            mutableString = mutableString.deleteHTMLTag()
        }
        return mutableString
    }
}
