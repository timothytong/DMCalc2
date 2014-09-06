//
//  DMCalcKeyboard.swift
//  DMCalc 2
//
//  Created by Timothy Tong on 2014-08-21.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit
@objc protocol DMCalcKeyboardDelegate{
    /*
    0 - 9..numbers
    10..back
    11..next/done
    12..backspace
    13..clear
    */
    func keyboardButtonDidPressed(number:NSInteger)
    func keyboardNextButtonPressed()
    func keyboardDoneButtonPressed()
}

class DMCalcKeyboard: UIView {
    var viewsDict = Dictionary<String,UIView>()
    var delegate:DMCalcKeyboardDelegate?
    var isAtLastInput = false
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Constants.SECONDARY_COLOR()
        var width = self.frame.width * 0.244
        var offset = self.frame.width * 0.005
        var height = width
        var fontsize:CGFloat = 25
        if Constants.IS_IPAD(){
            fontsize += 15
        }
        for (var row:CGFloat = 0; row < 3; row++){
            for (var col:CGFloat = 0; col < 3; col++){
                var numberView = UIView()
                numberView.frame = CGRectMake((col + 1) * offset + col * width, (row + 1) * offset + row * height, width, height)
                numberView.backgroundColor = Constants.MAIN_COLOR()
                //                numberView.layer.borderColor = Constants.SECONDARY_COLOR().CGColor
                //                numberView.layer.borderWidth = 0.5
                var number:Int = Int(row*3 + (col+1))
                NSLog(String(format: "%d", number))
                var numberText = UILabel(frame: CGRectMake(0, 0, numberView.frame.width, numberView.frame.height))
                numberText.text = NSString(format: "%d",number)
                numberText.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: fontsize)
                numberText.textColor = Constants.FONT_COLOR()
                numberText.textAlignment = NSTextAlignment.Center
                numberView.tag = NSInteger(number)
                numberView.addSubview(numberText)
                self.addSubview(numberView)
                self.viewsDict.updateValue(numberView, forKey: NSString(format: "%d", number))
                self.viewsDict.updateValue(numberText, forKey: NSString(format: "t%d", number))
                let longPressGestureRec = UILongPressGestureRecognizer(target: self, action: "buttonLongPressed:")
                longPressGestureRec.minimumPressDuration = 0.0
                numberView.addGestureRecognizer(longPressGestureRec)
                /*
                let tapGestureRec = UITapGestureRecognizer(target: self, action: "numberButtonTapped:")
                tapGestureRec.requireGestureRecognizerToFail(longPressGestureRec)
                numberView.addGestureRecognizer(tapGestureRec)
                */
                
                
                //Special case: 3 -> Backspace
                if row == 0 && col == 2{
                    var backspaceView = UIView(frame: CGRectMake(4 * offset + 3 * width,offset, width, height))
                    backspaceView.backgroundColor = Constants.MAIN_COLOR()
                    var backspaceImg = UIImage(named: "backspace-white.png")
                    var backspaceImgView = UIImageView(image: backspaceImg)
                    backspaceImgView.clipsToBounds = true
                    backspaceImgView.frame = CGRectMake(backspaceView.frame.width/2 - backspaceView.frame.size.width/5, backspaceView.frame.height/2 - backspaceView.frame.height/5, backspaceView.frame.width/2.5, backspaceView.frame.height/2.5)
                    backspaceView.addSubview(backspaceImgView)
                    self.addSubview(backspaceView)
                    backspaceView.tag = 12
                    self.viewsDict.updateValue(backspaceView, forKey:"12")
                    self.viewsDict.updateValue(backspaceImgView, forKey:"i12")
                    let longPressGestureRec = UILongPressGestureRecognizer(target: self, action: "buttonLongPressed:")
                    longPressGestureRec.minimumPressDuration = 0.0
                    backspaceView.addGestureRecognizer(longPressGestureRec)
                }
                //Special case: 6 -> Clear
                if row == 1 && col == 2{
                    var clearView = UIView(frame: CGRectMake(4 * offset + 3 * width,2 * offset + height, width, height))
                    clearView.backgroundColor = Constants.MAIN_COLOR()
                    var clearImg = UIImage(named: "cancel-white.png")
                    var clearImgView = UIImageView(image: clearImg)
                    clearImgView.clipsToBounds = true
                    clearImgView.frame = CGRectMake(clearView.frame.width/2 - clearView.frame.width/5, clearView.frame.height/2 - clearView.frame.height/5, clearView.frame.width/2.5, clearView.frame.height/2.5)
                    let longPress = UILongPressGestureRecognizer(target: self, action: "buttonLongPressed:")
                    longPress.minimumPressDuration = 0.0
                    clearView.addGestureRecognizer(longPress)
                    clearView.addSubview(clearImgView)
                    self.addSubview(clearView)
                    clearView.tag = 13
                    self.viewsDict.updateValue(clearView, forKey:"13")
                    self.viewsDict.updateValue(clearImgView, forKey:"i13")
                    
                }
                //Special case: 9 -> BACK
                if row == 2 && col == 2{
                    var backView = UIView()
                    backView.frame = CGRectMake(4 * offset + 3 * width, 3 * offset + 2 * height, width, height)
                    backView.backgroundColor = Constants.MAIN_COLOR()
                    backView.tag = 10
                    var backText = UILabel(frame: CGRectMake(0, 0, backView.frame.width, backView.frame.height))
                    backText.text = "BACK"
                    backText.textAlignment = NSTextAlignment.Center
                    backText.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: fontsize - 7)
                    backText.textColor = Constants.FONT_COLOR()
                    let longPress = UILongPressGestureRecognizer(target: self, action: "buttonLongPressed:")
                    longPress.minimumPressDuration = 0.0
                    backView.addGestureRecognizer(longPress)
                    backView.addSubview(backText)
                    self.addSubview(backView)
                    self.viewsDict.updateValue(backView, forKey: "10")
                    self.viewsDict.updateValue(backText, forKey: "t10")
                    
                }
                
            }
            var remainingY = self.frame.height - 3 * height - 3 * offset
            var zeroView = UIView()
            zeroView.frame = CGRectMake(offset, 4 * offset + 3 * height, 3 * width + 2 * offset, remainingY)
            zeroView.backgroundColor = Constants.MAIN_COLOR()
            zeroView.layer.borderColor = Constants.MAIN_COLOR().CGColor
            zeroView.layer.borderWidth = 0.5
            zeroView.tag = 0
            var zeroText = UILabel(frame: CGRectMake(0, 0, zeroView.frame.width, zeroView.frame.height))
            zeroText.text = "0"
            zeroText.textAlignment = NSTextAlignment.Center
            zeroText.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: fontsize)
            zeroText.textColor = Constants.FONT_COLOR()
            zeroView.addSubview(zeroText)
            let longPress = UILongPressGestureRecognizer(target: self, action: "buttonLongPressed:")
            longPress.minimumPressDuration = 0.0
            longPress.allowableMovement = 10
            zeroView.addGestureRecognizer(longPress)
            self.addSubview(zeroView)
            self.viewsDict.updateValue(zeroView, forKey: "0")
            self.viewsDict.updateValue(zeroText, forKey: "t0")
            var nextView = UIView()
            nextView.frame = CGRectMake(4 * offset + 3 * width, 4 * offset + 3 * height, width, remainingY)
            nextView.backgroundColor = Constants.MAIN_COLOR()
            nextView.tag = 11
            var nextText = UILabel(frame: CGRectMake(0, 0, nextView.frame.width, nextView.frame.height))
            nextText.text = "NEXT"
            nextText.textAlignment = NSTextAlignment.Center
            nextText.font = UIFont(name: Constants.APP_DEFAULT_FONT_FACE(), size: fontsize - 7)
            nextText.textColor = Constants.FONT_COLOR()
            nextView.addSubview(nextText)
            let nextLongPress = UILongPressGestureRecognizer(target: self, action: "buttonLongPressed:")
            nextLongPress.minimumPressDuration = 0.0
            nextView.addGestureRecognizer(nextLongPress)
            self.addSubview(nextView)
            self.viewsDict.updateValue(nextView, forKey: "11")
            self.viewsDict.updateValue(nextText, forKey: "t11")
        }
    }
    func returnNumber(button:UIView) -> NSInteger{
        return button.tag
    }
    func buttonLongPressed(sender:UILongPressGestureRecognizer!){
        //        NSLog("Button long pressed")
        switch sender.view!.tag{
        case 0...11:
            var label:UILabel? = self.viewsDict[String(format: "t%d",sender.view!.tag)] as? UILabel
            if sender.state == UIGestureRecognizerState.Began{
                self.delegate?.keyboardButtonDidPressed(sender.view!.tag)
                UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    sender.view!.backgroundColor = Constants.FONT_COLOR()
                    if let textLabel = label{
                        textLabel.textColor = Constants.MAIN_COLOR()
                    }
                    }, completion: { (complete) -> Void in
                        
                        
                })
            }
            /*
            if sender.state == UIGestureRecognizerState.Failed || sender.state == UIGestureRecognizerState.Cancelled{
            NSLog("Gesture Failed/Canceled")
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            sender.view!.backgroundColor = Constants.MAIN_COLOR()
            }) { (complete) -> Void in
            }
            if let textLabel = label{
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            textLabel.textColor = Constants.FONT_COLOR()
            }, completion: { (complete) -> Void in
            })
            }
            }
            */
            if sender.state == UIGestureRecognizerState.Ended{
                //                NSLog("Gesture Ended")
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    sender.view!.backgroundColor = Constants.MAIN_COLOR()
                    }) { (complete) -> Void in
                }
                if let textLabel = label{
                    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        textLabel.textColor = Constants.FONT_COLOR()
                        }, completion: { (complete) -> Void in
                    })
                }
            }
            
        case 12...13:
            var imageView:UIImageView? = self.viewsDict[String(format: "i%d",sender.view!.tag)] as? UIImageView
            if sender.state == UIGestureRecognizerState.Began{
                self.delegate?.keyboardButtonDidPressed(sender.view!.tag)
                UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    sender.view!.backgroundColor = Constants.FONT_COLOR()
                    if let imgView = imageView{
                        if sender.view!.tag == 12{
                            var blackImg = UIImage(named: "backspace-black.png")
                            imgView.image = blackImg
                        }
                        else if sender.view!.tag == 13{
                            var blackImg = UIImage(named: "cancel-black.png")
                            imgView.image = blackImg
                        }
                    }
                    }, completion: { (complete) -> Void in
                        
                })
            }
            /*
            if sender.state == UIGestureRecognizerState.Failed || sender.state == UIGestureRecognizerState.Cancelled{
            NSLog("Gesture Failed/Canceled")
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            sender.view!.backgroundColor = Constants.MAIN_COLOR()
            }) { (complete) -> Void in
            }
            if let imgView = imageView{
            if sender.view!.tag == 12{
            var whiteImg = UIImage(named: "backspace-white.png")
            imgView.image = whiteImg
            }
            else if sender.view!.tag == 13{
            var whiteImg = UIImage(named: "cancel-white.png")
            imgView.image = whiteImg
            }
            }
            }
            */
            if sender.state == UIGestureRecognizerState.Ended{
                //                NSLog("Gesture Ended")
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    sender.view!.backgroundColor = Constants.MAIN_COLOR()
                    }) { (complete) -> Void in
                }
                if let imgView = imageView{
                    if sender.view!.tag == 12{
                        var whiteImg = UIImage(named: "backspace-white.png")
                        imgView.image = whiteImg
                    }
                    else if sender.view!.tag == 13{
                        var whiteImg = UIImage(named: "cancel-white.png")
                        imgView.image = whiteImg
                    }
                }
                
            }
        default:
            break
        }
        
        
        
    }
    /*
    func numberButtonTapped(sender:UITapGestureRecognizer!){
    NSLog("Number button tapped: #%d",sender.view.tag)
    self.isAtLastInput = false
    sender.view.backgroundColor = Constants.SECONDARY_COLOR()
    UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
    sender.view.backgroundColor = Constants.MAIN_COLOR()
    }) { (complete) -> Void in
    }
    self.delegate?.keyboardButtonDidPressed(sender.view.tag)
    }
    */
    func lastInput(){
        var nextLabel: UILabel? = self.viewsDict["11"] as? UILabel
        if let tempLabel:UILabel = nextLabel{
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                tempLabel.text = "DONE"
                }, completion: { (complete) -> Void in
            })
        }
        self.isAtLastInput = true
    }
    func nextButtonLongPressed(sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            if self.isAtLastInput{
                self.delegate?.keyboardDoneButtonPressed()
            }
            else{
                self.delegate?.keyboardNextButtonPressed()
            }
        }
    }
}
