//
//  TXTEditor.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class TXTEditor: NSObject {
    
    var importIsFinished: (() -> ())?
    fileprivate var txtName = ""
    fileprivate var xmlPath = ""
    fileprivate var TXT: Data?
    fileprivate var txtArray: [String] = []
    
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

extension TXTEditor {
    
    func importTXT(filePath: String,xmlPath: String) {
        txtName = (filePath as NSString).lastPathComponent
        self.xmlPath = xmlPath
        getTXT(filePath: filePath)
        parseTXT()
    }
    
    fileprivate func getTXT(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            try TXT = Data(contentsOf: fileURL)
        }catch{
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "读取\((filePath as NSString).lastPathComponent)错误，请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        }
    }
    
    fileprivate func parseTXT() {
        if TXT != nil {
            
            if var txt: String = String(data: TXT!, encoding: .utf8) {
                txt = txt.replacingOccurrences(of: "\n", with: "")
                txt = txt.replacingOccurrences(of: "\r", with: "")
                var i = 0;
                while true {
                    let start = txt.range(of: String(format: "@ROW:%04d@", i))
                    i += 1
                    let end = txt.range(of: String(format: "@ROW:%04d@", i))
                    if let sb = start?.upperBound,let eb = end?.lowerBound {
                        let el = txt.substring(with: sb ..< eb)
                        txtArray.append(el)
                    }else if start?.upperBound != nil {
                        let el = txt.substring(from: start!.upperBound)
                        txtArray.append(el)
                        break
                    }else{
                        DispatchQueue.main.async {
                            NSAlert.alertModal(messageText: "警告⚠️", informativeText: "解析\(self.txtName)错误，请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
                        }
                        break
                    }
                }
                NSLog(xmlPath, txtArray.last ?? "")
            }
        }
    }
}













