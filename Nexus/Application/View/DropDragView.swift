//
//  DropDragView.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/20.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class DropDragView: NSView {
    public var getDraggingFilePath: (([String]) -> Void)?
    public lazy var fileNamesField: NSTextField = {
        let textField: NSTextField = NSTextField()
        textField.textColor = NSColor.colorWithHex(hex: 0xFFFFFF)
        textField.backgroundColor = NSColor.colorWithHex(hex: 0x36CF4E)
        textField.stringValue = "请拖入一个或多个txt文件"
        textField.placeholderString = "请拖入一个或多个txt文件"
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

extension DropDragView {
    fileprivate func setupUI() {
        layer?.backgroundColor = NSColor.colorWithHex(hex: 0x36CF4E).cgColor

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

extension DropDragView {
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
