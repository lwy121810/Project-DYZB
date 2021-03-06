//
//  GameViewController.swift
//  Project-DYZB
//
//  Created by liweiyou on 17/3/7.
//  Copyright © 2017年 yons. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 10
private let kItemW : CGFloat = (kScreenW - 2 * kEdgeMargin) / 3
private let kItemH : CGFloat = kItemW * 6 / 5
private let kHeaderViewH : CGFloat = 50

private let kGameViewH : CGFloat = 90

private let kGameCellID = "kGameCellID"
private let kHeaderViewID = "kHeaderViewID"
class GameViewController: UIViewController {

    fileprivate  lazy var collectionView : UICollectionView = {[weak self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdgeMargin, bottom: 0, right: kEdgeMargin)
        //设置头部size
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self!.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.register(UINib(nibName: "RecommendGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        collectionView.dataSource = self
        return collectionView
    }()
    
    fileprivate  lazy var gameVM : GameViewModel = GameViewModel()
    
    fileprivate  lazy var topHeaderView : CollectionHeaderView = {
        
        let headerView = CollectionHeaderView.collectionHeaderView()
        headerView.frame = CGRect(x: 0, y: -(kHeaderViewH + kGameViewH), width: kScreenW, height: kHeaderViewH)
        headerView.iconView.image = UIImage(named: "Img_orange")
        headerView.titleLabel.text = "常见"
        headerView.moreButton.isHidden = true
        return headerView
    }()
    
    fileprivate lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

}
// MARK:- 设置UI
extension GameViewController {
    fileprivate func setupUI() {
        // 1.添加UICollectionView
        view.addSubview(collectionView)
        
        // 2.添加顶部的HeaderView
        collectionView.addSubview(topHeaderView)
        
        
        // 3.将常用游戏的View,添加到collectionView中
        collectionView.addSubview(gameView)
        
        // 设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: kHeaderViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
}
// MARK:- 请求数据
extension GameViewController {
    fileprivate func loadData() {
        gameVM.loadAllGameData {
            //1.展示全部游戏
            self.collectionView.reloadData()
            
            //2.展示常用游戏
//            let groups = self
            //取出前10条数据就是
            let temp = self.gameVM.gameModelArray[0..<10]
            self.gameView.groups = Array(temp)
            
        }
    }
}

// MARK:- 遵守UICollectionView的数据源&代理
extension GameViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameVM.gameModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! RecommendGameCell
        
        cell.baseGame = gameVM.gameModelArray[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        // 2.给HeaderView设置属性
        headerView.titleLabel.text = "全部"
        headerView.iconView.image = UIImage(named: "Img_orange")
        headerView.moreButton.isHidden = true
        
        return headerView
    }
}
