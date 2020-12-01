//
//  PPHomeController.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/16.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

let kScreenWith = UIScreen.main.bounds.size.width
let kScreenHeigt = UIScreen.main.bounds.size.height
let kScreenSize = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? UIScreen.main.currentMode?.size : CGSize(width: 0, height: 0)

class PPHomeController : UIViewController {
    var currentOffset = 1
    var paperCollectionView : UICollectionView!
    var latestButton : UIButton!
    var classificationButton : UIButton!
    var isPullUp = false
    var classificationArray : [PPGetPaperClassificationResponse]? = Array()
    var showArray : [String]? = Array()
    
    var currentID = ""
    fileprivate lazy var photoAnimation = PhotoBrowseAnimation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        installTitleView()
        installCollectionView()
        queryClassification()
        queryLatest()
    }
    
}

@objc extension PPHomeController : PPCollectionViewFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource, PPClassificationListControllerDelegate {
    @nonobjc func selectClassification(classification: PPGetPaperClassificationResponse) {
        currentOffset = 1
        showArray?.removeAll()
        if classification.id.count > 0 {
            self.title = classification.name
            paperCollectionView.tag = 102
            currentID = classification.id
            queryClassificationDetailList()
        } else {
            self.title = "推荐"
            paperCollectionView.tag = 101
            queryLatest()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaperCell", for: indexPath)
        let paperImage = UIImageView()
        paperImage.tag = 1000 + indexPath.item
        paperImage.contentMode = .scaleAspectFit
//        paperImage.clipsToBounds = true
        paperImage.kf.indicatorType = .activity
        paperImage.kf.setImage(with: URL(string: showArray![indexPath.item]), options: [.transition(.fade(0.5))])
        cell.addSubview(paperImage)
        paperImage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = collectionView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        let lastRow = collectionView.numberOfItems(inSection: section) - 1
        if row == lastRow {
            isPullUp = true
            currentOffset += 1
            if collectionView.tag == 101 {
                queryLatest()
            } else {
                queryClassificationDetailList()
            }
            
        }
        
    }
    
    func columnOfWaterFall(_ collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func waterFall(_ collectionView: UICollectionView, layout waterFallLayout: PPCollectionViewFlowLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return (kScreenWith - 32) / 3 * (kScreenSize!.height / kScreenSize!.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showVC = PPShowWallController.init(imageArray: showArray!, index: indexPath.item)
        //2. 设置弹出样式为自定义
        showVC.modalPresentationStyle = .custom
        //3. 设置转场动画代理
        showVC.transitioningDelegate = photoAnimation
        //4. 设置broseAnimation的属性
        photoAnimation.setProperty(indexPath: indexPath, self, showVC)
        //5. 弹出图片浏览器
        present(showVC, animated: true, completion: nil)
    }
}

//初始化页面
extension PPHomeController {
    func installTitleView() {
        self.title = "推荐";
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "分类"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonClick(sender:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func installCollectionView() {
        let layout = PPCollectionViewFlowLayout.init(lineSpacing: 8, columnSpacing: 8.5, sectionInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        layout.columnCount = 2
        layout.delegate = self
        paperCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        paperCollectionView.showsHorizontalScrollIndicator = false
        paperCollectionView.delegate = self
        paperCollectionView.dataSource = self
        paperCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PaperCell")
        paperCollectionView.backgroundColor = .clear
        paperCollectionView.tag = 101
        self.view.addSubview(paperCollectionView)
        paperCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

//点击事件
@objc extension PPHomeController {
    func rightButtonClick(sender : UIButton) -> Void {
        let listVC = PPClassificationListController()
        listVC.listArray = classificationArray
        listVC.delegate = self
        self.present(listVC, animated: true, completion: nil)
    }
}

//网络请求
extension PPHomeController {
    fileprivate func queryClassification() -> Void {
        PPNetworkManager.queryPaperClassificationWith(completionBlock: { (result) in
            let resultDic = (result as! [String : Any])["category"] as! [Any]
            self.classificationArray = PPGetPaperClassificationResponse.decode(resultDic) as? [PPGetPaperClassificationResponse]
        }) { (error) in
            
        }
    }
    
    fileprivate func queryLatest() -> Void {
        PPNetworkManager.queryLatestPaperWith(start: currentOffset, completionBlock: { (result) in
            print(result)
            let resultDic = (result as! [String : Any])["vertical"] as! [Any]
            let tempArray = PPGetLatestPaperResponse.decode(resultDic) as? [PPGetLatestPaperResponse]
            for data in tempArray ?? [] {
                data.wp?.append("?imageMogr2/thumbnail/!\(kScreenSize!.width)x\(kScreenSize!.height)r/gravity/Center/crop/\(kScreenSize!.width)x\(kScreenSize!.height)")
                self.showArray?.append(data.wp!)
            }
            self.paperCollectionView.reloadData()
        }) { (error) in
            
        }
    }
    
    fileprivate func queryClassificationDetailList() -> Void {
        PPNetworkManager.queryClassificationDetailWith(currentOffset, id: currentID, completionBlock: { (result) in
            let resultDic = (result as! [String : Any])["vertical"] as! [Any]
            let tempArray = PPGetLatestPaperResponse.decode(resultDic) as? [PPGetLatestPaperResponse]
            for data in tempArray ?? [] {
                data.wp?.append("?imageMogr2/thumbnail/!\(kScreenSize!.width)x\(kScreenSize!.height)r/gravity/Center/crop/\(kScreenSize!.width)x\(kScreenSize!.height)")
                self.showArray?.append(data.wp!)
            }
            self.paperCollectionView.reloadData()
        }) { (error) in
            
        }
    }
}
//MARK: JunBrowsePresentDelefate
extension PPHomeController: JunBrowsePresentDelefate {
    func imageForPresent(indexPath: IndexPath) -> UIImageView {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        //设置图片
        imageV.kf.setImage(with: URL(string: showArray![indexPath.item]))
        return imageV
    }
    
    func startImageRectForpresent(indexPath: IndexPath) -> CGRect {
        // 1.取出cell
        guard let cell = paperCollectionView.cellForItem(at: indexPath) else {
            return CGRect(x: paperCollectionView.bounds.width * 0.5, y: kScreenHeigt + 50, width: 0, height: 0)
        }
        
        // 2.计算转化为UIWindow上时的frame
        return paperCollectionView.convert( cell.frame, to: UIApplication.shared.keyWindow)
    }
    
    func endImageRectForpresent(indexPath: IndexPath) -> CGRect {
       let imageUrl = URL(string: showArray![indexPath.item])
        
        //2.从缓存中取出image
        let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: imageUrl!.absoluteString)
        
        // 3.根据image计算位置
        let imageH = kScreenWith / image!.size.width * image!.size.height
        let y: CGFloat = imageH < kScreenHeigt ? (kScreenHeigt - imageH) / 2 : 0
        
        return CGRect(x: 0, y: y, width: kScreenWith, height: imageH)
    }
}
