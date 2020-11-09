//
//  PPBaseResonse.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/14.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPBaseResponse: PPModelConversionClass {
    static func decode(_ decodeData : Any) -> Any {
        if decodeData is String {
            return PPJsonUtil.jsonStringToClassModel(decodeData as! String, self) as! PPBaseResponse
        } else if decodeData is NSDictionary {
            return PPJsonUtil.dictionaryToClassModel(decodeData as! [String : Any], self) as! PPBaseResponse
        } else if decodeData is [[String : Any]] {
            return PPJsonUtil.arrayToClassModel((decodeData as! [[String : Any]]), self) as! [PPBaseResponse]
        } else {
            return PPBaseResponse()
        }
    }
}
