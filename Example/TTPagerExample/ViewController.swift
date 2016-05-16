//
//  ViewController.swift
//  TTPagerExample
//
//  Created by TangXueZhi on 16/5/16.
//  Copyright © 2016年 TangXueZhi. All rights reserved.
//

import UIKit

public class CustomTab: UIView {
    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(titleLabel)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
}

extension CustomTab: TTPagerTabAppearance {
    public func ttpagerSetTabTitle(title: String) -> Void {
        titleLabel.text = "Custom"+title
    }

    public func ttpagerSelectTab() -> Void {
        self.backgroundColor = UIColor.blackColor()
        titleLabel.textColor = UIColor.redColor()
    }

    public func ttpagerDeselectTab() -> Void {
        self.backgroundColor = UIColor.grayColor()
        titleLabel.textColor = UIColor.blackColor()
    }
}

class ViewController: UIViewController, TTPagerDelegate {
    var controllers: [UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let v1 = UIViewController()
        v1.view.backgroundColor = UIColor.redColor()
        v1.title = "111"
        let v2 = UIViewController()
        v2.view.backgroundColor = UIColor.blueColor()
        v2.title = "222"
        let v3 = UIViewController()
        v3.title = "333"
        controllers = [v1, v2, v3]

        let pager = TTPager()
        pager.tabClass = CustomTab.self
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

