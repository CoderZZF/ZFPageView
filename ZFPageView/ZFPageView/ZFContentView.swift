//
//  ZFContentView.swift
//  ZFPageView
//
//  Created by zhangzhifu on 2017/2/21.
//  Copyright © 2017年 seemygo. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"

class ZFContentView: UIView {
    // MARK: 属性
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        
        return collectionView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension ZFContentView {
    fileprivate func setupUI() {
        // 1. 将childVcs中的所有控制器添加到父控制器
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        
        // 2. 给collectionView添加属性
        addSubview(collectionView)
    }
}


// MARK:- 遵守UICollectionViewDataSource
extension ZFContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1. 获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 2. 添加内容
        // 2.1 将之前的内容删除掉
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        // 2.2 将对应的view添加到cell中
        let childVc = childVcs[indexPath.item]
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- 遵守UICollectionViewDelegate
extension ZFContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


// MARK:- 遵守ZFTitleViewDelegate协议
extension ZFContentView : ZFTitleViewDelegate {
    func titleView(_ titleView: ZFTitleView, targetIndex: Int) {
        // 1. 根据index创建indexPath
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        // 2. 滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
