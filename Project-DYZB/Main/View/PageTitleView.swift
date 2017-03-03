//
//  PageTitleView.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/27.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate :class {//这里的class表示我们的协议只能被类遵守，如果不写的class的话，我们的协议可能被结构体遵守，也可能被枚举遵守
    func pageTitleView(titleView: PageTitleView, selectIndex : Int)
    
}
// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (red : CGFloat, green : CGFloat, blue : CGFloat) = (85,  85,85)
private let kSelectColor : (red : CGFloat, green : CGFloat, blue : CGFloat) = (255, 128, 0)
class PageTitleView: UIView {
    
    // MARK:- 定义属性
    fileprivate var titles : [String]
    // MARK:- 存放label的数组
    fileprivate var titleLabels = [UILabel]()
    
    var currentIndex = 0
    
    weak var delegate : PageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    fileprivate  lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    
    fileprivate  lazy var scrollLine : UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.orange
        return line
    }()
    
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

// MARK:- 设置UI
extension PageTitleView {
    fileprivate func setupUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        // 设置标题
        setupTitleLabels()
        // 设置scrollLine
        setupBottomAndScrollLine()
    }
    
    fileprivate func setupTitleLabels() {
        
        // 0.确定label的一些frame的值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 1.创建label
            let label = UILabel()
            // 2.设置属性
            label.text = title
            label.tag = index
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            
            
            // 3.设置frame
            let labX : CGFloat = CGFloat(index) * labelW
            label.frame = CGRect(x: labX, y: labelY, width: labelW, height: labelH)
            
            // 4. label添加到scrollView
            scrollView.addSubview(label)
            
            // 5.把label存放到数组
            titleLabels.append(label)
            
            // 6.添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelTapAction(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    
    fileprivate func setupBottomAndScrollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        // 2.添加scrollLine
        // 2.1 获得第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        // 2.2 设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
    }
    
}
// MARK:- 监听label的点击事件
extension PageTitleView {
    // 如果是事件监听的话需要加@objc
    @objc fileprivate  func titleLabelTapAction(tapGes: UITapGestureRecognizer) {
        // 1.获得当前的label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 2.点击的同一个label 直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 3.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 4.切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 5.保存最新的label的下标
        currentIndex = currentLabel.tag
        
        // 6.滚动条位置发生改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.size.width
        UIView.animate(withDuration: 0.15) {
//            self.scrollLine.frame.origin.x = scrollLineX
            self.scrollLine.x = scrollLineX
        }
        // 7. 通知代理
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
    }
}

// MARK:- 暴露出的方法
extension PageTitleView {
    func setTitleWithProgress(progress : CGFloat , sourceIndex : Int , targetIndex : Int) {
        // 1.取出label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.x - sourceLabel.x
        let moveX = moveTotalX * progress
        scrollLine.x = moveX + sourceLabel.x
        
        // 3.颜色的渐变
        // 3.1 颜色变化范围
        let colorRange = (red : kSelectColor.red - kNormalColor.red, green : kSelectColor.green - kNormalColor.green , blue : kSelectColor.blue - kNormalColor.blue)
        
        // 3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.red - colorRange.red * progress, g: kSelectColor.green - colorRange.green * progress, b: kSelectColor.blue - colorRange.blue * progress)
        
        // 3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.red + colorRange.red * progress, g: kNormalColor.green + colorRange.green * progress, b: kNormalColor.blue + colorRange.blue * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        
        
    }
}
