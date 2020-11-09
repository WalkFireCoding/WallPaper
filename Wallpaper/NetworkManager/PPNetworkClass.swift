//
//  PPNetworkClass.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/14.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit
import Alamofire

typealias PPNetworkSuccessBlock = (_ result : Any) -> Void
typealias PPNetworkFailBlock = (_ error: String) -> Void
typealias PPNetworkStatusBlock = (_ NetworkStatus: Int32) -> Void
typealias PPNetworkProgressBlock = (_ progress: Double) -> Void

@objc enum NetworkStatus : Int32 {
    case unkown = -1
    case notReachable = 0
    case wwan = 1
    case wifi = 2
}

class PPNetworkClass: NSObject {
    static let shareNetwork = PPNetworkClass()
    private var sessionManager : Session?
    
    /// 初始化配置
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        sessionManager = Session.init(configuration: configuration, delegate: SessionDelegate.init(), serverTrustManager: nil)
    }
    
    /// POST请求
    /// - Parameters:
    ///   - request: 入参Model
    ///   - successBlock: 成功回调
    ///   - errorBlock: 失败回调
    public func postNetworkWith(request : PPBaseRequest, successBlock : @escaping PPNetworkSuccessBlock, errorBlock : @escaping PPNetworkFailBlock) {
        sessionManager?.request(request.methodUrl!, method: .post, parameters: PPJsonUtil.classModelToDictionary(request)).responseData { response in
            switch response.result {
            case .success(let data) :
                let dataDic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                guard dataDic == nil else {
                    if dataDic!["code"] as! Int == 0 {
                        successBlock(dataDic!["res"] ?? [[:]])
                    } else {
                        successBlock("")
                    }
                    return
                }
            case .failure(_) :
                let statusCode = response.response?.statusCode
                errorBlock("\(statusCode ?? 0)请求失败")
            }
        }
    }
    
    /// GET网络请求
    /// - Parameters:
    ///   - request: 入参Model
    ///   - successBlock: 成功回调
    ///   - errorBlock: 失败回调
    public func getNetworkWith(request : PPBaseRequest, successBlock : @escaping PPNetworkSuccessBlock, errorBlock : @escaping PPNetworkFailBlock) {
        sessionManager?.request(request.methodUrl!, method: .get, parameters: PPJsonUtil.classModelToDictionary(request)).responseData { (response) in
            switch response.result {
            case .success(let data) :
                let dataDic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                guard dataDic == nil else {
                    if dataDic!["code"] as! Int == 0 {
                        successBlock(dataDic!["res"] ?? [[:]])
                    } else {
                        successBlock("")
                    }
                    return
                }
            case .failure :
                let statusCode = response.response?.statusCode
                errorBlock("\(statusCode ?? 0)请求失败")
            }
        }
    }
    
    /// 下载网络请求
    /// - Parameters:
    ///   - URL: 下载地址
    ///   - progressBlock: 下载进度
    ///   - successBlock: 成功回调
    ///   - errorBlock: 失败回调
    public func downLoadWith(URL : String, progressBlock : @escaping PPNetworkProgressBlock, successBlock : @escaping PPNetworkSuccessBlock, errorBlock : @escaping PPNetworkFailBlock) {
        sessionManager?.download(URL).downloadProgress { (progress) in
            progressBlock(progress.fractionCompleted)
        }.responseData { (response) in
            switch response.result {
            case .success :
                if let data = response.value {
                   let image = UIImage(data: data)
                    successBlock(image ?? UIImage())
                }
            case .failure :
                let statusCode = response.response?.statusCode
                errorBlock("\(statusCode ?? 0)请求失败")
            }
        }
    }
    
    /// 上传网络请求
    /// - Parameters:
    ///   - uploadFile: 上传的文件URL
    ///   - url: 上传地址
    ///   - progressBlock: 上传进度
    ///   - successBlock: 成功回调
    ///   - errorBlock: 失败回调
    public func uploadDataWith(uploadFile : URL, url : String, progressBlock : @escaping PPNetworkProgressBlock, successBlock : @escaping PPNetworkSuccessBlock, errorBlock : @escaping PPNetworkFailBlock) {
        sessionManager?.upload(uploadFile, to: url).responseData { (response) in
            
        }.uploadProgress { (progress) in
            progressBlock(progress.fractionCompleted)
        }
    }
}
