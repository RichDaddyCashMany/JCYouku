//
//  JCHomeViewController.swift
//  JCYouku
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit
import Alamofire

class JCHomeViewController: UITableViewController {

    let sliderCellIdentifier = "sliderCellIdentifier"
    let underSliderCellIdentifier = "underSliderCellIdentifier"
    var jsonDic: NSDictionary!
    var searchBtn: UIButton!
    var topBtns: [UIButton]! = []
    var topBtnLeftX: CGFloat = 0
    var topBtnWidth: CGFloat = 0
    var searchBtnIsHidden = true
    var searchIcon: UIImageView!
    var searchLabel: UILabel!
    var originTopBtn0Frame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = GlobalBackgroundColor
        self.tableView.registerClass(JCHomeSliderCell.self, forCellReuseIdentifier: sliderCellIdentifier)
        self.tableView.registerClass(JCHomeUnderSliderCell.self, forCellReuseIdentifier: underSliderCellIdentifier)
        
        // 导航栏View 用来自定义按钮在上面
        setupNavigationBar()
        
        // 请求首页数据
        Alamofire.request(.GET, URL_Home).responseJSON { response in
            if let json = response.result.value {
                self.jsonDic = json as! NSDictionary
                self.tableView.reloadData()
            }
        }
    }
    
    func setupNavigationBar() {
        let navView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 44))
        self.navigationController?.navigationBar.addSubview(navView)
        
        // 左边logo
        let logoView = UIImageView(image: UIImage(named: "topbar_logo"))
        logoView.x = 13
        logoView.centerY = 22
        navView.addSubview(logoView)
        
        // 右边5个按钮
        topBtnLeftX = logoView.width + 26
        topBtnWidth = (ScreenWidth - topBtnLeftX) / 5
        let topBtnNormalImageNames = [
            "topbar_icon_search_normal",
            "user_icon_vipcenter_normal",
            "topbar_icon_history_normal",
            "topbar_icon_upload_normal",
            "topbar_icon_more_normal"]
        let topBtnHighlightedImageNames = [
            "topbar_icon_search_pressed",
            "user_icon_vipcenter_click",
            "topbar_icon_history_pressed",
            "topbar_icon_upload_pressed",
            "topbar_icon_more_selected"]
        for index in 0...4 {
            let topBtn = UIButton(frame: CGRectMake(topBtnLeftX + CGFloat(index) * topBtnWidth, 0, topBtnWidth, 44))
            topBtn.setImage(UIImage(named: topBtnNormalImageNames[index]), forState: UIControlState.Normal)
            topBtn.setImage(UIImage(named: topBtnHighlightedImageNames[index]), forState: UIControlState.Highlighted)
            topBtn.addTarget(self, action: "topBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            navView.addSubview(topBtn)
            topBtns.append(topBtn)
        }
        
        searchBtn = UIButton(frame: CGRectMake(topBtnLeftX + topBtnWidth, 0, 0, 30))
        searchBtn.addTarget(self, action: "searchBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        searchBtn.centerY = 22
        searchBtn.setBackgroundImage(resizeImage(UIImage(named: "topbar_search_bg")), forState: UIControlState.Normal)
        searchBtn.setBackgroundImage(resizeImage(UIImage(named: "topbar_search_bg")), forState: UIControlState.Highlighted)
        navView.addSubview(searchBtn)
        
        searchIcon = UIImageView(image: UIImage(named: "navbar_search_icon"))
        searchIcon.center = topBtns[0].center
        searchIcon.x = topBtnLeftX + 10
        navView.addSubview(searchIcon)
        searchIcon.hidden = true
        
        searchLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(searchIcon.frame) + 6, 0, 100, 11))
        searchLabel.centerY = searchIcon.centerY
        searchLabel.text = "广场舞"
        searchLabel.font = UIFont.systemFontOfSize(11)
        searchLabel.textColor = JCColor(153, g: 153, b: 153)
        navView.addSubview(searchLabel)
        searchLabel.alpha = 0
        
        originTopBtn0Frame = topBtns[0].frame
    }
    
    func topBtnClick(btn: UIButton) {
        let index = self.topBtns.indexOf(btn)
        if index == 0 {
            self.presentViewController(UINavigationController(rootViewController: JCHomeSearchViewController()), animated: false, completion: nil)
        }
    }
    
    func searchBtnClick() {
        self.presentViewController(UINavigationController(rootViewController: JCHomeSearchViewController()), animated: false, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0.891 * ScreenWidth
        } else {
            return (0.281 * ScreenWidth + 50) * 2
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 9 {
            return 8
        } else {
            return 0.001
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(sliderCellIdentifier) as! JCHomeSliderCell
            if jsonDic != nil {
                cell.setJson(jsonDic)
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(underSliderCellIdentifier) as! JCHomeUnderSliderCell
            if jsonDic != nil {
                cell.setJson(jsonDic)
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let duration = 0.3
        if scrollView.contentOffset.y > -64 {
            if !searchBtnIsHidden {
                return
            }
            searchBtnIsHidden = false
            let lastTopBtnX = topBtnLeftX + topBtnWidth * 4
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                for index in 1...3 {
                    self.topBtns[index].x = lastTopBtnX
                    self.topBtns[index].alpha = 0
                }
                self.searchBtn.frame = CGRectMake(self.topBtnLeftX, 0, self.topBtnWidth * 4, 30)
                self.searchBtn.centerY = 22
                self.topBtns[0].frame = self.searchIcon.frame
                self.searchLabel.alpha = 1
                }, completion: { (finished) -> Void in
                    self.topBtns[0].hidden = true
                    self.searchIcon.hidden = false
            })
        } else {
            if searchBtnIsHidden {
                return
            }
            searchBtnIsHidden = true
            self.searchIcon.hidden = true
            self.topBtns[0].hidden = false
            UIView.animateWithDuration(duration, animations: { () -> Void in
                for index in 1...3 {
                    self.topBtns[index].x = self.topBtnLeftX + self.topBtnWidth * CGFloat(index)
                    self.topBtns[index].alpha = 1
                }
                self.searchBtn.frame = CGRectMake(self.topBtnLeftX + self.topBtnWidth, 0, 0, 30)
                self.searchBtn.centerY = 22
                self.topBtns[0].frame = self.originTopBtn0Frame
                self.searchLabel.alpha = 0
                }, completion: { (finished) -> Void in
                    
            })
        }
    }
}
