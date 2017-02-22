//
//  ZFPageStyle.swift
//  ZFPageView
//
//  Created by zhangzhifu on 2017/2/21.
//  Copyright © 2017年 seemygo. All rights reserved.
//

import UIKit

struct ZFPageStyle {
    
    var titleHeight : CGFloat = 44 // 标题view的高度
    var normalColor: UIColor = UIColor.white // 文本普通颜色
    var selectedColor : UIColor = UIColor.orange // 文本选中颜色
    var titleFont : UIFont = UIFont.systemFont(ofSize: 14) // 文本字体大小
    var isScrollEnabled : Bool = false // 是否能够滚动
    var titleMargin : CGFloat = 20 // 能滚动的情况下,文字的间距
}
