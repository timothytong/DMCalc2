//
//  GCDCalcView.swift
//  DMCalc 2
//
//  Created by Timothy Tong on 2014-07-27.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit

class GCDCalcView: UIView, UITextFieldDelegate {
    var titleBg = UIView()
    var num1In = UITextField()
    var num2In = UITextField()
    var backButton = UIButton()
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = Constants.MAIN_COLOR()
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
    }
    
    func showFirstAnimation(){
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.titleBg.frame = CGRectMake((1/4)*self.frame.width, self.titleBg.frame.origin.y, self.titleBg.frame.width, self.titleBg.frame.height)
            self.backButton.frame = CGRectMake(0, self.backButton.frame.origin.y, self.backButton.frame.width, self.backButton.frame.height)
            }, completion: {(completion:Bool)in
            })
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
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 0
            }, completion: {(completion:Bool)in})
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
