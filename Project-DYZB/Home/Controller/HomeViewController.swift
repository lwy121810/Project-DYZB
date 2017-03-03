//
//  HomeViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/27.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40
class HomeViewController: UIViewController {

    // MARK:- 懒加载属性
    lazy var pageTitleView : PageTitleView = {[weak self] in 
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    lazy var contentView : PageContentView = {[weak self] in
        // 确定内容的frame
        let contentY = kStatusBarH + kNavigationBarH + kTitleViewH
        let contentH = kScreenH - contentY - kTabbarH
        let contentFrame = CGRect(x: 0, y: contentY, width: kScreenW, height: contentH)
        // 创建所有的子控制器
        var childVcs = [UIViewController]()
        //推荐页面的vc
        let recommendVc = RecommendViewController()
        childVcs.append(recommendVc)
        
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self) // 用weak修饰之后 这里的self就是可选类型
        contentView.backgroundColor = UIColor.purple
        contentView.delegate = self
        
        return contentView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
// MARK:- 设置UI
extension HomeViewController {
    fileprivate func setupUI () {
        // 0.不需要调整UIScrollView的内边距 当有导航栏的时候 scrollView会自动添加一个64的内边距
        automaticallyAdjustsScrollViewInsets = false
        // 1.设置导航栏
        setupNavigationBar()
        // 2.添加TitleView
        view.addSubview(pageTitleView)
        // 3.添加contentView
        view.addSubview(contentView)
    }
    
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"logo")
        // 2.设置右侧的item
        let historyBtn = UIButton()
        let size = CGSize(width: 40, height: 40)
        historyBtn.setImage(UIImage.init(named: "image_my_history"), for: .normal)
        historyBtn.setImage(UIImage.init(named: "Image_my_history_click"), for: .highlighted)
        historyBtn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrItem]
    }
}

// MARK:- PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectIndex: Int) {
        print(selectIndex)
        contentView.setCurrentIndex(currentIndex: selectIndex)
    }
}
// MARK:- PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
