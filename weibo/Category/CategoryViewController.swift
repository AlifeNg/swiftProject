//
//  CategoryViewController.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/19.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON
import ESPullToRefresh

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var table = UITableView()
    var offset : NSInteger = 0
    var model : HomeDataInfoModel?
    var dataArray : Array<CategorySubModel>?
    var categoryModel : CategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    
    func initView(){
        self.view.backgroundColor = UIColor.white
        self.title = self.model?.name
        self.dataArray = Array()
        self.automaticallyAdjustsScrollViewInsets = false
        self.table = UITableView.init(frame: CGRect(x:0,y:64,width:(self.view?.bounds.width)!,height:(self.view?.bounds.height)!-64), style: UITableViewStyle.plain)
        self.table.delegate = self;
        self.table.dataSource = self;
        self.view.addSubview(self.table)
        
        let nib = UINib(nibName:"CategoryListCell",bundle:nil)
        self.table.register(nib, forCellReuseIdentifier: "CategoryListCell")
        
        //MARK:下拉刷新上拉加载
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        let _ = self.table.es_addPullToRefresh(animator: header){
            [weak self] in
            self?.offset = 0
            self?.dataArray?.removeAll()
            self?.initData()
        }
        
        let _ = self.table.es_addInfiniteScrolling(animator: footer){
             [weak self] in self?.loadMore()
        }
    }
    
    func initData() {
        let key : Dictionary = ["key" : "c0d28ec0954084b4426223366293d190","offset":String(offset),"category_id":(self.model?.id!)! as String,"limit":"20"]
        Alamofire.request("http://yiapi.xinli001.com/fm/category-jiemu-list.json", method: .get, parameters: key).responseJSON{
            response in
            self.categoryModel = JSONDeserializer<CategoryModel>.deserializeFrom(dict: response.result.value as! NSDictionary?)
            for info : CategorySubModel in (self.categoryModel?.data)!{
                self.dataArray?.append(info)
            }
            //MARK:停止刷新
            self.table.es_stopPullToRefresh(completion: true)
            self.table.es_stopLoadingMore()
            self.table.reloadData()
        }
    }
    
    //MARK:load more
    func loadMore() {
        offset += 20
        initData()
    }
    
    //MARK:table delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.dataArray?.count)!>0 {
            return (self.dataArray?.count)!
        }
        return 0;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CategoryListCell = self.table.dequeueReusableCell(withIdentifier: "CategoryListCell") as! CategoryListCell
        if (self.dataArray?.count)! > 0 {
            let info : CategorySubModel = self.dataArray![indexPath.row]
            cell.titleLabel.text = (info.title)!
            cell.speakLabel.text = (info.speak)!
            cell.listenNumber.text = (info.viewnum)!
            let url = URL(string:(info.cover)!)
            cell.icon.kf.setImage(with: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
