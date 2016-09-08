//
//  MyTextField.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/5.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class MyTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderStyle = .None
    }

    override func drawRect(rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, rect.height - 2))
        bezierPath.addLineToPoint(CGPointMake(rect.width, rect.height - 2))
        bezierPath.lineWidth = 1
        UIColor.lightGrayColor().setStroke()
        bezierPath.stroke()
    }

}
