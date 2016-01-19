//
//  JCHomeSearchViewController.swift
//  JCYouku
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit
import Alamofire

class JCHomeSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, JCSearchHistoryCellDelegate, JCSearchHistoryClearCellDelegate, JCSearchHistoryOpenCellDelegate, JCFuzzyKeywordViewControllerDelegate, JCSearchResultViewControllerDelegate {
    var jsonDic: NSDictionary!
    var searchField: UITextField!
    var historyKeys = NSMutableArray()
    let historyCellIdentifier = "historyCellIdentifier"
    let historyClearCellIdentifier = "historyClearCellIdentifier"
    let historyOpenCellIdentifier = "historyOpenCellIdentifier"
    var openCells = false
    var rowCount: Int!
    var fuzzyKeywordVC: JCFuzzyKeywordViewController!
    var searchResultVC: JCSearchResultViewController!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = GlobalBackgroundColor
        
        tableView.registerClass(JCSearchHistoryCell.self, forCellReuseIdentifier: historyCellIdentifier)
        tableView.registerClass(JCSearchHistoryClearCell.self, forCellReuseIdentifier: historyClearCellIdentifier)
        tableView.registerClass(JCSearchHistoryOpenCell.self, forCellReuseIdentifier: historyOpenCellIdentifier)
        
