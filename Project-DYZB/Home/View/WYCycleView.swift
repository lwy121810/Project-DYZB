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
    var cycleModels : [CycleModel]? {
        didSet {
            //1.刷新collectionView
            collectionView.reloadData()
        
            // 2.设置pageControl
            self.pageControl.numberOfPages = cycleModels?.count ?? 0
            
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
        
        collectionView.isPagingEnabled = true
    }
    
}

extension WYCycleView {
    fileprivate func setupView () {
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        collectionView.register(UINib(nibName: "WYCycleCell", bundle: nil), forCellWithReuseIdentifier: kCellID)
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
        return self.cycleModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath) as! WYCycleCell
        
        //2.取出数据模型
        let model = cycleModels?[indexPath.item]
        
        cell.cycleModel = model
        
        return cell
        
        
    }
    
}
extension WYCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
