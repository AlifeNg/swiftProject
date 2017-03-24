//
//  HomeTableFouthcell.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/16.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit

protocol HomeTableFouthcellDelegate : NSObjectProtocol{
    func selectedFMItem(index:NSInteger)
}

class HomeTableFouthcell: UITableViewCell {
    
    var delegate : HomeTableFouthcellDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let w = UIScreen.main.bounds.size.width as CGFloat
        
        let bgView = UIView.init(frame: CGRect(x:0,y:0,width:w,height:150))
        bgView.tag = 1000;
        self.contentView.addSubview(bgView)
        for i in 0...3{
            let subView = UIView()
            subView.frame = CGRect(x:CGFloat(Float(i)) * w/CGFloat(Float(4)),y:0,width:w/CGFloat(Float(4)),height:100)
            subView.tag = i+100
            bgView.addSubview(subView)
            
            let img = UIImageView()
            img.frame = CGRect(x:10,y:10,width:w/CGFloat(Float(4))-20,height:60)
            img.clipsToBounds = true
            img.layer.cornerRadius = 31;
            img.tag = 20;
            subView.addSubview(img)
            
            let title = UILabel()
            title.frame = CGRect(x:10,y:img.frame.maxY,width:img.frame.width,height:20)
            title.textAlignment = NSTextAlignment.center
            title.font = UIFont.systemFont(ofSize: 10)
            title.tag = 30
            subView.addSubview(title)
            
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = subView.bounds
            button.tag = i+500;
            subView.addSubview(button)
            button.addTarget(self, action: #selector(touchFM(_:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    
    func touchFM(_ sender:UIButton) {
        if delegate != nil {
            delegate?.selectedFMItem(index: sender.tag - 500)
        }
    }
    
    func setUIWithArray(model:HomeDataModel) {
        let bgView : UIView = self.contentView.viewWithTag(1000)!
        for i in 0...3{
            let subMenu : UIView = bgView.viewWithTag(i+100)!
            let img : UIImageView = subMenu.viewWithTag(20)! as! UIImageView
            let name : UILabel = subMenu.viewWithTag(30)! as! UILabel
            
            let info : HomeDataInfoModel = model.diantai![i]
            name.text = info.title
            let url = URL(string:(info.cover)!)
            img.kf.setImage(with: url)
        }
    }
}
