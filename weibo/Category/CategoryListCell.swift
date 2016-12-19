//
//  CategoryListCell.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/19.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var speakLabel: UILabel!
    
    @IBOutlet weak var listenNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
