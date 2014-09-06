//
//  AboutSlider.swift
//  DMCalc-Swift
//
//  Created by Timothy Tong on 2014-07-20.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit
@objc protocol AboutSliderDelegate{
    func aboutSliderClose()
}
class AboutSlider: UIView {
    var delegate:AboutSliderDelegate?
    var aboutSliderIsOpen = false
    var textArea = UIView()
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = Constants.SECONDARY_COLOR()
        let aboutTitle = UILabel(frame: CGRectMake(0, 0, self.frame.width - 20, 40))
        var fontsize:CGFloat = 40
        if(Constants.IS_IPAD()){
            fontsize += 20
            aboutTitle.frame = CGRectMake(0, 0, self.frame.width - 20, 60)
        }
        aboutTitle.text = "- About (v\(Constants.APP_VERSION()))"
        aboutTitle.textColor = Constants.FONT_COLOR()
        aboutTitle.textAlignment = NSTextAlignment.Right
        aboutTitle.backgroundColor = UIColor.clearColor()
        aboutTitle.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: fontsize)
        self.addSubview(aboutTitle)
    }
    func showText(){
        var textAreaWidth = self.frame.width - 20
        if(Constants.IS_IPAD()){
            textAreaWidth/=2
        }
        self.textArea.frame = CGRectMake(self.frame.size.width, 50, textAreaWidth, self.frame.height - 70)
        self.textArea.backgroundColor = Constants.MAIN_COLOR()
        let text = UILabel(frame:CGRectMake(10, 0, textAreaWidth - 10, self.frame.height - 70))
        var textFontSize:CGFloat = 20
        if(Constants.IS_IPAD()){
            self.textArea.frame = CGRectMake(self.frame.size.width, 70, textAreaWidth, self.frame.height - 200)
            text.frame = CGRectMake(10, 0, textAreaWidth - 10, self.frame.height - 200)
            textFontSize += 10
        }
        text.text = "Discrete Math Calculator Version 2, written in Swift, brand new look brand new feel.  Please report any bugs/problems/suggestions to me@timothytong.com."
        text.textAlignment = NSTextAlignment.Left
        text.numberOfLines = 0
        text.textColor = Constants.FONT_COLOR()
        text.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: textFontSize)
        text.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.textArea.addSubview(text)
        let cancelimg = UIImage(named: "cancel-white.png")
        let cancelbutton = UIButton(frame: CGRectMake(self.textArea.frame.width - 30, self.textArea.frame.height - 40, 25, 25))
        cancelbutton.setImage(cancelimg, forState: UIControlState.Normal)
        cancelbutton.addTarget(self, action: "closeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.textArea.addSubview(cancelbutton)
        self.addSubview(self.textArea)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.textArea.frame = CGRectMake(self.frame.width - textAreaWidth, self.textArea.frame.origin.y, textAreaWidth, self.textArea.frame.height)
            }, completion: {(complete:Bool)in})
    }
    func closeButtonTapped(sender:AnyObject){
        self.delegate?.aboutSliderClose()
    }
    /*
    func openSlider(){
    if(self.aboutSliderIsOpen){
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
    self.frame = CGRectMake(30, self.frame.origin.y, self.frame.width, self.frame.height)
    }, completion: {(complete:Bool)in self.aboutSliderIsOpen = true})
    }
    else{
    NSLog("Can't open about slider because it is already open")
    }
    }
    func closeSlider(){
    if(!self.aboutSliderIsOpen){
    UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
    self.frame = CGRectMake(-self.frame.width, self.frame.origin.y, self.frame.width, self.frame.height)
    }, completion: {(complete:Bool)in self.aboutSliderIsOpen = false})
    }
    else{
    NSLog("Can't close about slider because it is already closed")
    }
    }
    */
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
