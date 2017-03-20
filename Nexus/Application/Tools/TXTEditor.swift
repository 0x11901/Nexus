//
//  TXTEditor.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class TXTEditor: NSObject {
    class func writeToOutput(txt: String,fileName: String) {
        guard let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Output/" + fileName + ".txt").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) else {
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "请截图并联系开发者\n未知错误2", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            try txt.write(to: url, atomically: true, encoding: .utf8)
        }catch{
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "写\(fileName).txt入/Users/你/Documents/Output/发生错误\n请截图并联系开发者\n\(error)", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        }
    }
}

/*
 Error Domain=NSCocoaErrorDomain Code=4 "The folder “cases3_0_dat.txt” doesn’t exist." UserInfo={NSFilePath=/Users/WangJingkai/Documents/Output/cases3_0_dat.txt, NSUserStringVariant=Folder, NSUnderlyingError=0x60800024d3e0 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
 */
