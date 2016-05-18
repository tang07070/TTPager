//
//  TTPagerHeader.swift
//  TTPager
//
//  Created by TangXueZhi on 16/5/16.
//  Copyright © 2016年 TangXueZhi. All rights reserved.
//

import UIKit

public protocol TTPagerTabAppearance {
    func ttpagerSetTabTitle(title: String) -> Void
    func ttpagerSelectTab() -> Void
    func ttpagerDeselectTab() -> Void
}

public class DefaultTTPagerTab: UIView {
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

extension DefaultTTPagerTab: TTPagerTabAppearance {
    public func ttpagerSetTabTitle(title: String) -> Void {
        titleLabel.text = title
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

protocol TTPagerHeaderDelegate {
    func pageHeaderSelectTabAtIndex(index: Int) -> Void
}

public class TTPagerHeader: UIView {
    var delegate: TTPagerHeaderDelegate?
    var tabs = [UIView]()
    var tabContainerView = UIView()
    var indicatorView = UIView()
    var indicatorHeight = CGFloat(3)
    var tabClass: NSObject.Type?

    var elementsCount = Int(0)
    var currentIndex = Int(0)
    var tabWidth = CGFloat(0)

    override init(frame: CGRect) {
        super.init(frame: frame)

        indicatorView.backgroundColor = UIColor.redColor()
        self.addSubview(indicatorView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func addTab(title: String) ->Void {
        let tab = self.createTab()
        let appearance = tab as! TTPagerTabAppearance
        appearance.ttpagerSetTabTitle(title)
        appearance.ttpagerDeselectTab()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabDidTap))
        tab.addGestureRecognizer(tapGesture)
        tabs.append(tab)
        self.addSubview(tab)
    }

    public func selectTab(index: Int) -> Void {
        let oldTab = tabs[currentIndex] as! TTPagerTabAppearance
        oldTab.ttpagerDeselectTab()
        let newTab = tabs[index] as! TTPagerTabAppearance
        newTab.ttpagerSelectTab()
        currentIndex = index

        let targetX = CGFloat(index)*tabWidth
        if targetX != indicatorView.frame.origin.x {
            UIView.animateWithDuration(0.4) {
                self.indicatorView.frame = CGRect(x: targetX, y: self.frame.height - self.indicatorHeight,
                                                       width: self.tabWidth, height: self.indicatorHeight)
            }
        }
    }

    private func createTab() -> UIView {
        if tabClass == nil {
            return DefaultTTPagerTab()
        }
        else {
            return tabClass!.init() as! UIView
        }
    }

    public override func layoutSubviews() {
        if tabs.count > 0 {
            tabWidth = self.frame.width / CGFloat(tabs.count)
            for index in 0...tabs.count-1 {
                let tab = tabs[index]
                tab.frame = CGRect(x: CGFloat(index)*tabWidth, y: 0, width: tabWidth, height: self.frame.height - indicatorHeight)
            }
            indicatorView.frame = CGRect(x: 0, y: self.frame.height - indicatorHeight, width: tabWidth, height: indicatorHeight)
        }
    }

    @objc private func tabDidTap(gesture: UIGestureRecognizer) {
        let view = gesture.view!
        let index = tabs.indexOf(view)
        delegate?.pageHeaderSelectTabAtIndex(index!)
    }

    public func contentDidScroll(offset: CGFloat) -> Void {
        if tabs.count == 0 || indicatorHeight == 0 {
            return
        }

        let baseOffset = tabWidth * CGFloat(currentIndex)
        let movedOffset = baseOffset + offset/CGFloat(tabs.count)
        indicatorView.frame = CGRect(x: movedOffset, y: self.frame.height - indicatorHeight, width: tabWidth, height: indicatorHeight)
    }
}
