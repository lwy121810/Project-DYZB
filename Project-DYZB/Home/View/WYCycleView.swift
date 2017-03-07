//
//  WYCycleView.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/6.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

private let kCellID = "cellID"

class WYCycleView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK:- 定义属性
    
    ///定时器
    fileprivate var timer : Timer?
    
    var timeInterVal : Double = 3.0
    
    var cycleModels : [CycleModel]? {
        didSet {
            //1.刷新collectionView
            collectionView.reloadData()
        
            // 2.设置pageControl
            self.pageControl.numberOfPages = cycleModels?.count ?? 0
            
            // 3.默认滚到中间的某个位置
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //4.添加定时器
            removeTimer()
            addTimer()
            
        }
    }
    
    
    override func awakeFromNib() {
        
        //设置该控制不随着父控件的拉伸而拉伸 这个必须设置 否则会显示不了 因为我们把这个view添加到collectionView上， 而collectionView设置的是随着父控件（vc的view）的拉伸而拉伸collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]，如果不设置这个属性的话 cycleView会跟着collectionView拉伸而拉伸 最后会看不到这个view
        autoresizingMask = UIViewAutoresizing()//autoresizingMask = UIViewAutoresizing(rawValue: 0)
        setupView()
    }
    
    
    override func layoutSubviews() {//只有在这里的是最正确的
        super.layoutSubviews()
        // 设置layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        layout.minimumLineSpacing  = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
    }
    
}

extension WYCycleView {
    fileprivate func setupView () {
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        collectionView.register(UINib(nibName: "WYCycleCell", bundle: nil), forCellWithReuseIdentifier: kCellID)
        collectionView.isPagingEnabled = true
    }
}

// MARK:- 提供一个快速创建view的类方法
extension WYCycleView {
    class func wyCycleView() -> WYCycleView {
        return Bundle.main.loadNibNamed("WYCycleView", owner: nil, options: nil)?.first as! WYCycleView
    }
}

// MARK:- UICollectionViewDataSource
extension WYCycleView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //可选链返回的是可选类型 所以这里设置一个默认值
        return (self.cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! WYCycleCell
        
        //2.取出数据模型
        let model = cycleModels![(indexPath as NSIndexPath).item % cycleModels!.count]
        
        cell.cycleModel = model
        
        return cell
    }
    
}
// MARK:- 代理
extension WYCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取偏移量
        let offset = scrollView.contentOffset.x + scrollView.width * 0.5
        // 2.设置pageControl的currentIndex
        pageControl.currentPage = Int(offset / self.collectionView.width) % (cycleModels?.count ?? 1)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
}
// MARK:- 定时器的方法
extension WYCycleView {
    fileprivate func addTimer() {
        timer = Timer(timeInterval: timeInterVal, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    @objc fileprivate func scrollToNext () {
        //1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        //2.滚动到该位置
        let point  = CGPoint(x: offsetX, y: 0)
        collectionView.setContentOffset(point, animated: true)
    }
    fileprivate func removeTimer(){
        timer?.invalidate()//从运行循环中移除
        timer = nil
    }
    
}
