//
//  DragDropView.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/18.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class DragDropView: NSView {
    public var getDraggingFilePath: (([String]) -> Void)?
    public lazy var fileNamesField: NSTextField = {
        let textField: NSTextField = NSTextField()
        textField.textColor = NSColor.colorWithHex(hex: 0xFFFFFF)
        textField.backgroundColor = NSColor.colorWithHex(hex: 0x367FE6)
        textField.stringValue = "请拖入一个或多个xml文件"
        textField.placeholderString = "请拖入一个或多个xml文件"
        textField.isBordered = false
        textField.isHidden = true
        textField.isEditable = false
        return textField
    }()

    override func awakeFromNib() {
        setupUI()
        registerDraggedEvent()
    }
}

extension DragDropView {
    fileprivate func setupUI() {
        layer?.backgroundColor = NSColor.colorWithHex(hex: 0x367FE6).cgColor
        addSubview(fileNamesField)
        fileNamesField.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.edges.equalTo(self).inset(10)
        }
    }

    fileprivate func registerDraggedEvent() {
        register(forDraggedTypes: [NSFilenamesPboardType])
    }
}

extension DragDropView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if let pboardTypes = sender.draggingPasteboard().types {
            if pboardTypes.contains(NSFilenamesPboardType) {
                return NSDragOperation.copy
            }
        }
        return NSDragOperation.generic
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if getDraggingFilePath != nil {
            if let list = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as? [String], getDraggingFilePath != nil {
                getDraggingFilePath!(list)
            }
        }
        return true
    }
}
