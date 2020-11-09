//
//  PPGetPaperClassificationRequest.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/16.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPGetPaperClassificationRequest: PPBaseRequest {
    var adult = false
    var first = 1
    
    required init() {
        super.init()
        self.methodUrl = "http://service.picasso.adesk.com/v1/vertical/category"
    }
}
