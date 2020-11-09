//
//  PPGetClassificationDetailRequest.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/16.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPGetClassificationDetailRequest: PPBaseRequest {
    var adult = false
    var first = 0
    var limit = 120
    var order = "new"
    var skip : Int? = 0
    
    public func getCategoryDetailURL (categoryID : String!) -> String {
        return "http://service.picasso.adesk.com/v1/vertical/category/" + categoryID + "/vertical"
    }
}
