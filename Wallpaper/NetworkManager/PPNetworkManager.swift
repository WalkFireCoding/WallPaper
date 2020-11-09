//
//  PPNetworkManager.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/16.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPNetworkManager {
    
    /// 获取壁纸分类
    /// - Parameters:
    ///   - completionBlock: 成功回调
    ///   - errorBlock: 失败回调
    static func queryPaperClassificationWith(completionBlock:@escaping PPNetworkSuccessBlock, errorBlock:@escaping PPNetworkFailBlock) {
        let request = PPGetPaperClassificationRequest.init()
        PPNetworkClass.shareNetwork.getNetworkWith(request: request, successBlock: { (result) in
            completionBlock(result)
        }) { (error) in
            errorBlock(error)
        }
    }
    
    /// 查询分类壁纸详情
    /// - Parameters:
    ///   - id: 分类ID
    ///   - completionBlock: 成功回调
    ///   - errorBlock: 失败回调
    static func queryClassificationDetailWith(_ start : Int? = 1, id: String!, completionBlock:@escaping PPNetworkSuccessBlock, errorBlock:@escaping PPNetworkFailBlock) {
        let request = PPGetClassificationDetailRequest()
        request.methodUrl = request.getCategoryDetailURL(categoryID: id)
        request.skip = (start! - 1) * 50
        PPNetworkClass.shareNetwork.getNetworkWith(request: request, successBlock: { (result) in
            completionBlock(result)
        }) { (error) in
            errorBlock(error)
        }
    }
    
    /// 查询最新壁纸
    /// - Parameters:
    ///   - start: 偏移
    ///   - completionBlock: 成功回调
    ///   - errorBlock: 失败回调
    static func queryLatestPaperWith(start : Int? = 1, completionBlock:@escaping PPNetworkSuccessBlock, errorBlock:@escaping PPNetworkFailBlock) {
        let request = PPGetLatestPaperRequest()
        request.skip = (start! - 1) * 50
        PPNetworkClass.shareNetwork.getNetworkWith(request: request, successBlock: { (result) in
            completionBlock(result)
        }) { (error) in
            errorBlock(error)
        }
    }
    
    static func downloadImageWith(URL: String!, progressBlock:@escaping PPNetworkProgressBlock, completionBlock:@escaping PPNetworkSuccessBlock, errorBlock:@escaping PPNetworkFailBlock) {
        PPNetworkClass.shareNetwork.downLoadWith(URL: URL, progressBlock: progressBlock, successBlock: completionBlock, errorBlock: errorBlock)
    }
}
