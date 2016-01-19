//
//  JCSearchHistoryOpenCell.swift
//  JCYouku
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

protocol JCSearchHistoryOpenCellDelegate: NSObjectProtocol {
    // 展开搜索历史
    func openHistoryKeyCell()
}

class JCSearchHistoryOpenCell: UITableViewCell {
    weak var delegate: JCSearchHistoryOpenCellDelegate!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let btn = UIButton(frame: contentView.bounds)
        btn.setTitle("更多搜索历史", forState: UIControlState.Normal)
        btn.setTitleColor(JCColor(51, g: 51, b: 51), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.addTarget(self, action: "btnClick", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(btn)

        let icon = UIImageView(image: UIImage(named: "searchmore"))
        icon.x = ScreenWidth / 2 + 42
        icon.centerY = btn.height / 2
        btn.addSubview(icon)
    }
    
    func btnClick() {
        self.delegate?.openHistoryKeyCell()
    }

}
