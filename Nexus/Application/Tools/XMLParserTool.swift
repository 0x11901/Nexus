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
    
    func parse(filePath: String) {
        getXML(filePath: filePath)
        parseXML()
    }
    
}

extension XMLParserTool: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        NSLog("parserDidStartDocument...");
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        NSLog("parserDidEndDocument...");
    }
    
}

extension XMLParserTool {
    
    fileprivate func parseXML() {
        if XML != nil {
            let parser = XMLParser(data: XML!)
            parser.delegate = self
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
