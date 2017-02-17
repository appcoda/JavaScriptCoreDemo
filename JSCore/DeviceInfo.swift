//
//  DeviceInfo.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol DeviceInfoJSExport: JSExport {
    var model: String! {get set}
    var initialOS: String! {get set}
    var latestOS: String! {get set}
    var imageURL: String! {get set}
    
    static func initializeDevice(withModel: String) -> DeviceInfo
}


class DeviceInfo: NSObject, DeviceInfoJSExport {
    var model: String!
    var initialOS: String!
    var latestOS: String!
    var imageURL: String!
    
    init(withModel model: String) {
        super.init()
        
        self.model = model
    }
    
    class func initializeDevice(withModel: String) -> DeviceInfo {
        return DeviceInfo(withModel: withModel)
    }
    
    func concatOS() -> String {
        if let initial = initialOS {
            if let latest = latestOS {
                return initial + " - " + latest
            }
        }
        
        return ""
    }
}
