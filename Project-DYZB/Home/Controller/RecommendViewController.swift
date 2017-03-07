//
//  RecommendViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit


private let kCycleViewH = kScreenW * 3 / 8
private let kGameViewH : CGFloat = 90
/// 推荐页面
class RecommendViewController: BaseAnchorViewController {

    /// 懒加载ViewModel
    fileprivate lazy var recommendVM = RecommendViewModel()
    // 懒加载cycleview
    fileprivate lazy var cycleView : WYCycleView = {
        
        let cycleView = WYCycleView.wyCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH - kGameViewH, width: kScreenW, height: kCycleViewH)
        
        return cycleView
    }()
    
    fileprivate lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
}
// MARK:- 设置UI
extension RecommendViewController {
    override func setupUI () {
        
        super.setupUI()
        
        //2.将cycleView添加到collectionView中
        collectionView.addSubview(cycleView)
        
        //3.添加gameView
        collectionView.addSubview(gameView)
        
        //4.设置collectionView的内边距 设置内边距的目的是让cycleView显示出来 不然cycleView需要拉伸才能显示
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
}
// MARK:- 请求数据
extension RecommendViewController {
    override func loadData() {
        //0.给父类的vm赋值
        baseVM = recommendVM
        
        // 请求推荐数据
        recommendVM.requestData {
            // 1.显示数据
            self.collectionView.reloadData()
            
            var groups = self.recommendVM.anchorGroups
            
            // 1.移除前两个数据
            groups.removeFirst()
            groups.removeFirst()
            
            // 2.添加 更多 模型
            let moreGroup = AnchorGroupModel()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            
            // 2.将数据传递给gameView
            self.gameView.groups = groups
        }
        
        // 请求无限轮播数据
        recommendVM.requestCycleData { 
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
        
    }
}

extension RecommendViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            
            // 1.取出PrettyCell
            let prettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionViewPrettyCell
            
            // 2.设置数据
            prettyCell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            
            return prettyCell
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
}
