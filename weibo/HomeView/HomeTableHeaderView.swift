//
//  HomeTableHeaderView.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/16.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit

class HomeTableHeaderView: UIView {
    @IBOutlet weak var colorLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func newHeader() -> HomeTableHeaderView? {
        let nibView = Bundle.main.loadNibNamed("HomeTableHeaderView", owner: nil, options: nil);
        if let view = nibView?.first as? HomeTableHeaderView {
            return view
        }
        return nil
    }

}
