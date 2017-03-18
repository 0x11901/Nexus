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

extension dragDropView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pboard = sender.draggingPasteboard()
        self.print(pboard.types ?? "")
        
//        if (pboard.types?.contains(NSFilenamesPboardType))! {
//            return NSDragOperation.copy
//        }
        
        self.print("hello")
        return NSDragOperation()
    }
    
//    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
//        let pboard = sender.draggingPasteboard()
//        let list = pboard.propertyList(forType: NSFilenamesPboardType)
//        self.print(list ?? "")
//        return true
//    }
}














