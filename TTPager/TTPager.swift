//
//  TTPager.swift
//  TTPagerExample
//
//  Created by TangXueZhi on 16/5/16.
//  Copyright © 2016年 TangXueZhi. All rights reserved.
//

import UIKit

public protocol TTPagerDelegate: class {
    func ttPagerNumbersOfPage(ttPager: TTPager) -> Int
    func ttPager(ttPager: TTPager, pageControllerAtIndex index: Int) -> UIViewController

    func ttPager(ttPager: TTPager, pageDidSwitch from: Int, to: Int) -> Void
}

extension TTPagerDelegate {
    func ttPager(ttPager: TTPager, pageDidSwitch from: Int, to: Int) -> Void {}
}


public class TTPager: UIViewController {
    var tabHeader = TTPagerHeader()
    var tabHeaderHeight = 40.0
    var views: Array<UIView>!
    var controllers = [UIViewController]()
    var currentIndex = Int(0)
    internal var pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    internal var scrollView: UIScrollView {
        get {
            let scrollview = pageViewController.view.subviews.flatMap {$0 as? UIScrollView}.first
            return scrollview!
        }
    }

    weak var delegate: TTPagerDelegate?

    public override func viewDidLoad() {
        self.loadData()
        self.createTabHeader()
        self.createPageContent()
    }

    private func loadData() -> Void {
        if let count = delegate?.ttPagerNumbersOfPage(self) {
            for index in 0...count-1 {
                let vc = delegate?.ttPager(self, pageControllerAtIndex: index)
                controllers.append(vc!)
            }
        }
    }

    private func createTabHeader() -> Void {
        for vc in controllers {
            if let title = vc.title {
                tabHeader.addTab(title)
            }
            else {
                tabHeader.addTab("")
            }
        }
        tabHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width.native, height: tabHeaderHeight)
        tabHeader.autoresizingMask = .FlexibleWidth
        tabHeader.backgroundColor = UIColor.blackColor()
        tabHeader.delegate = self
        self.view.addSubview(tabHeader)
    }

    private func createPageContent() -> Void {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChildViewController(pageViewController)
        pageViewController.view.frame = CGRect(x: 0, y: tabHeaderHeight, width: self.view.frame.width.native, height: self.view.frame.height.native - tabHeaderHeight)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        self.selectTabAtIndex(0, animated: false)
    }

    private func selectTabAtIndex(index: Int, animated: Bool) -> Void {
        let direction: UIPageViewControllerNavigationDirection = currentIndex <= index ? .Forward : .Reverse
        pageViewController.setViewControllers([controllers[index]], direction: direction, animated: animated, completion: nil)
        currentIndex = index
        tabHeader.selectTab(index)
    }
}

extension TTPager: TTPagerHeaderDelegate {
    func pageHeaderSelectTabAtIndex(index: Int) {
        self.selectTabAtIndex(index, animated: true)
    }
}

extension TTPager: UIPageViewControllerDataSource {
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = controllers.indexOf(viewController)
        if index! == controllers.count-1 {
            return nil
        }

        return controllers[index!+1]
    }

    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = controllers.indexOf(viewController)
        if index! == 0 {
            return nil
        }

        return controllers[index!-1]
    }

    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
}

extension TTPager: UIPageViewControllerDelegate {
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = controllers.indexOf((pageViewController.viewControllers?.first)!)
        tabHeader.selectTab(index!)
    }
}
