//
//  TTPager.swift
//  TTPager
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
    var pagerHeader = TTPagerHeader()
    var pagerHeaderHeight = 40.0
    var pagerHeaderBackground: UIColor {
        get {
            return pagerHeader.backgroundColor!
        }
        set(newVal) {
            pagerHeader.backgroundColor = newVal
        }
    }
    var pagerHeaderIndicatorHeight: CGFloat {
        get {
            return pagerHeader.indicatorHeight
        }
        set(newVal) {
            pagerHeader.indicatorHeight = newVal
        }
    }
    var pagerHeaderIndicatorColor: UIColor {
        get {
            return pagerHeader.indicatorView.backgroundColor!
        }
        set(newVal) {
            pagerHeader.indicatorView.backgroundColor = newVal
        }
    }
    var tabClass: NSObject.Type?
    var views: Array<UIView>!
    var controllers = [UIViewController]()
    var currentIndex = Int(0)
    var scrollEnabled = Bool(true) {
        didSet {
            scrollView.scrollEnabled = scrollEnabled
        }
    }

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
        self.createpagerHeader()
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

    private func createpagerHeader() -> Void {
        pagerHeader.tabClass = tabClass
        pagerHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(pagerHeaderHeight))
        pagerHeader.delegate = self
        self.view.addSubview(pagerHeader)
        for vc in controllers {
            if let title = vc.title {
                pagerHeader.addTab(title)
            }
            else {
                pagerHeader.addTab("")
            }
        }
    }

    private func createPageContent() -> Void {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        scrollView.scrollEnabled = scrollEnabled
        if let recongnizr = self.navigationController?.interactivePopGestureRecognizer {
            scrollView.panGestureRecognizer.requireGestureRecognizerToFail(recongnizr);
        }
        scrollView.delegate = self
        self.addChildViewController(pageViewController)
        pageViewController.view.frame = CGRect(x: 0, y: CGFloat(pagerHeaderHeight), width: self.view.frame.width, height: CGFloat(self.view.frame.height - CGFloat(pagerHeaderHeight)))
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        self.selectTabAtIndex(0, animated: false)
    }

    private func selectTabAtIndex(index: Int, animated: Bool) -> Void {
        if index >= controllers.count {
            return
        }
        
        let direction: UIPageViewControllerNavigationDirection = currentIndex <= index ? .Forward : .Reverse
        let needAni = scrollEnabled ? animated : false
        scrollView.delegate = nil
        pageViewController.setViewControllers([controllers[index]], direction: direction, animated: needAni) { (b) in
            self.scrollView.delegate = self
        }
        self.didSwitchContent(index)
    }

    private func didSwitchContent(toIndex: Int) -> Void {
        pagerHeader.selectTab(toIndex)
        self.delegate?.ttPager(self, pageDidSwitch: currentIndex, to: toIndex)
        currentIndex = toIndex
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
        self.didSwitchContent(index!)
    }
}

extension TTPager: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x - scrollView.bounds.width
        pagerHeader.contentDidScroll(offset)
    }
}
