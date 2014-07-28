//
//  GCDCalc.swift
//  DMCalc 2
//
//  Created by Timothy Tong on 2014-07-22.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit

class GCDCalc: NSObject {
    var quotients = NSMutableArray()
    func calculateGCD(x:Int, y:Int) -> Int
    {
        var a:Int = abs(x)
        var b:Int = abs(y)
        if(a == 0 && b == 0){
            return -1
        }
        if(a == 0 || b == 0){
            return 0
        }
        if(x == y){
            return abs(x)
        }
        else if (x > y) {
            a = x
            b = y
        }
        else{
            a = y
            b = x
        }
        var r = 1
        var q:Int
        while(r != 0){
            q = a / b
            self.quotients.addObject(q)
            r = a % b
            a = b
            b = r
        }
        return a
    }
    
    func getQuotients()->NSMutableArray
    {
        return self.quotients;
    }
}
