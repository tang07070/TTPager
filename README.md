# TTPager
基于swift的iOS分页控制器

## 简介

TTPager使用`UIPageViewController`作为分页容器，支持顶部tab完全自定义

![](https://raw.githubusercontent.com/tang07070/TTPager/master/Example/Screenshot/screenshot_example_1.gif)

## 使用方法

直接把TTPager文件夹加入工程即可

+ 将TTPager添加到父控制器：

```swift
let pager = TTPager()
pager.tabClass = CustomTab.self
pager.delegate = self
self.addChildViewController(pager)
self.view.addSubview(pager.view)
pager.didMoveToParentViewController(self)
```

+ 实现`TTPagerDelegate`接口提供数据源

```swift
func ttPagerNumbersOfPage(ttPager: TTPager) -> Int
func ttPager(ttPager: TTPager, pageControllerAtIndex index: Int) -> UIViewController

func ttPager(ttPager: TTPager, pageDidSwitch from: Int, to: Int) -> Void
```


### 自定义tab

使用自定义视图需要实现`TTPagerTabAppearance`接口，并设置`TTPager.tabClass`属性：

```swift
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

let pager = TTPager()
pager.tabClass = CustomTab.self
```

### 其他
+ 使用`pagerHeaderHeight`设置顶部高度
+ 使用`pagerHeaderIndicatorHeight`设置顶部Indicator的高度
+ 使用`pagerHeaderIndicatorColor`设置顶部Indicator的颜色
+ 使用`scrollEnabled`设置Content是否可滚动
+ 必要时可直接通过`pagerHeader`设置顶部属性
