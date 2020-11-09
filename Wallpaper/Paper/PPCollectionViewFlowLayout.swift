//
//  PPCollectionViewFlowLayout.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/21.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

@objc protocol PPCollectionViewFlowLayoutDelegate {
    func columnOfWaterFall(_ collectionView : UICollectionView) -> Int
    func waterFall(_ collectionView : UICollectionView, layout waterFallLayout : PPCollectionViewFlowLayout, heightForItemAt indexPath : IndexPath) -> CGFloat
}

class PPCollectionViewFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: PPCollectionViewFlowLayoutDelegate?
    
    var columnCount = 3
    var columnSpacing : CGFloat = 0
    var lineSpacing : CGFloat = 0
    var sectionInsets : UIEdgeInsets = UIEdgeInsets.zero
    var sectionTop : CGFloat = 0 {
        willSet {
            sectionInsets.top = newValue
        }
    }
    var sectionBottom : CGFloat = 0 {
        willSet {
            sectionInsets.bottom = newValue
        }
    }
    var sectionLeft : CGFloat = 0 {
        willSet {
            sectionInsets.left = newValue
        }
    }
    var sectionRight : CGFloat = 0 {
        willSet {
            sectionInsets.right = newValue
        }
    }
    private var columnHeights : [Int : CGFloat] = [Int : CGFloat]()
    private var attributes : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    init(lineSpacing : CGFloat, columnSpacing : CGFloat, sectionInsets : UIEdgeInsets) {
        super.init()
        self.lineSpacing = lineSpacing
        self.columnSpacing = columnSpacing
        self.sectionInsets = sectionInsets
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override var collectionViewContentSize: CGSize {
        var maxHeight : CGFloat = 0
        for height in columnHeights.values {
            if height > maxHeight {
                maxHeight = height
            }
        }
        return CGSize(width: collectionView?.frame.width ?? 0, height: maxHeight + sectionInsets.bottom)
    }
    override func prepare() {
        super.prepare()
        guard collectionView != nil else {
            return
        }
        if let columnCout = delegate?.columnOfWaterFall(collectionView!) {
            for i in 0..<columnCout {
                columnHeights[i] = sectionInsets.top
            }
        }
        let itemCout = collectionView!.numberOfItems(inSection: 0)
        attributes.removeAll()
        for i in 0..<itemCout {
            if let att = layoutAttributesForItem(at: IndexPath.init(row: i, section: 0)) {
                attributes.append(att)
            }
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let tempCollecitonView = collectionView {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let width = tempCollecitonView.frame.width
            if let tempColumnCout = delegate?.columnOfWaterFall(tempCollecitonView) {
                guard tempColumnCout > 0 else {
                    return nil
                }
                let totalWidth = width - sectionInsets.left - sectionInsets.right - (CGFloat(tempColumnCout) - 1) * columnSpacing
                let itemWidth = totalWidth / CGFloat(tempColumnCout)
                let itemHeight = delegate?.waterFall(tempCollecitonView, layout: self, heightForItemAt: indexPath) ?? 0
                var minIndex = 0
                for column in columnHeights {
                    if column.value < columnHeights[minIndex] ?? 0 {
                        minIndex = column.key
                    }
                }
                let itemX = sectionInsets.left + (columnSpacing + itemWidth) * CGFloat(minIndex)
                let itemY = (columnHeights[minIndex] ?? 0) + lineSpacing
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
                columnHeights[minIndex] = attribute.frame.maxY
            }
            return attribute
        }
        return nil
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}
