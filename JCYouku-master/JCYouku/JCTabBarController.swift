//
//  JCTabBarController.swift
//  JCYouku
//
//  Created by mac on 16/1/8.
//  Copyright © 2016年 HJaycee. All rights reserved.
//

import UIKit

class JCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC(JCHomeViewController(style: UITableViewStyle.Grouped), title: "首页", normalImage: "navbar_icon_home_normal", selectedImage: "navbar_icon_home_selected")
        addChildVC(JCChannelViewController(), title: "频道", normalImage: "navbar_icon_channel_normal", selectedImage: "navbar_icon_channel_selected")
        addChildVC(JCSubscribeViewController(), title: "订阅", normalImage: "navbar_icon_subscribe_normal", selectedImage: "navbar_icon_subscribe_selected")
        addChildVC(JCMineViewController(), title: "我的", normalImage: "navbar_icon_user_normal", selectedImage: "navbar_icon_user_selected")
    }

    func addChildVC(vc: UIViewController, title: String, normalImage: String, selectedImage: String){
        let navVC = UINavigationController(rootViewController: vc)
        navVC.tabBarItem = UITabBarItem(title: title, image: UIImage(named: normalImage), selectedImage: UIImage(named: selectedImage))
        addChildViewController(navVC)
    }

}
