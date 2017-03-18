//
//  TargetTextModel.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class TargetTextModel: NSObject {
    var sourceText: String
    var targetText: String
    var flag: String?
    
    init(sourceText: String,targetText: String,flag: String? = nil) {
        self.sourceText = sourceText
        self.targetText = targetText
        self.flag = flag
    }
}
