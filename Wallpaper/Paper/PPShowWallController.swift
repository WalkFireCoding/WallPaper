//
//  PPShowWallController.swift
//  Wallpaper
//
//  Created by yishen on 2020/11/3.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit
import SVProgressHUD

class PPShowWallController: UIViewController {
    fileprivate var wallImageView = UIImageView()
    fileprivate var imageDataArray : [String]
    fileprivate var currentIndex  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        installView()
        // Do any additional setup after loading the view.
    }
    init(imageArray : [String], index : NSInteger) {
        self.imageDataArray = imageArray
        self.currentIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PPShowWallController {
    fileprivate func installView() {
        SVProgressHUD.setDefaultStyle(.dark)
        self.view.backgroundColor = .clear
        wallImageView = UIImageView.init()
        wallImageView.isUserInteractionEnabled = true
        wallImageView.contentMode = .scaleAspectFit
        wallImageView.kf.setImage(with: URL.init(string: imageDataArray[currentIndex]))
        let leftRecognize = UISwipeGestureRecognizer(target: self, action: #selector(handleWallImageWith(recongnize:)))
        leftRecognize.direction = .left
        wallImageView.addGestureRecognizer(leftRecognize)
        let rightRecognize = UISwipeGestureRecognizer(target: self, action: #selector(handleWallImageWith(recongnize:)))
        rightRecognize.direction = .right
        wallImageView.addGestureRecognizer(rightRecognize)
        let downRecognize = UISwipeGestureRecognizer(target: self, action: #selector(handleWallImageWith(recongnize:)))
        downRecognize.direction = .down
        wallImageView.addGestureRecognizer(downRecognize)
        let upRecognize = UISwipeGestureRecognizer(target: self, action: #selector(handleWallImageWith(recongnize:)))
        upRecognize.direction = .up
        wallImageView.addGestureRecognizer(upRecognize)
        let tapRecognize = UITapGestureRecognizer(target: self, action: #selector(tapGusetureRecognizeAction))
        wallImageView.addGestureRecognizer(tapRecognize)
        self.view.addSubview(wallImageView)
        wallImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        let downloadButton = UIButton(type: .custom)
        downloadButton.setBackgroundImage(UIImage(named: "downLoad"), for: .normal)
        downloadButton.addTarget(self, action: #selector(downLoadButtonClick), for: .touchUpInside)
        self.view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}

extension PPShowWallController {
    @objc fileprivate func handleWallImageWith(recongnize : UISwipeGestureRecognizer) {
        if recongnize.direction == .left || recongnize.direction == .up {
            nextWall(direct: recongnize.direction)
        }else if recongnize.direction == .right || recongnize.direction == .down {
            lastWall(direct: recongnize.direction)
        }
    }
    
    @objc fileprivate func tapGusetureRecognizeAction() {
        dismiss(animated: true, completion: nil)
    }
    fileprivate func nextWall(direct : UISwipeGestureRecognizer.Direction) {
        if currentIndex >= imageDataArray.count - 1 {
            return
        }
        currentIndex += 1
        print(currentIndex)
        //4. 转场动画
        let transition = CATransition()
        transition.type = CATransitionType(rawValue: "reveal")
        transition.subtype = direct == UISwipeGestureRecognizer.Direction.up ? CATransitionSubtype.fromTop : CATransitionSubtype.fromRight
        transition.duration = 0.6
        wallImageView.kf.setImage(with: URL.init(string: imageDataArray[currentIndex]))
        wallImageView.layer.add(transition, forKey: "transition")
    }
    
    fileprivate func lastWall(direct : UISwipeGestureRecognizer.Direction) {
        if currentIndex == 0 {
            return
        }
        currentIndex -= 1
        print(currentIndex)
        //[["fade", "moveIn"], ["push", "reveal"], ["cube", "oglFlip"], ["pageCurl", "pageUnCurl"]]
        //4. 转场动画
        let transition = CATransition()
        transition.type = CATransitionType(rawValue: "reveal")
        transition.subtype = direct == UISwipeGestureRecognizer.Direction.down ? CATransitionSubtype.fromBottom : CATransitionSubtype.fromLeft
        transition.duration = 0.6
        wallImageView.kf.setImage(with: URL.init(string: imageDataArray[currentIndex]))
        wallImageView.layer.add(transition, forKey: "transition")
    }
    
    @objc fileprivate func downLoadButtonClick() {
        downloadImage(url: imageDataArray[currentIndex].replacingOccurrences(of: "720x1280", with: "\(kScreenSize!.width)x\(kScreenSize!.height)"))
    }
    
    func downloadImage(url : String!) -> Void {
        PPNetworkManager.downloadImageWith(URL: url, progressBlock: { (progress) in
            SVProgressHUD.showProgress(Float(progress), status: "下载中...")
            SVProgressHUD.dismiss(withDelay: 1)
        }, completionBlock: { (result) in
            PPWallPaperSetTool.shareInstance().saveAndAsScreenPhoto(with: result as! UIImage, imageScreen: UIImageScreenHome) { (finish) in
                if finish {
                    SVProgressHUD.showSuccess(withStatus: "保存成功")
                }else{
                    SVProgressHUD.showError(withStatus: "保存失败")
                }
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }) { (error) in
            
        }
    }
}

//MARK: JunBrowserDismissDelegate
extension PPShowWallController: JunBrowserDismissDelegate{
    func imageViewForDismiss() -> UIImageView {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        
        //设置图片
        imageV.image = wallImageView.image
        imageV.frame = wallImageView.convert(wallImageView.frame, to: UIApplication.shared.keyWindow)
        
        return imageV
    }
    
    func indexPathForDismiss() -> IndexPath {
        return IndexPath(item: currentIndex, section: 0)
    }
}
