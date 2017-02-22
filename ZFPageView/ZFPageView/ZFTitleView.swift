//
//  ZFTitleView.swift
//  ZFPageView
//
//  Created by zhangzhifu on 2017/2/21.
//  Copyright © 2017年 seemygo. All rights reserved.
//

import UIKit

// 表示该协议只能被类遵守
protocol ZFTitleViewDelegate : class {
    func titleView(_ titleView : ZFTitleView, targetIndex : Int)
}

class ZFTitleView: UIView {
    // MARK: 属性
    weak var delegate : ZFTitleViewDelegate?
    fileprivate var titles : [String]
    fileprivate var style : ZFPageStyle
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate var currentIndex : Int = 0
    
    // MARK: 构造函数
    init(frame: CGRect, titles: [String], style: ZFPageStyle) {
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension ZFTitleView {
    fileprivate func setupUI() {
        // 1. 添加UIScrollView
        addSubview(scrollView)
        
        // 2. 初始化所有的labels
        setupTitleLabels()
        
        // 3. 设置所有label的frame
        
    }
    
    private func setupTitleLabels() {
        // 1. 创建labels
        for (i, title) in titles.enumerated() {
            // 1. 创建UIlabel
            let titleLabel = UILabel()
            
            // 2. 设置label的属性
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectedColor : style.normalColor
            titleLabel.font = style.titleFont
            titleLabel.isUserInteractionEnabled = true
            
            // 3. 将label添加到scrollView
            scrollView.addSubview(titleLabel)
            
            // 4. 监听label的点击
            // #selector(方法名称)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            
            // 5. 将label添加到数组中
            titleLabels.append(titleLabel)
        }
        
        // 2. 设置label的frame
        let labelH : CGFloat = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = bounds.width / CGFloat(titles.count)
        var labelX : CGFloat = 0
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isScrollEnabled {
                labelW = (titleLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : style.titleFont], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else {
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        // 4. 设置contentSize
        if style.isScrollEnabled {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
    }
}

// MARK:- 点击事件监听
extension ZFTitleView {
    // ?. 可选链
    func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 0. 校验label是否有值
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        
        // 1. 判断是否是之前点击的label
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        // 2. 让之前的label不选中,让新的label选中
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
        
        // 3. 让新的tag作为currentIndex
        currentIndex = targetLabel.tag
        
        // 4. 调整点击label的位置,滚动到中间去
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offsetX, y: 0), animated: true)
        
        // 5. 通知代理
        // 可选连: 如果可选类型有值,则执行代码,如果没有值,什么事情都不会发生
        delegate?.titleView(self, targetIndex: currentIndex)
    }
}
