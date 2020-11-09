//
//  PPClassificationListController.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/21.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

protocol PPClassificationListControllerDelegate {
    func selectClassification(classification : PPGetPaperClassificationResponse)
}
class PPClassificationListController: UIViewController {
    
    var delegate: PPClassificationListControllerDelegate?
    var listCollectionView : UICollectionView!
    var listArray : [PPGetPaperClassificationResponse]? = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        installCollectionView()
    }
}

extension PPClassificationListController {
    func installCollectionView() {
        let layout = PPCollectionViewFlowLayout.init(lineSpacing: 8, columnSpacing: 8.5, sectionInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        layout.columnCount = 2
        layout.delegate = self
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        listCollectionView.showsHorizontalScrollIndicator = false
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "classCell")
        listCollectionView.backgroundColor = .clear
        self.view.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension PPClassificationListController : PPCollectionViewFlowLayoutDelegate {
    func columnOfWaterFall(_ collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func waterFall(_ collectionView: UICollectionView, layout waterFallLayout: PPCollectionViewFlowLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return 127 * (350.0 / 540.0)
    }
}

extension PPClassificationListController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listArray!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classCell", for: indexPath)
        let paperImage = UIImageView()
        paperImage.kf.indicatorType = .activity
        if indexPath.row == 0 {
            paperImage.kf.setImage(with: URL(string: ""), options: [.transition(.fade(0.5))])
        } else {
            paperImage.kf.setImage(with: URL(string: listArray![indexPath.item - 1].cover), options: [.transition(.fade(0.5))])
        }
        cell.addSubview(paperImage)
        paperImage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        let cellTitle = UILabel()
        if indexPath.row == 0 {
            cellTitle.text = "推荐"
        } else {
            cellTitle.text = listArray![indexPath.row - 1].name
        }
        cellTitle.font = UIFont.systemFont(ofSize: 22)
        cellTitle.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        cellTitle.textColor = .white
        cellTitle.textAlignment = .center
        cell.addSubview(cellTitle)
        cellTitle.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.delegate?.selectClassification(classification: PPGetPaperClassificationResponse())
        } else {
            self.delegate?.selectClassification(classification: listArray![indexPath.row - 1])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
