//
//  HomeTableFirstCell.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/16.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit

protocol HomeTableFirstCellDelegete : NSObjectProtocol {
    func selectedSubMenuItem(index:NSInteger)
}

class HomeTableFirstCell: UITableViewCell {
    
    var contentView_Back = UIView()
    var subMenuView = UIView()
    var img = UIImageView()
    var lab = UILabel()
    var buton = UIButton()
    
    weak var delegate : HomeTableFirstCellDelegete?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let w = UIScreen.main.bounds.size.width as CGFloat
        let btnSize =  CGSize(width:50, height:50)
        let labSize = CGSize(width:50,height:20)
        let viewSize=CGSize(width:50, height:btnSize.height+labSize.height)
        
        let leftMargin = 30.0 as CGFloat
        
        let contentView_W = w - leftMargin*2
        
        
        contentView_Back = UIView.init(frame: CGRect(x:leftMargin,y:10 as CGFloat,width:contentView_W,height:170 as CGFloat))
        self.contentView.addSubview(contentView_Back)
        
        // 中间view的间隔
        let MiddleMargin=(contentView_W-viewSize.width*4)/3 as CGFloat
        let ary=["自我成长","情绪管理","人际沟通","恋爱婚姻","职场管理","亲子家庭","心理科普","课程讲座"]
        
        
        for i in 0...1{
            for j in 0...3{
                
                subMenuView = UIView();
                //麻个痹。我也看不懂是怎么写的了
                subMenuView.frame = CGRect(x:CGFloat(Float(j))*viewSize.width+CGFloat(Float(j))*MiddleMargin, y:CGFloat(Float(i))*viewSize.height+CGFloat(Float(i))*10, width:viewSize.width,height:viewSize.height)
                contentView_Back.addSubview(subMenuView)
                subMenuView.tag=i*4+j+100;
                
                img = UIImageView();
                img.frame = CGRect(x:0,y:0,width:btnSize.width,height:btnSize.height)
                img.tag=20;
                subMenuView.addSubview(img)
                
                lab = UILabel()
                lab.frame = CGRect(x:0,y:img.frame.maxY ,width:labSize.width,height:labSize.height)
                subMenuView.addSubview(lab)
                
                lab.textAlignment = NSTextAlignment.center;
                lab.textColor = UIColor.init(colorLiteralRed: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0)
                lab.tag=21
                lab.font = UIFont.systemFont(ofSize: 12.0)
                if(i == 0){
                    lab.text=ary[j];
                }else {
                    lab.text=ary[j+4];
                }
                buton = UIButton.init(type: UIButtonType.custom)
                buton.frame=subMenuView.bounds
                buton.tag=i*4+j+200;
                subMenuView.addSubview(buton)
                buton.addTarget(self, action: #selector(selectedSubmenu(_:)), for: UIControlEvents.touchUpInside)
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //button点击事件
    func selectedSubmenu(_ sender:UIButton){
        if delegate != nil {
            delegate!.selectedSubMenuItem(index: sender.tag - 200)
        }
    }
    //设置UI
    func setMenuUIWithAry(ary:Array<Any>){
        for i in 0...7{
            let subMenu = self.contentView.viewWithTag(i+100)
            let img1 : (UIImageView) = subMenu!.viewWithTag(20) as! (UIImageView)
            let lab1 : (UILabel) = subMenu!.viewWithTag(21) as! (UILabel)
            
            if ary.count > i {
                let info : HomeDataInfoModel = ary[i] as! HomeDataInfoModel
                lab1.text = (info.name)!
                let url = URL(string:(info.cover)!)
                img1.kf.setImage(with: url)
            }
        }
    }
    
}
