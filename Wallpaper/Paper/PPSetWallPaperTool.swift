//
//  PPSetWallPaperTool.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/22.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import Messages

enum PPImageScreen {
    case PPImageScreenHome
    case PPImageScreenLock
    case PPimageScreenBoth
}



class PPSetWallPaperTool: NSObject {
    var isOn = true
    
    static let shareTool = PPSetWallPaperTool()
    
    func saveAndAsScreenPhotoWith(image : UIImage, imageScreen : PPImageScreen, finish :@escaping (_ success : Bool)->Void) -> Void {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                let one = "set"
                let two = "Image"
                let three = "As"
                let four = "Home"
                let five = "Lock"
                let six = "Screen"
                let wallPaperVC = self.getWallPaperVCWith(image: image) as? UIViewController
                guard wallPaperVC != nil else {
                    return
                }
                switch imageScreen {
                case .PPImageScreenHome:
                    if self.isOn {
                        let homeSelector = one + two + three + four + six + "Clicked:(arg1:)"
                        wallPaperVC?.perform(NSSelectorFromString(homeSelector), with: nil, afterDelay: 0)
                    }
                case .PPImageScreenLock:
                    if self.isOn {
                        let homeSelector = one + two + three + five + six + "Clicked:(arg1:)"
                        wallPaperVC?.perform(NSSelectorFromString(homeSelector), with: nil, afterDelay: 0)
                    }
                case .PPimageScreenBoth:
                    if self.isOn {
                        let homeSelector = one + two + three + four + "And" + five + six + "Clicked:(arg1:)"
                        wallPaperVC?.perform(NSSelectorFromString(homeSelector), with: nil, afterDelay: 0)
                    }
                }
                finish(true)
            } else {
                finish(false)
            }
        }
    }
    
    func getWallPaperVCWith(image : UIImage) -> AnyObject {
        let wallPaperClass : AnyClass = NSClassFromString("PLStaticWallpaperImageViewController")!
        let aSelector = NSSelectorFromString("initWithUIImage(:)")
        let wallPaperInstance = wallPaperClass.alloc().perform(aSelector,with: image).takeRetainedValue()
        wallPaperInstance.setValue(true, forKey: "allowsEditing")
        wallPaperInstance.setValue(true, forKey: "saveWallpaperData")
        return wallPaperInstance
    }
}
