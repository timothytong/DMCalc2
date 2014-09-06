//
//  ViewController.swift
//  DMCalc-Swift
//
//  Created by Timothy Tong on 2014-07-17.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit
import QuartzCore
class ViewController: UIViewController, AboutSliderDelegate, GCDCalcViewDelegate {
    enum openFunctionPage{
        case GCDPage
        case LDEPage
        case MODPage
    }
    var isAnimating = false
    var appTitleBg = UIView()
    var background = UIView()
    var gcdLabelbg = UIView()
    var ldeLabelbg = UIView()
    var modLabelbg = UIView()
    var aboutLabelbg = UIView()
    var shouldSwitchView = false
    var aboutTileIsMoving = false
    var gcdVisShown = false
    var ldeVisShown = false
    var modVisShown = false
    var labelBeingMoved:Int = 0
    var modLabel = UILabel()
    var ldeLabel = UILabel()
    var gcdLabel = UILabel()
    var aboutLabel = UILabel()
    var modLabelLong = UILabel()
    var ldeLabelLong = UILabel()
    var gcdLabelLong = UILabel()
    var abbrLabelX:CGFloat = 0.0
    var tileOriginalX:CGFloat = 0.0
    var tileCurrentX:CGFloat = 0.0
    var aboutTileY:CGFloat = 0.0
    var aboutTileX:CGFloat = 0.0
    var aboutTileCurrY:CGFloat = 0.0
    var labelHeight:CGFloat = 0.0
    var aboutSlider:AboutSlider!
    var gcdCalcView:GCDCalcView!
    var ldeSolverView:LDESolverView!
    var modSolverView:ModSolverView!
    var rect1 = UIView()
    var rect2 = UIView()
    var activeView:openFunctionPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var appTitleFontSize :CGFloat = 40.0
        var titleY:CGFloat = 80
        var appTitleHeight:CGFloat = 130
        if Constants.IS_IPAD(){
            appTitleFontSize = 60
            titleY += 120
            appTitleHeight += 20
        }
        self.view.backgroundColor = Constants.SECONDARY_COLOR()
        self.background.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.background.backgroundColor = Constants.MAIN_COLOR()
        self.background.layer.borderColor = Constants.MAIN_COLOR().CGColor
        self.background.layer.borderWidth = 0.5
        self.appTitleBg.frame = CGRectMake(self.view.frame.width, titleY, self.view.frame.width-30, appTitleHeight)
        self.appTitleBg.backgroundColor = Constants.SECONDARY_COLOR()
        let appTitle = UILabel(frame: CGRectMake(0, 0, self.view.frame.width-45, appTitleHeight))
        appTitle.text = "Discrete Math\nCalculator 2"
        appTitle.numberOfLines = 2
        appTitle.textAlignment = NSTextAlignment.Right
        appTitle.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: appTitleFontSize)
        appTitle.textColor = Constants.FONT_COLOR()
        self.appTitleBg.addSubview(appTitle)
        self.background.addSubview(self.appTitleBg)
        
        //3 Main Categories
        self.tileOriginalX = -(self.view.frame.width - 20 - (1/3) * self.view.frame.width)
        self.tileCurrentX = self.tileOriginalX
        let pullRight = UIImage(named: "pull-right-white.png")
        self.labelHeight = 40.0
        var labelFontSize:CGFloat = 20.0
        var gap:CGFloat = 30.0
        var startingY:CGFloat = self.view.frame.height/2 - 20
        if Constants.IS_IPAD(){self.labelHeight+=20;labelFontSize+=20;gap+=30}
        if !Constants.IS_IPAD() && !Constants.IS_IPHONE5(){gap-=10;startingY+=30}
        //GCD
        let pullRightView1 = UIImageView(image: pullRight)
        
        self.gcdLabelbg.frame = CGRectMake(-self.view.frame.width + 20, startingY, (self.view.frame.width - 20), self.labelHeight)
        let longLabelFrame = CGRectMake(10, 0, self.gcdLabelbg.frame.width - self.labelHeight, self.labelHeight)
        self.abbrLabelX = self.gcdLabelbg.frame.width - (1/3)*self.view.frame.width + 25
        self.gcdLabelbg.tag = 1
        self.gcdLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
        
        pullRightView1.frame = CGRectMake(self.gcdLabelbg.frame.width - self.labelHeight + 10, 0, self.labelHeight, self.labelHeight)
        self.gcdLabelbg.addSubview(pullRightView1)
        
        self.gcdLabel.frame = CGRectMake(self.abbrLabelX, 0, self.gcdLabelbg.frame.width - self.labelHeight, self.labelHeight)
        self.gcdLabel.backgroundColor = UIColor.clearColor()
        self.gcdLabel.text = "GCD"
        self.gcdLabel.textAlignment = NSTextAlignment.Left
        self.gcdLabel.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.gcdLabel.textColor = Constants.FONT_COLOR()
        self.gcdLabelbg.addSubview(gcdLabel)
        
        self.gcdLabelLong.frame = longLabelFrame
        self.gcdLabelLong.alpha = 0
        self.gcdLabelLong.backgroundColor = UIColor.clearColor()
        self.gcdLabelLong.text = "GREATEST COMMON DIVISOR"
        if !Constants.IS_IPAD(){
            self.gcdLabelLong.text = "GREATEST COMMON DIV."
        }
        self.gcdLabelLong.textAlignment = NSTextAlignment.Left
        self.gcdLabelLong.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.gcdLabelLong.textColor = Constants.FONT_COLOR()
        self.gcdLabelbg.addSubview(self.gcdLabelLong)
        
        let labelTap1 = UITapGestureRecognizer(target: self, action: "tileTapped:")
        self.gcdLabelbg.addGestureRecognizer(labelTap1)
        let labelPan1 = UIPanGestureRecognizer(target: self, action: "tilePannedRight:")
        self.gcdLabelbg.addGestureRecognizer(labelPan1)
        
        self.background.addSubview(self.gcdLabelbg)
        
        //LDE
        let pullRightView2 = UIImageView(image: pullRight)
        
        self.ldeLabelbg.frame = CGRectMake(-self.view.frame.width + 20, startingY + gap + self.labelHeight, (self.view.frame.width - 20), self.labelHeight)
        self.ldeLabelbg.tag = 2
        self.ldeLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
        
        pullRightView2.frame = CGRectMake(self.ldeLabelbg.frame.width - self.labelHeight + 10, 0, self.labelHeight, self.labelHeight)
        self.ldeLabelbg.addSubview(pullRightView2)
        
        self.ldeLabel.frame = CGRectMake(self.abbrLabelX, 0, self.ldeLabelbg.frame.width - self.labelHeight, self.labelHeight)
        self.ldeLabel.backgroundColor = UIColor.clearColor()
        self.ldeLabel.text = "LDE"
        self.ldeLabel.textAlignment = NSTextAlignment.Left
        self.ldeLabel.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.ldeLabel.textColor = Constants.FONT_COLOR()
        self.ldeLabelbg.addSubview(ldeLabel)
        
        self.ldeLabelLong.frame = longLabelFrame
        self.ldeLabelLong.alpha = 0
        self.ldeLabelLong.backgroundColor = UIColor.clearColor()
        self.ldeLabelLong.text = "LINEAR DIOPHANTINE EQUATION"
        if !Constants.IS_IPAD(){
            self.ldeLabelLong.text = "LINEAR DIOPHANTINE EQN."
        }
        self.ldeLabelLong.textAlignment = NSTextAlignment.Left
        self.ldeLabelLong.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.ldeLabelLong.textColor = Constants.FONT_COLOR()
        self.ldeLabelbg.addSubview(self.ldeLabelLong)
        
        let labelTap2 = UITapGestureRecognizer(target: self, action: "tileTapped:")
        self.ldeLabelbg.addGestureRecognizer(labelTap2)
        let labelPan2 = UIPanGestureRecognizer(target: self, action: "tilePannedRight:")
        self.ldeLabelbg.addGestureRecognizer(labelPan2)
        self.background.addSubview(self.ldeLabelbg)
        
        //MOD
        let pullRightView3 = UIImageView(image: pullRight)
        
        self.modLabelbg.frame = CGRectMake(-self.view.frame.width + 20, startingY + (gap * 2) + 2*self.labelHeight, (self.view.frame.width - 20), self.labelHeight)
        self.modLabelbg.tag = 3
        self.modLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
        
        pullRightView3.frame = CGRectMake(self.modLabelbg.frame.width - self.labelHeight + 10, 0, self.labelHeight, self.labelHeight)
        self.modLabelbg.addSubview(pullRightView3)
        
        self.modLabel.frame = CGRectMake(self.abbrLabelX, 0, self.modLabelbg.frame.width - self.labelHeight, self.labelHeight)
        self.modLabel.backgroundColor = UIColor.clearColor()
        self.modLabel.text = "MOD"
        self.modLabel.textAlignment = NSTextAlignment.Left
        self.modLabel.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.modLabel.textColor = Constants.FONT_COLOR()
        self.modLabelbg.addSubview(modLabel)
        
        self.modLabelLong.frame = longLabelFrame
        self.modLabelLong.alpha = 0
        self.modLabelLong.backgroundColor = UIColor.clearColor()
        self.modLabelLong.text = "CONGRUENCE"
        self.modLabelLong.textAlignment = NSTextAlignment.Center
        self.modLabelLong.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.modLabelLong.textColor = Constants.FONT_COLOR()
        self.modLabelbg.addSubview(self.modLabelLong)
        
        let labelTap3 = UITapGestureRecognizer(target: self, action: "tileTapped:")
        self.modLabelbg.addGestureRecognizer(labelTap3)
        let labelPan3 = UIPanGestureRecognizer(target: self, action: "tilePannedRight:")
        self.modLabelbg.addGestureRecognizer(labelPan3)
        self.background.addSubview(self.modLabelbg)
        self.view.addSubview(self.background)
        
        //About
        self.aboutLabelbg.frame = CGRectMake(self.view.frame.width - 30 - self.labelHeight, self.view.frame.height, self.labelHeight, (3/4)*self.view.frame.height)
        self.aboutLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
        var path = UIBezierPath()
        var start = CGPointMake(0, self.labelHeight/2)
        path.moveToPoint(start)
        path.addLineToPoint(CGPointMake(start.x + self.labelHeight/2, start.y - self.labelHeight/2))
        path.addLineToPoint(CGPointMake(start.x + self.labelHeight, start.y))
        path.addLineToPoint(CGPointMake(start.x + self.labelHeight, start.y - self.labelHeight/2 + self.aboutLabelbg.frame.height))
        path.addLineToPoint(CGPointMake(start.x, start.y - self.labelHeight/2 + self.aboutLabelbg.frame.height))
        path.addLineToPoint(start)
        path.closePath()
        var mask = CAShapeLayer()
        mask.frame = CGRectMake(0, 0, self.labelHeight, self.aboutLabelbg.frame.height)
        mask.path = path.CGPath
        self.aboutLabelbg.layer.mask = mask
        if Constants.IS_IPHONE5(){
            self.aboutLabel.frame = CGRectMake(-31, 31 + self.labelHeight/2 + 10, 1/4 * self.view.frame.height - self.labelHeight, self.labelHeight)
        }
        else if Constants.IS_IPAD(){
            self.aboutLabel.frame = CGRectMake(-68, 68 + self.labelHeight/2 + 20, 1/4 * self.view.frame.height - self.labelHeight, self.labelHeight)
        }
        else{
            self.aboutLabel.frame = CGRectMake(-20, 20 + self.labelHeight/2 + 5, 1/4 * self.view.frame.height - self.labelHeight, self.labelHeight)
        }
        self.aboutLabelbg.tag = 4
        self.aboutLabel.text = "ABOUT"
        if !Constants.IS_IPAD() && !Constants.IS_IPHONE5(){self.aboutLabel.text = "ABT"}
        self.aboutLabel.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: labelFontSize)
        self.aboutLabel.textAlignment = NSTextAlignment.Left
        self.aboutLabel.textColor = Constants.FONT_COLOR()
        self.aboutLabel.backgroundColor = UIColor.clearColor()
        self.aboutLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        let labelTap4 = UITapGestureRecognizer(target: self, action: "tileTapped:")
        self.aboutLabelbg.addGestureRecognizer(labelTap4)
        let labelPan4 = UIPanGestureRecognizer(target: self, action: "abtTilePannedUp:")
        self.aboutLabelbg.addGestureRecognizer(labelPan4)
        self.aboutLabelbg.addSubview(self.aboutLabel)
        self.background.addSubview(self.aboutLabelbg)
        
        
        // Functional views
        self.gcdCalcView = GCDCalcView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.gcdCalcView.alpha = 0
        self.gcdCalcView.delegate = self
        self.view.addSubview(self.gcdCalcView)
        
        self.ldeSolverView = LDESolverView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.ldeSolverView.alpha = 0
        self.view.addSubview(self.ldeSolverView)
        
        self.modSolverView = ModSolverView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.modSolverView.alpha = 0
        self.view.addSubview(self.modSolverView)
        
        //Animations
        self.isAnimating = true
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:
            {self.appTitleBg.frame = CGRectMake(30, self.appTitleBg.frame.origin.y, self.appTitleBg.frame.size.width, self.appTitleBg.frame.size.height)}, completion:
            {(complete: Bool) in
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {self.gcdLabelbg.frame = CGRectMake(self.tileOriginalX, self.gcdLabelbg.frame.origin.y, self.gcdLabelbg.frame.size.width, self.gcdLabelbg.frame.size.height)}, completion:
                    {(complete: Bool) in
                        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                            {self.ldeLabelbg.frame = CGRectMake(self.tileOriginalX, self.ldeLabelbg.frame.origin.y, self.ldeLabelbg.frame.size.width, self.ldeLabelbg.frame.size.height)}, completion:
                            {(complete: Bool) in
                                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                                    {self.modLabelbg.frame = CGRectMake(self.tileOriginalX, self.modLabelbg.frame.origin.y, self.modLabelbg.frame.size.width, self.modLabelbg.frame.size.height)}, completion:
                                    {(complete: Bool) in
                                        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                                            {
                                                if Constants.IS_IPHONE5() || Constants.IS_IPAD(){
                                                    self.aboutLabelbg.frame = CGRectMake(self.view.frame.width - 30 - self.labelHeight, self.view.frame.height - (1/4)*self.view.frame.width - 20, self.labelHeight, (3/4)*self.view.frame.height)
                                                }
                                                else{
                                                    //iphone 4
                                                    self.aboutLabelbg.frame = CGRectMake(self.view.frame.width - 30 - self.labelHeight, self.view.frame.height - (1/5)*self.view.frame.width, self.labelHeight, (3/4)*self.view.frame.height)
                                                }
                                            }, completion:
                                            {(complete: Bool) in
                                                self.aboutTileY = self.aboutLabelbg.frame.origin.y
                                                self.aboutTileCurrY = self.aboutTileY
                                                self.aboutTileX = self.aboutLabelbg.frame.origin.x
                                                self.isAnimating = false
                                        })
                                })
                        })
                })
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tileTapped(sender:UITapGestureRecognizer!){
        if !self.isAnimating && sender.view.tag >= 1 && sender.view.tag <= 3{
            self.isAnimating = true
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                sender.view.frame = CGRectMake(sender.view.frame.origin.x + 15, sender.view.frame.origin.y, sender.view.frame.width, sender.view.frame.height)
                }, completion:
                {(complete:Bool) in
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        sender.view.frame = CGRectMake(sender.view.frame.origin.x - 15, sender.view.frame.origin.y, sender.view.frame.width, sender.view.frame.height)
                        }, completion:
                        {(complete:Bool) in
                            self.isAnimating = false
                    })
            })
        }
        else if !self.isAnimating && sender.view.tag == 4{
            self.isAnimating = true
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                sender.view.frame = CGRectMake(sender.view.frame.origin.x, sender.view.frame.origin.y - 15, sender.view.frame.width, sender.view.frame.height)
                }, completion:
                {(complete:Bool) in
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        sender.view.frame = CGRectMake(sender.view.frame.origin.x, sender.view.frame.origin.y + 15, sender.view.frame.width, sender.view.frame.height)
                        }, completion:
                        {(complete:Bool) in
                            self.isAnimating = false
                    })
            })
            
        }
    }
    
    func tilePannedRight(sender:UIPanGestureRecognizer!){
        if !self.aboutTileIsMoving && (self.labelBeingMoved == sender.view.tag || self.labelBeingMoved == 0){
            self.labelBeingMoved = sender.view.tag
            if sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed{
                var translation:CGPoint = sender.translationInView(self.background)
                self.tileCurrentX += translation.x
                if self.tileCurrentX < self.tileOriginalX || self.tileCurrentX > -1
                {self.tileCurrentX -= translation.x}
                sender.setTranslation(CGPointZero, inView: self.background)
                dispatch_async(dispatch_get_main_queue(), {
                    self.layoutSubviews()
                })
                
            }
            else if sender.state == UIGestureRecognizerState.Ended{
                self.labelBeingMoved = 0
                self.tileCurrentX = self.tileOriginalX
                var target:UIView?
                if sender.view.frame.origin.x >= -5{
                    //Switch View!!
                    //                NSLog("max width reached")
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        sender.view.frame = CGRectMake(0, sender.view.frame.origin.y, self.view.frame.width, sender.view.frame.height)
                        sender.view.backgroundColor = Constants.FONT_COLOR()
                        switch(sender.view.tag){
                        case 1:
                            target = self.gcdCalcView
                            self.gcdLabelLong.textColor = Constants.MAIN_COLOR()
                        case 2:
                            target = self.ldeSolverView
                            self.ldeLabelLong.textColor = Constants.MAIN_COLOR()
                        case 3:
                            target = self.modSolverView
                            self.modLabelLong.textColor = Constants.MAIN_COLOR()
                        default:
                            break
                        }
                        }, completion: {(complete:Bool)in
                            if let targetView = target{
                                self.transitionToView(targetView)
                            }
                    })
                }
                else{
                    UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.gcdLabel.alpha = 1
                        self.ldeLabel.alpha = 1
                        self.modLabel.alpha = 1
                        self.gcdLabelLong.alpha = 0
                        self.ldeLabelLong.alpha = 0
                        self.modLabelLong.alpha = 0
                        sender.view.frame = CGRectMake(self.tileOriginalX, sender.view.frame.origin.y, sender.view.frame.width, sender.view.frame.height)
                        }, completion: {(complete:Bool)in})
                }
            }
            
        }
    }
    
    func abtTilePannedUp(sender:UIPanGestureRecognizer){
        self.labelBeingMoved = sender.view.tag
        if sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed{
            self.aboutTileIsMoving = true
            var translation:CGPoint = sender.translationInView(self.background)
            self.aboutTileCurrY += translation.y
            if (self.aboutTileCurrY <= (self.appTitleBg.frame.origin.y + self.appTitleBg.frame.height)) || (self.aboutTileCurrY > self.aboutTileY){
                //detect edge
                self.aboutTileCurrY -= translation.y
            }
            if sender.view.frame.origin.y <= self.appTitleBg.frame.origin.y + self.appTitleBg.frame.height + 10{
                if self.gcdLabelbg.backgroundColor != Constants.FONT_COLOR(){
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.gcdLabelbg.backgroundColor = Constants.FONT_COLOR()
                        self.ldeLabelbg.backgroundColor = Constants.FONT_COLOR()
                        self.modLabelbg.backgroundColor = Constants.FONT_COLOR()}, completion: {(complete:Bool)in})
                }
            }
            else{
                if self.gcdLabelbg.backgroundColor != Constants.SECONDARY_COLOR(){
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.gcdLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
                        self.ldeLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
                        self.modLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
                        }, completion: {(complete:Bool)in})
                }
                
            }
            sender.setTranslation(CGPointZero, inView: self.background)
            dispatch_async(dispatch_get_main_queue(), {
                self.layoutSubviews()
            })
        }
        else if sender.state == UIGestureRecognizerState.Ended{
            self.aboutTileCurrY = self.aboutTileY
            self.aboutTileIsMoving = false
            if sender.view.frame.origin.y <= self.appTitleBg.frame.origin.y + self.appTitleBg.frame.height + 10{
                //Switch to ABOUT View!!
                self.aboutLabel.alpha = 0
                //                NSLog("max height reached")
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.background.bringSubviewToFront(self.appTitleBg)
                    sender.view.frame = CGRectMake(sender.view.frame.origin.x, sender.view.frame.origin.y - self.labelHeight, self.view.frame.width, sender.view.frame.height)
                    }, completion: {(complete:Bool)in
                        self.aboutSlider = AboutSlider(frame: CGRectMake(-(self.view.frame.width - self.appTitleBg.frame.origin.x), self.appTitleBg.frame.height + self.appTitleBg.frame.origin.y - 10, self.view.frame.width - self.appTitleBg.frame.origin.x, self.view.frame.height - self.appTitleBg.frame.origin.y - self.appTitleBg.frame.height + 10))
                        if Constants.IS_IPAD(){
                            self.aboutSlider.frame = CGRectMake(-(self.view.frame.width - self.appTitleBg.frame.origin.x), self.appTitleBg.frame.height + self.appTitleBg.frame.origin.y, self.view.frame.width - self.appTitleBg.frame.origin.x, self.view.frame.height - self.appTitleBg.frame.origin.y - self.appTitleBg.frame.height)
                        }
                        self.aboutSlider.delegate = self
                        self.background.addSubview(self.aboutSlider)
                        var changeInX:CGFloat = self.view.frame.width - self.labelHeight - self.aboutLabelbg.frame.origin.x + 15
                        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                            self.aboutSlider.frame = CGRectMake(self.aboutSlider.frame.origin.x + changeInX, self.aboutSlider.frame.origin.y, self.aboutSlider.frame.width, self.aboutSlider.frame.height)
                            self.gcdLabelbg.frame = CGRectMake(self.gcdLabelbg.frame.origin.x + changeInX, self.gcdLabelbg.frame.origin.y, self.gcdLabelbg.frame.width, self.gcdLabelbg.frame.height)
                            self.ldeLabelbg.frame = CGRectMake(self.ldeLabelbg.frame.origin.x + changeInX, self.ldeLabelbg.frame.origin.y, self.ldeLabelbg.frame.width, self.ldeLabelbg.frame.height)
                            self.modLabelbg.frame = CGRectMake(self.modLabelbg.frame.origin.x + changeInX, self.modLabelbg.frame.origin.y, self.modLabelbg.frame.width, self.modLabelbg.frame.height)
                            self.aboutLabelbg.frame = CGRectMake(self.aboutLabelbg.frame.origin.x + changeInX, self.aboutLabelbg.frame.origin.y, self.aboutLabelbg.frame.width, self.aboutLabelbg.frame.height)
                            }, completion: {(complete:Bool)in
                                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                                    self.aboutSlider.frame = CGRectMake(30, self.aboutSlider.frame.origin.y, self.aboutSlider.frame.width, self.aboutSlider.frame.height)
                                    self.gcdLabelbg.frame = CGRectMake(self.gcdLabelbg.frame.origin.x + 30, self.gcdLabelbg.frame.origin.y, self.gcdLabelbg.frame.width, self.gcdLabelbg.frame.height)
                                    self.ldeLabelbg.frame = CGRectMake(self.ldeLabelbg.frame.origin.x + 30, self.ldeLabelbg.frame.origin.y, self.ldeLabelbg.frame.width, self.ldeLabelbg.frame.height)
                                    self.modLabelbg.frame = CGRectMake(self.modLabelbg.frame.origin.x + 30, self.modLabelbg.frame.origin.y, self.modLabelbg.frame.width, self.modLabelbg.frame.height)
                                    }, completion: {(complete:Bool)in
                                        self.aboutSlider.showText()
                                })
                        })
                })
            }
            else{
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.gcdLabel.alpha = 1
                    self.ldeLabel.alpha = 1
                    self.modLabel.alpha = 1
                    sender.view.frame = CGRectMake(sender.view.frame.origin.x, self.aboutTileY, sender.view.frame.width, sender.view.frame.height)
                    self.layoutSubviews()
                    }, completion: {(complete:Bool)in
                        self.labelBeingMoved = 0
                })
            }
        }
    }
    
    func layoutSubviews(){
        //        NSLog("layoutSubviews called")
        switch self.labelBeingMoved{
        case 1:
            //            NSLog("CASE 1")
            self.gcdLabelbg.frame = CGRectMake(self.tileCurrentX, self.gcdLabelbg.frame.origin.y, self.gcdLabelbg.frame.width, self.gcdLabelbg.frame.height)
            self.gcdLabel.alpha = (0-self.tileCurrentX)/(-self.tileOriginalX) - 0.15
            self.gcdLabelLong.alpha = 1.1 - ((-50-self.tileCurrentX)/(-self.tileOriginalX))
        case 2:
            //            NSLog("CASE 2")
            self.ldeLabelbg.frame = CGRectMake(self.tileCurrentX, self.ldeLabelbg.frame.origin.y, self.ldeLabelbg.frame.width, self.ldeLabelbg.frame.height)
            self.ldeLabel.alpha = (0-self.tileCurrentX)/(-self.tileOriginalX) - 0.15
            self.ldeLabelLong.alpha = 1.1 - ((-50-self.tileCurrentX)/(-self.tileOriginalX))
        case 3:
            //            NSLog("CASE 3")
            self.modLabelbg.frame = CGRectMake(self.tileCurrentX, self.modLabelbg.frame.origin.y, self.modLabelbg.frame.width, self.modLabelbg.frame.height)
            self.modLabel.alpha = (0-self.tileCurrentX)/(-self.tileOriginalX) - 0.15
            self.modLabelLong.alpha = 1.1 - ((-50-self.tileCurrentX)/(-self.tileOriginalX))
        case 4:
            //            NSLog("Case 4")
            self.aboutLabelbg.frame = CGRectMake(self.aboutLabelbg.frame.origin.x, self.aboutTileCurrY, self.aboutLabelbg.frame.width, self.aboutLabelbg.frame.height)
            //detect if about tile passed the 3 tiles
            //MOD TILE
            if self.aboutTileCurrY + self.labelHeight/2 < self.modLabelbg.frame.origin.y{
                if self.modLabelbg.frame.origin.x != self.aboutLabelbg.frame.origin.x + 40 - self.modLabelbg.frame.width{
                    //                    NSLog("MOD tile moving RIGHT")
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.modLabelbg.frame = CGRectMake(self.aboutLabelbg.frame.origin.x + 40 - self.modLabelbg.frame.width, self.modLabelbg.frame.origin.y, self.modLabelbg.frame.width, self.modLabelbg.frame.height)
                        self.modLabel.alpha = 0
                        }, completion: {(complete:Bool)in})
                }
            }
            else
            {
                if self.modLabelbg.frame.origin.x != self.tileOriginalX{
                    //                    NSLog("MOD tile moving LEFT")
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.modLabelbg.frame = CGRectMake(self.tileOriginalX, self.modLabelbg.frame.origin.y, self.modLabelbg.frame.width, self.modLabelbg.frame.height)
                        self.modLabel.alpha = 1
                        }, completion: {(complete:Bool)in})
                }
            }
            
            //LDE TILE
            if self.aboutTileCurrY + self.labelHeight/2 < self.ldeLabelbg.frame.origin.y{
                if self.ldeLabelbg.frame.origin.x != self.aboutLabelbg.frame.origin.x + 40 - self.ldeLabelbg.frame.width{
                    //                    NSLog("LDE tile moving RIGHT")
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.ldeLabelbg.frame = CGRectMake(self.aboutLabelbg.frame.origin.x + 40 - self.ldeLabelbg.frame.width, self.ldeLabelbg.frame.origin.y, self.ldeLabelbg.frame.width, self.ldeLabelbg.frame.height)
                        self.ldeLabel.alpha = 0
                        }, completion: {(complete:Bool)in})
                }
            }
            else
            {
                if self.ldeLabelbg.frame.origin.x != self.tileOriginalX{
                    //                    NSLog("LDE tile moving LEFT")
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.ldeLabelbg.frame = CGRectMake(self.tileOriginalX, self.ldeLabelbg.frame.origin.y, self.ldeLabelbg.frame.width, self.ldeLabelbg.frame.height)
                        self.ldeLabel.alpha = 1
                        }, completion: {(complete:Bool)in})
                }
            }
            
            
            //GCD TILE
            if self.aboutTileCurrY + self.labelHeight/2 < self.gcdLabelbg.frame.origin.y{
                if self.gcdLabelbg.frame.origin.x != self.aboutLabelbg.frame.origin.x + 40 - self.gcdLabelbg.frame.width{
                    //                    NSLog("GCD tile moving RIGHT")
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.gcdLabelbg.frame = CGRectMake(self.aboutLabelbg.frame.origin.x + 40 - self.gcdLabelbg.frame.width, self.gcdLabelbg.frame.origin.y, self.gcdLabelbg.frame.width, self.gcdLabelbg.frame.height)
                        self.gcdLabel.alpha = 0
                        }, completion: {(complete:Bool)in})
                }
            }
            else
            {
                if self.gcdLabelbg.frame.origin.x != self.tileOriginalX{
                    //                    NSLog("GCD tile moving LEFT")
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.gcdLabelbg.frame = CGRectMake(self.tileOriginalX, self.gcdLabelbg.frame.origin.y, self.gcdLabelbg.frame.width, self.gcdLabelbg.frame.height)
                        self.gcdLabel.alpha = 1
                        }, completion: {(complete:Bool)in})
                }
            }
        default:
            NSLog("Not moving labels")
        }
        
        
    }
    
    func restoreLayout(){
        dispatch_async(dispatch_get_main_queue(), {
            self.gcdLabelLong.textColor = Constants.FONT_COLOR()
            self.ldeLabelLong.textColor = Constants.FONT_COLOR()
            self.modLabelLong.textColor = Constants.FONT_COLOR()
            self.gcdLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
            self.ldeLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
            self.modLabelbg.backgroundColor = Constants.SECONDARY_COLOR()
            self.aboutLabel.alpha = 1
            self.gcdLabel.alpha = 1
            self.ldeLabel.alpha = 1
            self.modLabel.alpha = 1
            self.gcdLabelLong.alpha = 0
            self.ldeLabelLong.alpha = 0
            self.modLabelLong.alpha = 0
            self.rect1.removeFromSuperview()
            self.rect2.removeFromSuperview()
            self.gcdLabelbg.frame = CGRectMake(self.tileOriginalX, self.gcdLabelbg.frame.origin.y, (self.view.frame.width - 20), self.gcdLabelbg.frame.size.height)
            self.ldeLabelbg.frame = CGRectMake(self.tileOriginalX, self.ldeLabelbg.frame.origin.y, (self.view.frame.width - 20), self.ldeLabelbg.frame.size.height)
            self.modLabelbg.frame = CGRectMake(self.tileOriginalX, self.modLabelbg.frame.origin.y, (self.view.frame.width - 20), self.modLabelbg.frame.size.height)
            self.aboutLabelbg.frame = CGRectMake(self.aboutTileX, self.aboutTileY, self.aboutLabelbg.frame.width, self.aboutLabelbg.frame.height)
            self.background.transform = CGAffineTransformIdentity
        })
        
        self.tileCurrentX = self.tileOriginalX
        self.aboutTileCurrY = self.aboutTileY
        self.aboutTileIsMoving = false
        self.labelBeingMoved = 0
        self.isAnimating = false
    }
    
    func aboutSliderClose(){
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.background.alpha = 0
            }, completion: {(complete:Bool)in
                self.aboutSlider.removeFromSuperview()
                self.restoreLayout()
                UIView.animateWithDuration(0.4, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.background.alpha = 1
                    }, completion: {(complete:Bool)in})
        })
    }
    
    func transitionToView(targetView:UIView){
        self.focusOnActiveLabel(targetView, completionHandler:{
            UIView.animateWithDuration(0.5, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.background.transform = CGAffineTransformMakeScale(0.8, 0.8)
                }, completion: {(completion:Bool)in
                    targetView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        targetView.transform = CGAffineTransformIdentity
                        targetView.frame = CGRectMake(0, 0, targetView.frame.width, targetView.frame.height)
                        targetView.alpha = 1
                        }, completion: {(completion:Bool)in
                            if let activePage = self.activeView{
                                switch activePage{
                                case openFunctionPage.GCDPage:
                                    if !self.gcdVisShown{
                                        self.gcdCalcView.showFirstAnimation()
                                        self.gcdVisShown = true
                                    }
                                default:
                                    break
                                }
                                self.restoreLayout()
                            }
                            
                    })
            })
        })
        
    }
    
    func focusOnActiveLabel(targetView:UIView, completionHandler:()->Void){
        var targetLabel:UIView?
        switch targetView{
        case self.gcdCalcView:
            targetLabel = self.gcdLabelbg
            self.activeView = openFunctionPage.GCDPage
        case self.ldeSolverView:
            targetLabel = self.ldeLabelbg
            self.activeView = openFunctionPage.LDEPage
        case self.modSolverView:
            targetLabel = self.modLabelbg
            self.activeView = openFunctionPage.MODPage
        default:
            NSLog("Error in tracking target label")
            break
        }
        if let target = targetLabel{ //Optionals
            NSLog("focusing on target label")
            dispatch_async(dispatch_get_main_queue(), {
                self.isAnimating = true
                self.rect1.frame = CGRectMake(target.frame.origin.x, target.frame.origin.y-1, self.view.frame.width, 1)
                self.rect2.frame = CGRectMake(target.frame.origin.x, target.frame.origin.y+target.frame.height, self.view.frame.width, 1)
                self.rect1.backgroundColor = Constants.FONT_COLOR()
                self.rect2.backgroundColor = Constants.FONT_COLOR()
                self.background.addSubview(self.rect1)
                self.background.addSubview(self.rect2)
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.rect1.frame = CGRectMake(self.rect1.frame.origin.x, 0, self.rect1.frame.width, target.frame.origin.y)
                    self.rect2.frame = CGRectMake(self.rect2.frame.origin.x, self.rect2.frame.origin.y, self.rect2.frame.width, self.background.frame.height - self.rect2.frame.origin.y)
                    }, completion: {(completion:Bool)in
                        NSLog("Focused")
                        completionHandler()
                    }
                )
            })
        }
        else{
            NSLog("ERROR on transition")
        }
    }
    
    func closePage(){
        if let activeView = self.activeView{
            switch activeView{
            case openFunctionPage.GCDPage:
                NSLog("Closing GCD page")
                self.background.frame = CGRectMake(-self.view.frame.width, 0, self.view.frame.width, self.view.frame.height)
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.background.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    self.gcdCalcView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    }, completion: { (complete) -> Void in
                        UIView.animateWithDuration(0.7, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.background.frame = CGRectMake(0.1*self.view.frame.width, 0.1*self.view.frame.height, self.background.frame.width, self.background.frame.height)
                            self.gcdCalcView.frame = CGRectMake(1.1*self.view.frame.width, 0.1*self.view.frame.height, self.gcdCalcView.frame.width, self.gcdCalcView.frame.height)
                            }, completion: { (complete) -> Void in
                                UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                                    self.background.transform = CGAffineTransformIdentity
                                    self.gcdCalcView.transform = CGAffineTransformIdentity
                                    }, completion: { (complete) -> Void in
                                        self.gcdCalcView.alpha = 0
                                        self.gcdCalcView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                                })
                        })
                })
            case openFunctionPage.LDEPage:
                NSLog("Closing LDE page")
                self.background.frame = CGRectMake(-self.view.frame.width, 0, self.view.frame.width, self.view.frame.height)
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.background.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    self.ldeSolverView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    }, completion: { (complete) -> Void in
                        UIView.animateWithDuration(0.7, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.background.frame = CGRectMake(0.1*self.view.frame.width, 0.1*self.view.frame.height, self.background.frame.width, self.background.frame.height)
                            self.ldeSolverView.frame = CGRectMake(1.1*self.view.frame.width, 0.1*self.view.frame.height, self.ldeSolverView.frame.width, self.ldeSolverView.frame.height)
                            }, completion: { (complete) -> Void in
                                UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                                    self.background.transform = CGAffineTransformIdentity
                                    self.ldeSolverView.transform = CGAffineTransformIdentity
                                    }, completion: { (complete) -> Void in
                                        self.ldeSolverView.alpha = 0
                                        self.ldeSolverView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                                })
                        })
                })
            case openFunctionPage.MODPage:
                NSLog("Closing MOD page")
                self.background.frame = CGRectMake(-self.view.frame.width, 0, self.view.frame.width, self.view.frame.height)
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.background.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    self.modSolverView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    }, completion: { (complete) -> Void in
                        UIView.animateWithDuration(0.7, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.background.frame = CGRectMake(0.1*self.view.frame.width, 0.1*self.view.frame.height, self.background.frame.width, self.background.frame.height)
                            self.modSolverView.frame = CGRectMake(1.1*self.view.frame.width, 0.1*self.view.frame.height, self.modSolverView.frame.width, self.modSolverView.frame.height)
                            }, completion: { (complete) -> Void in
                                UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                                    self.background.transform = CGAffineTransformIdentity
                                    self.modSolverView.transform = CGAffineTransformIdentity
                                    }, completion: { (complete) -> Void in
                                        self.modSolverView.alpha = 0
                                        self.modSolverView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                                })
                        })
                })
            default:
                break
                
            }
        }
    }
}