        // 添加关键词联想控制器
        fuzzyKeywordVC = JCFuzzyKeywordViewController()
        fuzzyKeywordVC.tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)
        fuzzyKeywordVC.delegate = self
        self.addChildViewController(fuzzyKeywordVC)
        self.view.addSubview(fuzzyKeywordVC.tableView)
        fuzzyKeywordVC.tableView.hidden = true
        
        // 添加搜索结果控制器
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (ScreenWidth - 20 - 3) / 2
        let itemHeight = itemWidth * 0.56 + 46
        layout.itemSize = CGSizeMake(itemWidth, itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        searchResultVC = JCSearchResultViewController(collectionViewLayout: layout)
        searchResultVC.view.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)
        searchResultVC.delegate = self
        self.addChildViewController(searchResultVC)
        self.view.addSubview(searchResultVC.view)
        searchResultVC.view.hidden = true
        
        // 请求10条搜索排行榜
        Alamofire.request(.GET, URL_HotKey).responseJSON { response in
            if let json = response.result.value {
                self.jsonDic = json as! NSDictionary
                self.setupFootSortView()
            }
        }
        
        updateHistoryKeysAndTableView()
    }
    
    func setupNavigationBar() {
        let navView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 44))
        self.navigationController?.navigationBar.addSubview(navView)
        
        let searchBgView = UIButton(frame: CGRectMake(13, 0, ScreenWidth - 64, 30))
        searchBgView.centerY = 22
        searchBgView.setBackgroundImage(resizeImage(UIImage(named: "topbar_search_bg")), forState: UIControlState.Normal)
        navView.addSubview(searchBgView)
        
        let searchIcon = UIImageView(image: UIImage(named: "navbar_search_icon"))
        searchIcon.centerY = 15
        searchIcon.x = 10
        searchBgView.addSubview(searchIcon)
        
        let searchFieldX = CGRectGetMaxX(searchIcon.frame) + 6
        searchField = UITextField(frame: CGRectMake(searchFieldX, 0, searchBgView.width - searchFieldX, searchBgView.height))
        searchField.font = UIFont.systemFontOfSize(11)
        searchField.placeholder = "广场舞"
        searchField.clearButtonMode = UITextFieldViewMode.WhileEditing
        searchBgView.addSubview(searchField)
        
        // 监听搜索框内容改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchFieldChange:", name: UITextFieldTextDidChangeNotification, object: searchField)
        
        let cancelBtn = UIButton(frame: CGRectMake(CGRectGetMaxX(searchBgView.frame), 0, 51, 44))
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(JCColor(102, g: 102, b: 102), forState: UIControlState.Normal)
        cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        cancelBtn.addTarget(self, action: "cancalBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        navView.addSubview(cancelBtn)
    }
    
    // 搜索框内容改变
    func searchFieldChange(notification: NSNotification) {
        let field = notification.object as! UITextField
        
        // 搜索框无内容就隐藏这个tableView
        fuzzyKeywordVC.tableView.hidden = field.text!.characters.count == 0
        // 显示关键词联想view就隐藏footerView
        tableView.tableFooterView?.hidden = !fuzzyKeywordVC.tableView.hidden
        // 只有改变搜索内容就隐藏搜索结果控制器
        searchResultVC.view.hidden = true
        // 搜索
        fuzzyKeywordVC.searchKeyword(field.text!)
    }
    
    func setupFootSortView() {
        let hotkeyView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 281))
        hotkeyView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = hotkeyView
        // 显示关键词联想view就隐藏footerView
        tableView.tableFooterView?.hidden = !fuzzyKeywordVC.tableView.hidden
        
        let topBgView = UIView(frame: CGRectMake(0, 0, ScreenWidth, 8))
        topBgView.backgroundColor = GlobalBackgroundColor
        hotkeyView.addSubview(topBgView)
        
        let bottomBgView = UIView(frame: CGRectMake(0, hotkeyView.height - 8, ScreenWidth, 8))
        bottomBgView.backgroundColor = GlobalBackgroundColor
        hotkeyView.addSubview(bottomBgView)
        
        let sortView = UIImageView(image: UIImage(named: "head_top50"))
        sortView.x = 13
        sortView.centerY = 30
        hotkeyView.addSubview(sortView)
        
        let sortLabel = UILabel(frame: CGRectMake(35, 0, 120, 13))
        sortLabel.text = "搜索排行榜"
        sortLabel.textColor = JCColor(153, g: 153, b: 153)
        sortLabel.font = UIFont.systemFontOfSize(13)
        sortLabel.centerY = 30
        hotkeyView.addSubview(sortLabel)
        
        let data = self.jsonDic["data"] as! NSArray
        
        for index in 0...9 {
            let dict = data[index] as! NSDictionary
            
            // 正方形序号
            let squareLabel = UILabel(frame: CGRectMake(13 + ScreenWidth / 2 * CGFloat(Int(CGFloat(index) / 5)), 0, 15, 15))
            squareLabel.centerY = 70.5 + CGFloat(index) % 5 * 45
            squareLabel.text = String(index + 1)
            squareLabel.textColor = UIColor.whiteColor()
            squareLabel.font = UIFont.systemFontOfSize(12)
            squareLabel.textAlignment = NSTextAlignment.Center
            hotkeyView.addSubview(squareLabel)
            
            // 设置不同的背景色
            switch index {
            case 0:
                squareLabel.backgroundColor = JCColor(255, g: 15, b: 28)
            case 1:
                squareLabel.backgroundColor = JCColor(255, g: 128, b: 36)
            case 2:
                squareLabel.backgroundColor = JCColor(255, g: 163, b: 41)
            default :
                squareLabel.backgroundColor = JCColor(217, g: 217, b: 217)
            }
            
            // 关键词
            let hotKeyLabelX = squareLabel.x + 20
            let hotKeyLabel = UILabel(frame: CGRectMake(hotKeyLabelX, 0, ScreenWidth / 2 - 46, 45))
            hotKeyLabel.centerY = squareLabel.centerY
            hotKeyLabel.text = dict["keyword"] as? String
            hotKeyLabel.textColor = JCColor(102, g: 102, b: 102)
            hotKeyLabel.font = UIFont.systemFontOfSize(14)
            hotkeyView.addSubview(hotKeyLabel)
            
            let gesture = UITapGestureRecognizer(target: self, action: "hotKeyTouch:")
            hotKeyLabel.addGestureRecognizer(gesture)
            hotKeyLabel.userInteractionEnabled = true
        }

        // 分割线
        for index in 0...4 {
            let line = UIView(frame: CGRectMake(10, 93 + CGFloat(index) * 45, ScreenWidth - 20, 0.5))
            line.backgroundColor = GlobalLineColor
            hotkeyView.addSubview(line)
        }
        
    }
    
    // 关键词点击
    func hotKeyTouch(gesture: UITapGestureRecognizer) {
        let label = gesture.view as! UILabel
        insertHistoryKey(label.text!)
        
        updateHistoryKeysAndTableView()
        
        gotoSearch(label.text!)
    }
    
    // 添加关键词，重复的移到第一个
    func insertHistoryKey(key: String) {
        let exist = self.historyKeys.containsObject(key)
        if exist {
            self.historyKeys.removeObject(key)
        }
        self.historyKeys.insertObject(key, atIndex: 0)
        self.historyKeys.writeToFile(HistorySearchKeyFileName, atomically: true)
    }
    
    func updateHistoryKeysAndTableView() {
        let keys = NSArray(contentsOfFile: HistorySearchKeyFileName)
        if keys == nil {
            return
        }
        self.historyKeys.removeAllObjects()
        for key in keys!{
            self.historyKeys.addObject(key)
        }
        self.tableView.reloadData()
    }
    
    func cancalBtnClick() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.historyKeys.count < 3 {
            rowCount = self.historyKeys.count
        } else if self.historyKeys.count == 3 {
            rowCount = self.historyKeys.count + 1
        } else { // 搜索历史个数大于3个
            if self.openCells { // 展开了
                rowCount = self.historyKeys.count + 1
            } else { // 没有展开
                rowCount = 4
            }
        }
        return rowCount
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if historyKeys.count == 0 {
            return 0.001
        } else {
            return 8
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == rowCount - 1 && self.historyKeys.count >= 3 { // 最后一个cell且历史搜索大于等于3个
            return 40
        } else {
            return 45
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == rowCount - 1 && self.historyKeys.count >= 3 { // 最后一个cell且历史搜索大于等于3个
            if self.historyKeys.count == 3 || self.openCells {
                let cell = tableView.dequeueReusableCellWithIdentifier(historyClearCellIdentifier) as! JCSearchHistoryClearCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(historyOpenCellIdentifier) as! JCSearchHistoryOpenCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(historyCellIdentifier, forIndexPath: indexPath) as! JCSearchHistoryCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.configKeyLabel(self.historyKeys[indexPath.row] as! String)
            cell.delegate = self
            cell.showBottomLine(indexPath.row != rowCount - 1)
            return cell
        }
    }
    
    // MARK: - JCSearchHistoryCellDelegate
    
    func deleteHistoryKey(key: String) {
        self.historyKeys.removeObject(key)
        self.historyKeys.writeToFile(HistorySearchKeyFileName, atomically: true)
        
        updateHistoryKeysAndTableView()
    }
    
    func clickHistoryKey(key: String) {
        self.historyKeys.removeObject(key)
        self.historyKeys.insertObject(key, atIndex: 0)
        self.historyKeys.writeToFile(HistorySearchKeyFileName, atomically: true)
        
        updateHistoryKeysAndTableView()
        
        gotoSearch(key)
    }
    
    // MARK: - JCSearchHistoryOpenCellDelegate
    
    func openHistoryKeyCell() {
        self.openCells = true
        self.tableView.reloadData()
    }
    
    // MARK: - JCSearchHistoryClearCellDelegate
    
    func clearAllHistoryKeys() {
        self.historyKeys.removeAllObjects()
        self.historyKeys.writeToFile(HistorySearchKeyFileName, atomically: true)
        
        updateHistoryKeysAndTableView()
    }
    
    // MARK: - JCFuzzyKeywordViewControllerDelegate
    
    func chooseFuzzyKeyword(keyword: String) {
        insertHistoryKey(keyword)
        
        updateHistoryKeysAndTableView()
        
        gotoSearch(keyword)
    }
    
    func gotoSearch(keyword: String) {
        searchField.text = keyword
        searchResultVC.view.hidden = false
        searchResultVC.search(keyword)
        tableView.tableFooterView?.hidden = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    // MARK: - JCSearchResultViewControllerDelegate
    
    func hideKeyboard() {
        searchField.resignFirstResponder()
    }

}
