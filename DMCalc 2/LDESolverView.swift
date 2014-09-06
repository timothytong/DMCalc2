//
//  LDESolverView.swift
//  DMCalc 2
//
//  Created by Timothy Tong on 2014-07-27.
//  Copyright (c) 2014 Timothy Tong. All rights reserved.
//

import UIKit

class LDESolverView: UIView {
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.backgroundColor = Constants.MAIN_COLOR()
        
    }
}
