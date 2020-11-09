//
//  PPGetAssociatedRequest.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/16.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

class PPGetAssociatedRequest: PPBaseRequest {
    public func getAssociatedListURL (paperID : String!) -> String {
        return "http://service.picasso.adesk.com/v2/vertical/vertical/" + paperID + "/comment"
    }
}
