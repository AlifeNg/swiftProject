//
//  CategoryModel.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/19.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit
import HandyJSON

class CategorySubModel: HandyJSON {
    
    var id : String?
    var title : String?
    var cover : String?
    var url : String?
    var speak : String?
    var favnum : String?
    var viewnum : String?
    var is_teacher : String?
    var absolute : String?
    var status : String?
    var object_id : String?
    
    required init() {}
}

class CategoryModel: HandyJSON {
    var code : String?
    var data : [CategorySubModel]?
    
    required init() {}
}


