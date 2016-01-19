//
//  JCFuzzyKeywordCell.swift
//  JCYouku
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

class JCFuzzyKeywordCell: UITableViewCell {
    var nameLabel: UILabel!
    var bottomLine: UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        nameLabel = UILabel(frame: CGRectMake(16, 0, ScreenWidth - 32, 45))
        nameLabel.font = UIFont.systemFontOfSize(14)
        nameLabel.textColor = JCColor(102, g: 102, b: 102)
        contentView.addSubview(nameLabel)
        
        bottomLine = UIView(frame: CGRectMake(9, 44.5, ScreenWidth - 18, 0.5))
        bottomLine.backgroundColor = GlobalLineColor
        contentView.addSubview(bottomLine)
    }
    
    func configCell(name: String) {
        nameLabel.text = name
    }
    
    func hideBottmLine(hide: Bool) {
        bottomLine.hidden = hide
    }

}
