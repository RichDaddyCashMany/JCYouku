//
//  JCGradientView.swift
//  JCYouku
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

// 渐变层，用于突出图片上的白色文字

import UIKit

class JCGradientView: UIView {
    override func willMoveToSuperview(newSuperview: UIView?) {
        self.frame = newSuperview!.bounds
        let gradientLayer = CAGradientLayer()
        gradientLayer.bounds = newSuperview!.bounds
        gradientLayer.position = newSuperview!.center
        gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        self.layer.addSublayer(gradientLayer)
        self.alpha = 0.5
    }
}
