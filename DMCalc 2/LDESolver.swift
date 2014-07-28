//
//  LDESolver.swift
//  DMCalc 2
//
//  Created by Timothy Tong on 2014-07-23.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit

class LDESolver: NSObject {
    var gcd:Int?
    func solveLDE(x:Int, y:Int, z:Int)->NSArray  //REMEMBER TO UNWRAP CONSTANT
    {
        var results:NSArray?
        let gcdCalc:GCDCalc = GCDCalc()
        self.gcd = gcdCalc.calculateGCD(x, y:y)
        if(z % gcd! != 0){
            return results!
        }
        else{
            var quotients:NSArray = NSMutableArray(array: gcdCalc.getQuotients())
            var multiplier:Int = z / self.gcd!
            if (quotients == nil) {
                return results!
            }
            else{
                if(x > y){
                    var xCo1 = 0
                    var yCo1 = 1
                    var xCo3 = 1
                    var yCo3 = -1 * quotients.objectAtIndex(0).integerValue
                    var xCo2:Int?
                    var yCo2:Int?
                    if (quotients.count == 1) {
                        return NSArray(objects: 0, z/y)
                    }
                    else{
                        for(var i = 1; i < quotients.count-1; i++){
                            xCo2 = xCo3
                            yCo2 = yCo3
                            xCo3 *= -quotients.objectAtIndex(i).integerValue
                            xCo3 += xCo1
                            yCo3 *= -quotients.objectAtIndex(i).integerValue
                            yCo3 += yCo1
                            xCo1 = xCo2!
                            yCo1 = yCo2!
                            
                        }
                        return NSArray(objects: xCo3 * multiplier, yCo3 * multiplier)
                    }
                }
                else if (x < y){
                    var xCo1 = 1
                    var yCo1 = 0
                    var xCo3 = -1 * quotients.objectAtIndex(0).integerValue
                    var yCo3 = 1
                    var xCo2:Int?
                    var yCo2:Int?
                    if (quotients.count == 1) {
                        return NSArray(objects: z/x, 0)
                    }
                    else{
                        for (var i = 1; i < quotients.count - 1; i++) {
                            xCo2 = xCo3
                            yCo2 = yCo3
                            xCo3 *= -quotients.objectAtIndex(i).integerValue
                            xCo3 += xCo1
                            yCo3 *= -quotients.objectAtIndex(i).integerValue
                            yCo3 += yCo1
                            xCo1 = xCo2!
                            yCo1 = yCo2!
                        }
                        return NSArray(objects: xCo3 * multiplier, yCo3 * multiplier)
                    }
                }
                else{
                    return results!
                }
            }
        }
    }
    
    func getGCD()->Int
    {
        return self.gcd!
    }
    
}
