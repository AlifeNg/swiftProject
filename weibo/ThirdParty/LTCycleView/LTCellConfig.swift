//
//  LTCellConfig.swift
//  LTCycleView
//
//  Created by letian on 16/11/7.
//  Copyright © 2016年 cmsg. All rights reserved.
//

import UIKit

class LTCellConfig: NSObject {
    
    
    
    /// 轮图文字对齐方式,默认左对齐
    var textAlginType : NSTextAlignment = .left
    
    /// 是否显示阴影,默认不显示
    var isShowShadow = false
    
    /// 是否显示轮播文字
    var isShowText = false
    
    /// 遮罩层颜色,默认黑色透明度0.35
    var shaowBackGroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
    
    /// 轮播文字颜色
    var textColor = UIColor.white

}
