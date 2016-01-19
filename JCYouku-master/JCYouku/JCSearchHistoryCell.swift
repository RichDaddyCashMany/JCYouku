//
//  JCSearchHistoryCell.swift
//  JCYouku
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

protocol JCSearchHistoryCellDelegate: NSObjectProtocol{
    // 删除历史搜索关键字
    func deleteHistoryKey(key: String)
    // 点击历史搜索关键字
    func clickHistoryKey(key: String)
}

class JCSearchHistoryCell: UITableViewCell {
    var keyLabel: UILabel!
    weak var delegate: JCSearchHistoryCellDelegate!
    var line: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let icon = UIImageView(image: UIImage(named: "search_smalltime"))
        icon.x = 13.5
        icon.centerY = 22.5
        self.contentView.addSubview(icon)
        
        keyLabel = UILabel(frame: CGRectMake(34, 0, ScreenWidth - 68, 45))
        keyLabel.textColor = JCColor(102, g: 102, b: 102)
        keyLabel.font = UIFont.systemFontOfSize(14)
        let gesture = UITapGestureRecognizer(target: self, action: "tapKeyLabel")
        keyLabel.addGestureRecognizer(gesture)
        keyLabel.userInteractionEnabled = true
        self.contentView.addSubview(keyLabel)
        
        let deleteBtn = UIButton(frame: CGRectMake(0, 0, 45, 45))
        deleteBtn.center = CGPointMake(ScreenWidth - icon.centerX, 22.5)
        deleteBtn.setImage(UIImage(named: "search_smalldelete"), forState: UIControlState.Normal)
        deleteBtn.addTarget(self, action: "deleteBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(deleteBtn)
        
        line = UIView(frame: CGRectMake(9, 44.5, ScreenWidth - 18, 0.5))
        line.backgroundColor = GlobalLineColor
        self.contentView.addSubview(line)
    }
    
    func configKeyLabel(text: String) {
        keyLabel.text = text
    }

    func deleteBtnClick() {
        self.delegate.deleteHistoryKey(keyLabel.text!)
    }
    
    func tapKeyLabel() {
        self.delegate.clickHistoryKey(keyLabel.text!)
    }
    
    func showBottomLine(show: Bool) {
        line.hidden = !show
    }
}
