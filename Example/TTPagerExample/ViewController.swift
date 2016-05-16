//
//  ViewController.swift
//  TTPagerExample
//
//  Created by TangXueZhi on 16/5/16.
//  Copyright © 2016年 TangXueZhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TTPagerDelegate {
    var controllers: [UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let v1 = UIViewController()
        v1.view.backgroundColor = UIColor.redColor()
        v1.title = "11111"
        let v2 = UIViewController()
        v2.view.backgroundColor = UIColor.blueColor()
        v2.title = "22222"
        let v3 = UIViewController()
        v3.title = "33333"
        controllers = [v1, v2, v3]

        let pager = TTPager()
        pager.pagerHeaderHeight = 30
//        pager.scrollEnabled = false
        pager.delegate = self
        self.addChildViewController(pager)
        pager.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(pager.view)
        pager.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func ttPagerNumbersOfPage(ttPager: TTPager) -> Int {
        return controllers.count
    }
    func ttPager(ttPager: TTPager, pageControllerAtIndex index: Int) -> UIViewController {
        return controllers[index]
    }
}

