//
//  ViewController.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/15.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import HandyJSON

var respObj = HomeModel()
var table = UITableView()
var categoryArray = Array<Any>()

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HomeTableFirstCellDelegete,HomeTableSecondCellDelegate,HomeTableThirdCellDelegate,HomeTableFouthcellDelegate {
    //MARK:轮播图
    var bannerView : LTCycleView = {
        let cellConfig = LTCellConfig()
        cellConfig.textAlginType = .center
        cellConfig.isShowShadow = true
        cellConfig.isShowText   = false
        //传nil启用默认设置
        let cycleView = LTCycleView.cycleViewFormXib(cellConfigStyle: nil)
        cycleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 170)
        //设置pageControl的对齐方式
        cycleView.pageControlAlginType = .center
        cycleView.autoScrollTime = 2
        //点击的回调
        cycleView.addCallBack({ (idx : Int) in
            print(idx)
        });
        return cycleView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI
        initView()
        //请求数据
        initData()
    }
    //MARK:UI
    func initView() {
        self.automaticallyAdjustsScrollViewInsets = false
        table = UITableView(frame:self.view!.bounds,style: UITableViewStyle.grouped)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        table.tableHeaderView = bannerView
        table.register(HomeTableFirstCell.self, forCellReuseIdentifier: "fistCell")
        let secondCellNib = UINib(nibName: "HomeTableSecondCell", bundle: nil)
        table.register(secondCellNib, forCellReuseIdentifier: "secondCell")
        let thirdCellNib = UINib(nibName:"HomeTableThirdCell",bundle:nil)
        table.register(thirdCellNib, forCellReuseIdentifier: "thirdCell")
        table.register(HomeTableFouthcell.self, forCellReuseIdentifier: "fouchCell")
    }
    //MARK:数据请求
    func initData() {
        //Alamofire请求数据
        Alamofire.request("http://yiapi.xinli001.com/fm/home-list.json", method: .get, parameters: ["key":"c0d28ec0954084b4426223366293d190"]).responseJSON{
            response in
            //print(response);
            //handyJSON解析数据模型
            respObj = JSONDeserializer <HomeModel>.deserializeFrom(dict:response.result.value as! NSDictionary?)!
            var bannerImgArray = Array<String>()
            var bannerTitleArray = Array<String>()
            for info in (respObj.data?.tuijian)!{
                bannerTitleArray.append((info.title)!)
                bannerImgArray.append((info.cover)!)
            }
            self.bannerView.urlImgArr = bannerImgArray
            self.bannerView.textArr = bannerTitleArray
            
            for info in (respObj.data?.category)!{
                categoryArray.append(info)//分类数据
            }
            table.reloadData()
        }
    }
    //MARK:table DataSouce
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //MARK:table Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let firstCell = HomeTableFirstCell(style:UITableViewCellStyle.default,reuseIdentifier:"firstCell")
        let secondCell = table.dequeueReusableCell(withIdentifier: "secondCell") as! HomeTableSecondCell
        let thirdCell = table.dequeueReusableCell(withIdentifier: "thirdCell") as! HomeTableThirdCell
        let fouchCell = HomeTableFouthcell(style:UITableViewCellStyle.default,reuseIdentifier:"fouchCell")
        firstCell.selectionStyle = UITableViewCellSelectionStyle.none
        secondCell.selectionStyle = UITableViewCellSelectionStyle.none
        thirdCell.selectionStyle = UITableViewCellSelectionStyle.none
        fouchCell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.section == 0 {
            firstCell.setMenuUIWithAry(ary: categoryArray)
            firstCell.delegate = self
            return firstCell
        }
        if indexPath.section == 1 {
            if (respObj.data != nil) {
                secondCell.setUIWithInfo(info: respObj.data!)
                secondCell.delegate = self
            }
            return secondCell
        }
        if indexPath.section == 2 || indexPath.section == 3 {
            if (respObj.data != nil) {
                thirdCell.indexPath = indexPath
                thirdCell.setUIWithModel(model: respObj.data!)
                thirdCell.delegate = self
            }
            return thirdCell
        }
        if indexPath.section == 4 {
            if (respObj.data != nil){
                fouchCell.setUIWithArray(model: respObj.data!)
                fouchCell.delegate = self
            }
            return fouchCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 170
        }
        if indexPath.section == 1 {
            return 145
        }
        if indexPath.section == 2 || indexPath.section == 3 {
            return 175
        }
        return 100
    }
    //MARK:去除table的 foot
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    //MARK:table header设置
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeaderView = HomeTableHeaderView.newHeader()
        let titleArray = ["","热门推荐","最新心理课","最新FM","心理电台推荐"]
        tableHeaderView?.titleLabel.text = titleArray[section]
        if section == 0 {
            return nil
        }
        if section == 2 || section == 4 {
            tableHeaderView?.colorLabel.backgroundColor = UIColor.init(colorLiteralRed: 100/255, green: 202/255, blue: 170/255, alpha: 1.0)
        }
        return tableHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0001;
        }
        return 30
    }
    
    //MARK:delegate
    //MARK:分类delegate
    func selectedSubMenuItem(index: NSInteger) {
        print(index)
        let catagoryViewController = CategoryViewController()
        catagoryViewController.model = respObj.data?.category?[index]
        self.navigationController?.pushViewController(catagoryViewController, animated: true)
    }
    //MARK:热门推荐delegate
    func selectedHotTJItemWithTag(tag: NSInteger) {
        let fmVc = FMPlayerViewController()
        let detailInfo = respObj.data?.hotfm?[tag]
        fmVc.url = (detailInfo?.url)!
        fmVc.FMBgImage = detailInfo?.background
        fmVc.FMTitle = detailInfo?.title
        fmVc.FMNumber = detailInfo?.viewnum
        self.navigationController?.pushViewController(fmVc, animated: true)
    }
    //MARK:最新心理课
    func selectedNewLessonWithTag(tag: NSInteger) {
        let fmVc = FMPlayerViewController()
        let detailInfo = respObj.data?.newlesson?[tag]
        fmVc.url = (detailInfo?.url)!
        fmVc.FMBgImage = detailInfo?.cover
        fmVc.FMTitle = detailInfo?.title
        fmVc.FMNumber = detailInfo?.viewnum
        self.navigationController?.pushViewController(fmVc, animated: true)
    }
    //MARK:最新FM
    func selectedNewFMWithTag(tag: NSInteger) {
        let fmVc = FMPlayerViewController()
        let detailInfo = respObj.data?.newfm?[tag]
        fmVc.url = (detailInfo?.url)!
        fmVc.FMBgImage = detailInfo?.cover
        fmVc.FMTitle = detailInfo?.title
        fmVc.FMNumber = detailInfo?.viewnum
        self.navigationController?.pushViewController(fmVc, animated: true)
    }
    //MARK:电台推荐
    func selectedFMItem(index: NSInteger) {
        print(index)
    }
}
