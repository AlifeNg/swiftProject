//
//  LTCycleView.swift
//  LTCycleView
//
//  Created by letian on 16/11/6.
//  Copyright © 2016年 cmsg. All rights reserved.
//

import UIKit

private let pageCount = 10000
private let kCycleCellID = "LTCycleCell"
private let defaultAutoTime : TimeInterval = 3

class LTCycleView: UIView {
    
    /// xib控件
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pageControlRightConstrant: NSLayoutConstraint!
    /// end
    
    /// 设置回调
    typealias Handler = ((_ idx: Int) -> ())
    var callBack : Handler?
    
    /// 回到方法
    func addCallBack(_ callBack : @escaping Handler) {
        self.callBack = callBack
    }
    
    enum TextAlginType {
        case left,right,center
    }
    
    /// page对齐方式,默认右对齐
    var pageControlAlginType : TextAlginType = .right {
        willSet{
            switch newValue {
            case .right:
                
                break
                
            case .left:
      
                //在父试图上将iSinaButton距离屏幕左边的约束删除
                self.removeConstraint(pageControlRightConstrant)
                let leftConstraint = NSLayoutConstraint(item: pageControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10)
                self.addConstraint(leftConstraint)
                break
                
            case .center:
                self.removeConstraint(pageControlRightConstrant)
                let centerConstraint = NSLayoutConstraint(item: pageControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
                self.addConstraint(centerConstraint)
                
                break
                
            }
        }
    }
    
    var cellConfig = LTCellConfig()
    
    
    /// 默认page颜色,默认亮灰色
    var pageColor = UIColor.lightGray {
        didSet {
            pageControl.pageIndicatorTintColor = pageColor
        }
    }
    
    /// 当前page颜色,默认白色
    var currentPageColor = UIColor.white {
        didSet{
           pageControl.currentPageIndicatorTintColor = currentPageColor
        }
    }

    /// 轮播总数
   fileprivate var allCount : Int = 0
    
    /// 本地资源数组
    var localImgArr : [String]? {
        didSet{
            settingPageCount(count: localImgArr?.count ?? 0)
        }
    }
    /// 轮播资源数组
    var urlImgArr : [String]?{
        didSet{
            settingPageCount(count: urlImgArr?.count ?? 0)
        }
    }
    
    /// 轮播文字数组
    var textArr : [String]?
    
    /// 定时器
    fileprivate var cycleTimer : Timer?
    
    /// 自动轮播时间
    var autoScrollTime : TimeInterval = defaultAutoTime {
        didSet{
            if (allCount <= 1) { return }
            removeCycleTimer()
            addCycleTimer()
        }
        
    }

    
    // MARK: 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.isHidden = true
        pageControl.numberOfPages = 0
        
        // 注册Cell
        collectionView.register(UINib(nibName: kCycleCellID, bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
    }
    
    // MARK: - 设置itemLayout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
}

// MARK: - 从xib返回LTCycleView
extension LTCycleView {
    class func cycleViewFormXib(cellConfigStyle : LTCellConfig?) -> LTCycleView {
        let cycleView = Bundle.main.loadNibNamed("LTCycleView", owner: nil, options: nil)?.first as! LTCycleView
        guard let cellConfigStyle = cellConfigStyle else{ return cycleView }
        cycleView.cellConfig = cellConfigStyle
        return cycleView
    }
}

// MARK: - 设置page数量
extension LTCycleView {
    fileprivate func settingPageCount(count: Int) -> () {
        self.layoutIfNeeded()
        allCount = count
        collectionView.reloadData()
        if ( count <= 1 ) { return }
        
        pageControl.isHidden = false
        pageControl.numberOfPages = count
        
        let indexPath = IndexPath(item: count*10, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        removeCycleTimer()
        addCycleTimer()
    }
}

// MARK:- 实现UICollectionViewDataSource的代理协议
extension LTCycleView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCount == 1 ? 1 : allCount * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! LTCycleCell
        cell.backgroundColor = (indexPath.item % 2) == 0 ? UIColor.yellow : UIColor.green
        
        var textString = ""
        if textArr?.count == allCount {
            textString  = textArr![indexPath.row % (textArr?.count ?? 1)]
        } else {
            print("textArr不匹配,请设置与图片数量相同的textArr")
        }
        
        
        
        if localImgArr?.count ?? 0 > 0 {
            cell.cellLocalData(imgString: localImgArr![indexPath.row % (localImgArr?.count ?? 1)], content: textString , cellConfig : cellConfig)
        } else {
            cell.cellData(urlString: urlImgArr![indexPath.row % (urlImgArr?.count ?? 1)], content: textString , cellConfig : cellConfig)
        }
        
        
        return cell
    }
}

// MARK:- 实现UICollectionView的代理协议
extension LTCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % allCount
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if allCount <= 1 { return }
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if allCount <= 1 { return }
        addCycleTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (callBack != nil) {
            callBack!(indexPath.item % allCount)
        }
        
    }
}


// MARK:- 定时器
extension LTCycleView {
    fileprivate func addCycleTimer() {
        cycleTimer = Timer(timeInterval: autoScrollTime, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc fileprivate func scrollToNext() {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
