//
//  PPJsonUtil.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/14.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit
import HandyJSON

class PPJsonUtil: NSObject {
    
    /// JSON字符串转对象
    /// - Parameters:
    ///   - jsonStr: JSON字符传
    ///   - modleType: 类
    static func jsonStringToClassModel(_ jsonStr : String,_ modleType : HandyJSON.Type) -> PPModelConversionClass {
        if jsonStr == "" || jsonStr.count == 0 {
            print("JSON字符串为空")
            return PPModelConversionClass()
        }
        return modleType.deserialize(from: jsonStr) as! PPModelConversionClass
    }
    
    /// JSON数组转对象
    /// - Parameters:
    ///   - jsonArrayStr: JSON数组
    ///   - modelType: 类
    static func jsonArrayToClassModel(_ jsonArrayStr : String,_ modelType : HandyJSON.Type) -> [PPModelConversionClass] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            print("JSON数组字符串为空")
            return []
        }
        var modelArray : [PPModelConversionClass] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let propertyArray = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for property in propertyArray! {
            modelArray.append(dictionaryToClassModel(property as! [String : Any], modelType))
        }
        return modelArray
    }
    
    /// 数组转对象
    /// - Parameters:
    ///   - jsonArray: 数组
    ///   - modelType: 类
    static func arrayToClassModel(_ dataArray : [[String : Any]]? = [[:]],_ modelType : HandyJSON.Type) -> [PPModelConversionClass] {
        var modelArray : [PPModelConversionClass] = []
        for property in dataArray! {
            modelArray.append(dictionaryToClassModel(property, modelType))
        }
        return modelArray
    }
    
    /// 字典转对象
    /// - Parameters:
    ///   - dictionay: 字典
    ///   - modelType: 类
    static func dictionaryToClassModel(_ dictionay : [String : Any],_ modelType : HandyJSON.Type) -> PPModelConversionClass {
        if dictionay.count == 0 {
            return PPModelConversionClass()
        }
        return modelType.deserialize(from: dictionay) as! PPModelConversionClass
    }
    
    /// 对象转JSON
    /// - Parameter model: 对象
    static func classModelToJSON(_ model : PPModelConversionClass?) -> String {
        if model == nil {
            return ""
        }
        return (model?.toJSONString())!
    }
    
    /// 对象转字典
    /// - Parameter model: 对象
    static func classModelToDictionary(_ model : PPModelConversionClass?) -> [String : Any] {
        if model == nil {
            return [:]
        }
        return (model?.toJSON())!
    }
}
