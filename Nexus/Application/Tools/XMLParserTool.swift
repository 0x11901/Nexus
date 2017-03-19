//
//  XMLParserTool.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/19.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class XMLParserTool: NSObject {
    fileprivate var XML: Data?
    fileprivate var XMLName: String = ""
    
    fileprivate var targetTexts: [TargetTextModel] = []
    fileprivate var lastSourceText: String = ""
    fileprivate var currentSourceText: String = ""
    fileprivate var line: Int = 0
    
    fileprivate var currentElementName: String = ""
    
    func parse(filePath: String) {
        XMLName = (filePath as NSString).lastPathComponent
        getXML(filePath: filePath)
        parseXML()
    }
    
}

extension XMLParserTool: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        NSLog("parserDidStartDocument...");
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Data" {
            currentElementName = elementName
            currentSourceText = ""
        }else{
            currentElementName = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementName.characters.count > 0 {
            currentSourceText = currentSourceText + string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == currentElementName {
            if currentSourceText.characters.count > 0 {
                if lastSourceText == currentSourceText {
                    line = line + 1
                    let obj = TargetTextModel(sourceText: lastSourceText, targetText: currentSourceText, line: line, flag: nil)
                    targetTexts.append(obj)
                }else{
                    lastSourceText = currentSourceText
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if targetTexts.count == 0 {
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "解析\(self.XMLName)时提取文本算法出错，请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil);
            }
        }else{
            for obj in targetTexts {
                NSLog(obj.targetText)
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        DispatchQueue.main.async {
            NSAlert.alertModal(messageText: "警告⚠️", informativeText: "解析\(self.XMLName)发生错误：\(parseError)\n请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
        }
    }
    
}

extension XMLParserTool {
    
    fileprivate func parseXML() {
        if XML != nil {
            let parser = XMLParser(data: XML!)
            parser.delegate = self
            parser.parse()
        }
    }
    
    fileprivate func getXML(filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            try XML = Data(contentsOf: fileURL)
        }catch{
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "读取\((filePath as NSString).lastPathComponent)错误，请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        }
    }
    
}
