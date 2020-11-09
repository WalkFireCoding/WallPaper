//
//  PPBaseRequest.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/14.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPBaseRequest: PPModelConversionClass {
    var methodUrl : String?
    var method : String?
    var timeoutIntervalForRequest : Int! = 60
}
