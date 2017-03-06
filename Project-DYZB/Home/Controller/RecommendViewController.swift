//
//  RecommendViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit


private let kItemMargin : CGFloat = 10
let kPrettyCellID = "kPrettyCellID"

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
private let kHeaderViewHeaderH : CGFloat = 50

let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 4 / 3

private let kCycleViewH = kScreenW * 3 / 8

/// 推荐页面
class RecommendViewController: UIViewController {

    /// 懒加载ViewModel
    fileprivate lazy var recommendVM = RecommendViewModel()
    
    /// 懒加载collectionView
    fileprivate  lazy var collectionView : UICollectionView = { [weak self] in
        // 1.创建layout
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        //设置组头
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewHeaderH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        
        /// 2.创建collectionView
        let collectionView = UICollectionView(frame:(self?.view.bounds)! , collectionViewLayout: layout)
        /// 这个时候的view的大小是等于屏幕的宽和高的 需要设置autoresizingMask属性 否则cell的位置会显示不正确
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.white
        /// 注册cell
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        /// 注册
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    
    // 懒加载cycleview
    fileprivate lazy var cycleView : WYCycleView = {
        
        let cycleView = WYCycleView.wyCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI
        setupUI()
        // 请求数据
        loadData()
    }

}
// MARK:- 设置UI
extension RecommendViewController {
    fileprivate func setupUI () {
        //1.添加collectionView
        view.addSubview(collectionView)
        
        //2.将cycleView添加到collectionView中
        collectionView.addSubview(cycleView)
        
        //3.设置collectionView的内边距 设置内边距的目的是让cycleView显示出来 不然cycleView需要拉伸才能显示
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
    }
}
// MARK:- 请求数据
extension RecommendViewController {
    fileprivate func loadData() {
        // 请求推荐数据
        recommendVM.requestData {
            self.collectionView.reloadData()
        }
        
        // 请求无限轮播数据
        recommendVM.requestCycleData { 
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
        
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroups[section]
        return group.anchors.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    // MARK:- 取出Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1.取出模型
        let anchorGroup = recommendVM.anchorGroups[indexPath.section]
        let anchorModel = anchorGroup.anchors[indexPath.item]
        
        // 2.定义cell
        var cell : CollectionBaseCell!
        
        
        // 3.取出cell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionViewPrettyCell
            
            
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionViewNormalCell
        }
        
        cell.anchor = anchorModel
        return cell
        
    }
    // MARK:- 组头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        // 2.给headerView赋值
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        return headerView
    }
}
// MARK:- UICollectionViewDelegate
extension RecommendViewController : UICollectionViewDelegate {
    
}
extension RecommendViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
}
