//
//  Constants.swift
//  DMCalc-Swift
//
//  Created by Timothy Tong on 2014-07-19.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//
import UIKit
class Constants{
    class func IS_IPHONE5()->Bool{
        if(UIScreen.mainScreen().bounds.size.height-568 == 0){
            return true
        }
        return false
    }
    class func IS_IPAD() -> Bool{
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            return true
        }
        return false
    }
    class func APP_DEFAULT_FONT_FACE()->String{
        return "HelveticaNeue-Thin"
    }
    class func APP_DEFAULT_FONT_FACE_THIN()->String{
        return "HelveticaNeue-UltraLight"
    }
    class func APP_VERSION()->String{
        return "1.0"
    }
    class func MAIN_COLOR()->UIColor{
        return UIColor.blackColor()
    }
    class func SECONDARY_COLOR()->UIColor{
        return UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1)
    }
    class func FONT_COLOR()->UIColor{
        return UIColor.whiteColor()
    }
}