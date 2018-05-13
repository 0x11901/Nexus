//
//  Extensions.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

extension NSAlert {
    class func alertModal(messageText: String, informativeText: String, firstButtonTitle: String, secondButtonTitle: String?, thirdButtonTitle: String?, firstButtonReturn: (() -> Void)?, secondButtonReturn: (() -> Void)?, thirdButtonReturn: (() -> Void)?) {
        let alert = NSAlert()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.alertStyle = .warning
        alert.addButton(withTitle: firstButtonTitle)
        if let btn2 = secondButtonTitle {
            alert.addButton(withTitle: btn2)
        }
        if let btn3 = thirdButtonTitle {
            alert.addButton(withTitle: btn3)
        }
        let act = alert.runModal()
        if act == NSAlertFirstButtonReturn && firstButtonReturn != nil {
            firstButtonReturn!()
        } else if act == NSAlertSecondButtonReturn && secondButtonReturn != nil {
            secondButtonReturn!()
        } else if act == NSAlertThirdButtonReturn && thirdButtonReturn != nil {
            thirdButtonReturn!()
        }
    }
}

extension NSColor {
    class func colorWithHex(hex: uint32) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16)
        let green = CGFloat((hex & 0x00FF00) >> 8)
        let blue = CGFloat(hex & 0x0000FF)
        return NSColor(calibratedRed: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
