//
//  JCHomeUnderSliderCell.swift
//  JCYouku
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

class JCHomeUnderSliderCell: UITableViewCell {
    var imgViews: [UIImageView]! = []
    var imgLabels: [UILabel]! = []
    var bigLabels: [UILabel]! = []
    var smallLabels: [UILabel]! = []
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let bgViewWidth = ScreenWidth / 2
        let bgViewHeight = 0.281 * ScreenWidth + 50
        
        for index in 0...3 {
            let bgView0 = UIView(frame: CGRectMake(bgViewWidth * CGFloat(Int(CGFloat(index) % 2)), bgViewHeight * CGFloat(Int(CGFloat(index) / 2)), bgViewWidth, bgViewHeight))
            contentView.addSubview(bgView0)
            
            let imgView = UIImageView(frame: CGRectMake(0, 0, bgViewWidth, bgView0.height - 50))
            bgView0.addSubview(imgView)
            
            imgView.addSubview(JCGradientView())
            
            let imgLabel = UILabel(frame: CGRectMake(12, 0, bgViewWidth - 24, 11))
            imgLabel.centerY = 0.244 * ScreenWidth
            imgLabel.textColor = UIColor.whiteColor()
            imgLabel.font = UIFont.systemFontOfSize(11)
            bgView0.addSubview(imgLabel)
            
            let bigLabel = UILabel(frame: CGRectMake(12, 0, bgViewWidth - 24, 14))
            bigLabel.centerY = imgView.height + 14
            bigLabel.textColor = JCColor(51, g: 51, b: 51)
            bigLabel.font = UIFont.systemFontOfSize(14)
            bgView0.addSubview(bigLabel)
            
            let smallLabel = UILabel(frame: CGRectMake(12, 0, bgViewWidth - 24, 11))
            smallLabel.centerY = imgView.height + 32
            smallLabel.textColor = JCColor(200, g: 200, b: 200)
            smallLabel.font = UIFont.systemFontOfSize(11)
            bgView0.addSubview(smallLabel)
            
            imgViews.append(imgView)
            imgLabels.append(imgLabel)
            bigLabels.append(bigLabel)
            smallLabels.append(smallLabel)
        }
    }
    
    func setJson(json: NSDictionary) {
        let results = json["results"] as! NSArray
        let result0 = results[0]
        let under_slider = result0["under_slider"] as! NSArray
        var imgs: [String] = []
        var imgTitles: [String] = []
        var bigTitles: [String] = []
        var smallTitles: [String] = []
        for item in under_slider {
            imgs.append(item["img"] as! String)
            imgTitles.append(item["summary"] as! String)
            bigTitles.append(item["title"] as! String)
            smallTitles.append(item["subtitle"] as! String)
        }
        
        for index in 0...3 {
            imgViews[index].sd_setImageWithURL(NSURL(string: imgs[index]))
            imgLabels[index].text = imgTitles[index]
            bigLabels[index].text = bigTitles[index]
            smallLabels[index].text = smallTitles[index]
        }
    }
}
