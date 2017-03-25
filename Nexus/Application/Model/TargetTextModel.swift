//
//  TargetTextModel.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class TargetTextModel: NSObject {
    var sourceText: String = ""
    var targetText: String = ""
    var flag: Int = -1
    var line: Int = -1
    
    convenience init(sourceText: String,targetText: String,line: Int = -1,flag: Int = -1) {
        self.init()
        self.sourceText = sourceText
        self.targetText = targetText
        self.flag = flag
        self.line = line
    }
}

extension TargetTextModel {
    func appendLine() {
        targetText = String(format: "@ROW:%04d@", line) + targetText
    }
}
