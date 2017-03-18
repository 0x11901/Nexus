//
//  Extensions.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

extension NSAlert {
     class func alertModal(messageText: String,informativeText: String,firstButtonTitle: String,secondButtonTitle: String?,thirdButtonTitle: String?,firstButtonReturn: ( () -> () )?,secondButtonReturn: ( () -> () )?,thirdButtonReturn: ( () -> () )?) {
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
        }else if act == NSAlertSecondButtonReturn && secondButtonReturn != nil {
            secondButtonReturn!()
        }else if act == NSAlertThirdButtonReturn && thirdButtonReturn != nil {
            thirdButtonReturn!()
        }
        
    }
}
