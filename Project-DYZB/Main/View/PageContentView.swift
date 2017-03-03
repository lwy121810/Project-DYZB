//
//  PageContentView.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/27.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

private let kCollectionCellIdentifier = "UICollectionCellIdentifier"

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress: CGFloat , sourceIndex : Int, targetIndex: Int)
}

class PageContentView: UIView {
    
    fileprivate var childVcs : [UIViewController]
    //    var parentViewController : UIViewController
    fileprivate weak var parentViewController : UIViewController?//这里使用weak，因为在HomeVc里面是对PageContentView有一个持有的，这里的parentViewController实际上就是HomeVc，如果对parentViewController强引用，会造成循环引用的问题，所以用weak修饰
    // 开始的偏移量
    fileprivate var startOffsetX : CGFloat = 0
    
    weak var delegate : PageContentViewDelegate?
    
    fileprivate var isForbidScrollDelegate : Bool = false
    
    // MARK:- 懒加载collectionView 懒加载的本质就是通过闭包来创建对象 闭包的格式就是(参数列表) -> (返回类型)
    fileprivate lazy var collectionView : UICollectionView = { [weak self] in //闭包中为了防止循环引用 采用弱引用
        // 1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.创建collectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        // 注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, childVcs:[UIViewController], parentViewController:UIViewController?) {
        self.parentViewController = parentViewController
        self.childVcs = childVcs
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("PageContentView deinit")
    }
}

// MARK:- 设置UI界面
extension PageContentView {
    fileprivate func setupUI() {
        // 1.将所有的子控制器添加到父控制器
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)//parentViewControllers是可选类型，所以用可选链
        }
        // 2.把collectionView添加到父控制器
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
// MARK:- UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionCellIdentifier, for: indexPath)
        
        // 2.设置cell内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}
// MARK:- UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 标记不是点击事件
        isForbidScrollDelegate = false
        
        //标记开始的偏移量
        startOffsetX = scrollView.contentOffset.x
//        print("开始拖拽\(startOffsetX)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0. 判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义需要获取的数据
        var progress : CGFloat = 0 //滑动页面的进度
        var sourceIndex : Int = 0 //当前页面的下标
        var targetIndex : Int = 0 //要滑动到的页面的下标
        
        // 2.判断滑动的方向
        let scrollViewW = scrollView.bounds.width
        let currentOffsetX = scrollView.contentOffset.x
        
        if startOffsetX < currentOffsetX { //左滑
            // 1.计算progress floor函数是取整
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1 //因为是左滑 所以target是source ＋ 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            // 4.如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else {// 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1 //因为这里是右滑 target比source小
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
        }
        
        // 3.将数据传递
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK:- 暴露出去的方法
extension PageContentView {
    func setCurrentIndex (currentIndex : Int) {
        // 1.记录需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        // 滚动的位置
        let offset = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offset,y:0), animated: false)
    }
}
