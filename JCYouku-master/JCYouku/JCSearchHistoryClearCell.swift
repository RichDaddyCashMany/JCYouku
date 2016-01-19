//
//  JCSearchHistoryClearCell.swift
//  JCYouku
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

protocol JCSearchHistoryClearCellDelegate: NSObjectProtocol {
    // 清空所有搜索历史
    func clearAllHistoryKeys()
}

class JCSearchHistoryClearCell: UITableViewCell {
    weak var delegate: JCSearchHistoryClearCellDelegate!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let btn = UIButton(frame: contentView.bounds)
        btn.setTitle("清空搜索历史", forState: UIControlState.Normal)
        btn.setTitleColor(JCColor(255, g: 60, b: 60), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.addTarget(self, action: "btnClick", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(btn)
    }
    
    func btnClick() {
        self.delegate?.clearAllHistoryKeys()
    }
    
}
