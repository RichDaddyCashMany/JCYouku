//
//  JCSearchResultViewController.swift
//  JCYouku
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit
import Alamofire

protocol JCSearchResultViewControllerDelegate: NSObjectProtocol {
    func hideKeyboard()
}

private let reuseIdentifier = "JCSearchResultCell"

class JCSearchResultViewController: UICollectionViewController {
    weak var delegate: JCSearchResultViewControllerDelegate!
    var data: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView?.backgroundColor = GlobalBackgroundColor
        self.collectionView!.registerClass(JCSearchResultCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func search(keyword: String) {
        // 搜索视频
        let param = [ClientIdKey: ClientIdValue, "keyword": keyword, "count": "30"]
        Alamofire.request(.GET, API_SearchVideo, parameters: param).responseJSON { response in
            if let json = response.result.value {
                let dict = json as! NSDictionary
                if dict["error"] == nil {
                    self.data = dict["videos"] as! NSMutableArray
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.data.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! JCSearchResultCell
        let dic = self.data[indexPath.row] as! NSDictionary
        cell.configCell(dic["thumbnail"] as! String, videoName: dic["title"] as! String)
        return cell
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.delegate?.hideKeyboard()
    }

}
