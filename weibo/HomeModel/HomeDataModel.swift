//
//  HomeDataModel.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/15.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit
import HandyJSON

class HomeDataModel: HandyJSON {
    
    var tuijian : [HomeDataInfoModel]?
    var category : [HomeDataInfoModel]?
    var hotfm : [HomeDataInfoModel]?
    var newfm : [HomeDataInfoModel]?
    var newlesson : [HomeDataInfoModel]?
    var diantai :  [HomeDataInfoModel]?
    required init() {}
}
