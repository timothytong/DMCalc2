//
//  GCDCalcView.swift
//  DMCalc 2
//
//  Created by Timothy Tong on 2014-07-27.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit
@objc protocol GCDCalcViewDelegate{
    func closePage(completionHandler:()->Void)
}

class GCDCalcView: UIView, UITextFieldDelegate, DMCalcKeyboardDelegate {
    var titleBg = UIView()
    var num1In = UITextField()
    var num2In = UITextField()
    var backButton = UIButton()
    var keyboard:DMCalcKeyboard!
    var delegate:GCDCalcViewDelegate?
    var keyboardIsOpen = false
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = Constants.MAIN_COLOR()
        self.layer.borderColor = Constants.MAIN_COLOR().CGColor
        self.layer.borderWidth = 0.5
        var titleheight:CGFloat = 80
        var titlefontsize:CGFloat = 30
        var titleY:CGFloat = 30
        if Constants.IS_IPAD(){
            titleheight = 80
            titlefontsize = 50
            titleY = 80
        }
        self.titleBg.frame = CGRectMake(self.frame.width, titleY, self.frame.width, titleheight)
        let title = UILabel(frame: CGRectMake(15, 0, self.frame.width, titleheight))
        self.backButton.frame = CGRectMake(-titleheight, titleY, titleheight, titleheight)
        title.textAlignment = NSTextAlignment.Left
        title.text = "Greatest Common Divisor"
        if !Constants.IS_IPAD(){
            title.frame = CGRectMake(0, 0, self.frame.width * (3/4) - 15, titleheight)
            title.text = "Greatest\nCommon Divisor"
            title.textAlignment = NSTextAlignment.Right
            self.backButton.frame = CGRectMake(-titleheight, titleY + 20, titleheight - 40, titleheight - 40)
        }
        
        self.titleBg.backgroundColor = Constants.SECONDARY_COLOR()
        self.backButton.backgroundColor = Constants.SECONDARY_COLOR()
        let backimg = UIImage(named: "back-white.png")
        self.backButton.setImage(backimg, forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "closePage", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.backButton)
        
        
        
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 0
        title.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: titlefontsize)
        title.textColor = Constants.FONT_COLOR()
        self.titleBg.addSubview(title)
        self.addSubview(self.titleBg)
        if !Constants.IS_IPAD(){
            self.keyboard = DMCalcKeyboard(frame:CGRectMake(self.frame.width/2 - 140, self.frame.height, 280, 280))
        }
        else{
            self.keyboard = DMCalcKeyboard(frame:CGRectMake(self.frame.width/2 - 210, self.frame.height, 420, 420))
        }
        self.keyboard.delegate = self
        self.addSubview(self.keyboard)
    }
    func GCDViewDidAppear(){
        self.showKeyboard()
    }
    func showKeyboard(){
        if !self.keyboardIsOpen{
            self.keyboard.alpha = 1
            if !Constants.IS_IPAD(){
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.keyboard.frame = CGRectMake(self.keyboard.frame.origin.x, self.frame.height - 280, 280, 280)
                    }, completion: { (complete) -> Void in
                        self.keyboardIsOpen = true
                })
            }
            else{
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.keyboard.frame = CGRectMake(self.keyboard.frame.origin.x, self.frame.height - 420, 420, 420)
                    }, completion: { (complete) -> Void in
                        self.keyboardIsOpen = true
                })
            }
        }
    }
    func showFirstAnimation(){
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.titleBg.frame = CGRectMake((1/4)*self.frame.width, self.titleBg.frame.origin.y, self.titleBg.frame.width, self.titleBg.frame.height)
            self.backButton.frame = CGRectMake(0, self.backButton.frame.origin.y, self.backButton.frame.width, self.backButton.frame.height)
            }, completion: {(completion:Bool)in
        })
    }
    func hideKeyboard(){
        if self.keyboardIsOpen{
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.keyboard.frame = CGRectMake(self.keyboard.frame.origin.x, self.frame.height, self.keyboard.frame.width, self.keyboard.frame.height)
                }) { (complete) -> Void in
                    self.keyboardIsOpen = false
                    self.keyboard.alpha = 0
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField!){
        /*
        switch textField.tag{
        case 1:
        case 2:
        default:
        break
        }
        */
    }
    
    func closePage(){
        if self.keyboardIsOpen{
            self.delegate?.closePage({ () -> Void in
                self.hideKeyboard()
            })
        }
        else{
            self.delegate?.closePage({ () -> Void in
            })
        }
        
    }
    
    func keyboardButtonDidPressed(number: NSInteger) {
        NSLog("%d",number)
    }
    
    func keyboardDoneButtonPressed() {
        NSLog("keyboard Done Button Pressed")
    }
    
    func keyboardNextButtonPressed() {
        NSLog("keyboard Next Button Pressed")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
    // Drawing code
    }
    */
    
}
