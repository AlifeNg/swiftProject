//
//  LTCycleCell.swift
//  LTCycleView
//
//  Created by letian on 16/11/6.
//  Copyright © 2016年 cmsg. All rights reserved.
//

import UIKit
import Kingfisher

class LTCycleCell: UICollectionViewCell {
    
              
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var showImgView: UIImageView!
    
    @IBOutlet weak var shaowView: UIView!
    
    func cellData(urlString: String = "" , content: String = "" , cellConfig : LTCellConfig) -> Void {
        settingCell(cellConfig: cellConfig)
        contentLbl.text = content
        let iconURL = URL(string: urlString)!
        showImgView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
    }
    
    func cellLocalData(imgString: String = "" , content: String = "" , cellConfig : LTCellConfig) -> Void {
        settingCell(cellConfig: cellConfig)
        showImgView.image =  UIImage(named: imgString)
        contentLbl.text = content
        
    }
    
    fileprivate func settingCell(cellConfig : LTCellConfig) {
    
        contentLbl.textAlignment = cellConfig.textAlginType
        
        shaowView.isHidden = !cellConfig.isShowShadow
        
        contentLbl.isHidden  = !cellConfig.isShowText
        
        showImgView.backgroundColor = cellConfig.shaowBackGroundColor
        
        contentLbl.textColor = cellConfig.textColor
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
