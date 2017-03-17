//
//  dragDropView.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/18.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class dragDropView: NSView {

    override func awakeFromNib() {
        self.registerDraggedEvent()
        layer?.backgroundColor = NSColor.cyan.cgColor
        self.needsDisplay = true
    }
    
}

extension dragDropView {
    
    fileprivate func registerDraggedEvent() {
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
}
