//
//  HomeTableThirdCell.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/16.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit

class HomeTableThirdCell: UITableViewCell {
    
    var indexPath = IndexPath()
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var titleLab1: UILabel!
    
    @IBOutlet weak var titleLab2: UILabel!
    
    @IBOutlet weak var titleLab3: UILabel!
    
    @IBOutlet weak var speakLab1: UILabel!
    
    @IBOutlet weak var speakLab2: UILabel!
    
    @IBOutlet weak var speakLab3: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUIWithModel(model:HomeDataModel) {
        if self.indexPath.section == 2 {
            //最新心理课
            if (model.newlesson?.count)! > 0 {
                let info = model.newlesson?[0]
                let url = URL(string:(info?.cover)!)
                img1.kf.setImage(with: url)
                titleLab1.text = info?.title
                speakLab1.text = info?.speak
            }
            if (model.newlesson?.count)! > 1 {
                let info = model.newlesson?[1]
                let url = URL(string:(info?.cover)!)
                img2.kf.setImage(with: url)
                titleLab2.text = info?.title
                speakLab2.text = info?.speak
            }
            if (model.newlesson?.count)! > 2 {
                let info = model.newlesson?[2]
                let url = URL(string:(info?.cover)!)
                img3.kf.setImage(with: url)
                titleLab3.text = info?.title
                speakLab3.text = info?.speak
            }
        }
        if self.indexPath.section == 3 {
            //最新FM
            if (model.newfm?.count)! > 0 {
                let info = model.newfm?[0]
                let url = URL(string:(info?.cover)!)
                img1.kf.setImage(with: url)
                titleLab1.text = info?.title
                speakLab1.text = info?.speak
            }
            if (model.newfm?.count)! > 1 {
                let info = model.newfm?[1]
                let url = URL(string:(info?.cover)!)
                img2.kf.setImage(with: url)
                titleLab2.text = info?.title
                speakLab2.text = info?.speak
            }
            if (model.newfm?.count)! > 2 {
                let info = model.newfm?[2]
                let url = URL(string:(info?.cover)!)
                img3.kf.setImage(with: url)
                titleLab3.text = info?.title
                speakLab3.text = info?.speak
            }
        }
    }
    
}
