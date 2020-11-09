//
//  PPGetLatestPaperRequest.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/16.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPGetLatestPaperRequest: PPBaseRequest {
    var adult = false
    var first = 0
    var limit = 120
    var order = "hot"
    var skip : Int? = 0
    
    required init() {
        super.init()
        self.methodUrl = "http://service.picasso.adesk.com/v1/vertical/vertical"
    }
}
