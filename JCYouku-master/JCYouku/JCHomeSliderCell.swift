//
//  JCHomeSliderCell.swift
//  JCYouku
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

class JCHomeSliderCell: UITableViewCell {
    var adView: AdView!
    var menu: UIView!
    var btnImgViews: [UIImageView]! = []
    var btnLabels: [UILabel]! = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        // 轮播图
        adView = AdView(frame: CGRectMake(0, 0, ScreenWidth, 0.469 * ScreenWidth))
        
        // 10个按钮的菜单
        menu = UIView(frame: CGRectMake(0, CGRectGetMaxY(adView.frame), ScreenWidth, 0.422 * ScreenWidth))
        let btnWidth = ScreenWidth / 5
        let btnHeight = menu.height / 2
        for index in 0...9 {
            // 按钮
            let btn = UIButton(frame: CGRectMake(CGFloat(Int(CGFloat(index) % 5)) * btnWidth, CGFloat(Int(CGFloat(index) / 5)) * btnHeight  + 10, btnWidth, menu.height / 2))
            menu.addSubview(btn)
            // 图标
            let imgView = UIImageView(frame: CGRectMake(0, 0, 36, 36))
            imgView.centerX = btn.width / 2
            imgView.centerY = 14
            btn.addSubview(imgView)
            // 文字
            let label = UILabel(frame: CGRectMake(0, 0, btnWidth, 11))
            label.textAlignment = NSTextAlignment.Center
            label.textColor = JCColor(85, g: 85, b: 85)
            label.font = UIFont.systemFontOfSize(11)
            label.centerY = 40
            btn.addSubview(label)
            
            btnImgViews.append(imgView)
            btnLabels.append(label)
        }
        
        contentView.addSubview(adView)
        contentView.addSubview(menu)
    }
    
    func setJson(json: NSDictionary) {
        let results = json["results"] as! NSArray
        let result0 = results[0]
        let slider = result0["slider"] as! NSArray
        var imgs: [String] = []
        var titles: [String] = []
        for item in slider {
            imgs.append(item["img"] as! String)
            titles.append(item["title"] as! String)
        }
        
        adView.imageLinkURL = imgs
        adView.setAdTitleArray(titles, withShowStyle: AdTitleShowStyle.Left)
        
        let navigation = result0["navigation"] as! NSArray
        var menuTitles: [String] = []
        var menuImages: [String] = []
        for item in navigation {
            menuTitles.append(item["title"] as! String)
            menuImages.append(item["icon_large"] as! String)
        }
        
        for index in 0...9 {
            btnImgViews[index].sd_setImageWithURL(NSURL(string: menuImages[index]))
            btnLabels[index].text = menuTitles[index]
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
