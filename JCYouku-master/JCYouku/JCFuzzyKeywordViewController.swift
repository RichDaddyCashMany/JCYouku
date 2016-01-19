//
//  JCFuzzyKeywordViewController.swift
//  JCYouku
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit
import Alamofire

protocol JCFuzzyKeywordViewControllerDelegate: NSObjectProtocol {
    // 选择了关键词
    func chooseFuzzyKeyword(keyword: String)
}

class JCFuzzyKeywordViewController: UITableViewController {
    weak var delegate: JCFuzzyKeywordViewControllerDelegate!
    var data: NSArray = NSArray()
    let fuzzyKeywordCellIdentifier = "fuzzyKeywordCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = GlobalBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(JCFuzzyKeywordCell.self, forCellReuseIdentifier: fuzzyKeywordCellIdentifier)
    }

    func searchKeyword(keyword: String) {
        // 关键词联想
        let param = [ClientIdKey: ClientIdValue, "keyword": keyword]
        Alamofire.request(.GET, API_FuzzyKeyword, parameters: param).responseJSON { response in
            if let json = response.result.value {
                let dict = json as! NSDictionary
                if dict["error"] == nil {
                    self.data = dict["r"] as! NSArray
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(fuzzyKeywordCellIdentifier, forIndexPath: indexPath) as! JCFuzzyKeywordCell
        let dict = self.data[indexPath.row] as! NSDictionary
        cell.configCell(dict["c"] as! String)
        if indexPath.row == self.data.count - 1 {
            cell.hideBottmLine(true)
        } else {
            cell.hideBottmLine(false)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict = self.data[indexPath.row] as! NSDictionary
        self.delegate?.chooseFuzzyKeyword(dict["c"] as! String)
    }
}
