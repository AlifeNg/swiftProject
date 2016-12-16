//
//  HomeTableSecondCell.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/16.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit

class HomeTableSecondCell: UITableViewCell {

    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
//    override func encode(with aCoder: NSCoder) {
//        
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    func setUIWithInfo(info:HomeDataModel){
        if (info.hotfm?.count)!>0 {
            let detail = info.hotfm?[0]
            title1.text = detail?.title
            let url = URL(string:(detail?.cover)!)
            img1.kf.setImage(with: url)
        }
        if (info.hotfm?.count)!>1 {
            let detail = info.hotfm?[1]
            title2.text = detail?.title
            let url = URL(string:(detail?.cover)!)
            img2.kf.setImage(with: url)
        }
        if (info.hotfm?.count)!>2 {
            let detail = info.hotfm?[2]
            title.text = detail?.title
            let url = URL(string:(detail?.cover)!)
            img3.kf.setImage(with: url)
        }
        
    }
    
}
