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

    var parseIsFinished: (() -> Void)?
    fileprivate var mark = 0
    fileprivate var txtArray: [String] = []
    fileprivate var filePath: String = ""

    func parse(filePath: String) {
        XMLName = (filePath as NSString).lastPathComponent
        getXML(filePath: filePath)
        parseXML()
    }

    func replace(filePath: String, txtArray: [String]) {
        self.txtArray = txtArray
        self.filePath = filePath
        getXML(filePath: filePath)
        parseXML()
    }
}

extension XMLParserTool: XMLParserDelegate {
    func parser(_: XMLParser, didStartElement elementName: String, namespaceURI _: String?, qualifiedName _: String?, attributes _: [String: String] = [:]) {
        if elementName == "Data" {
            currentElementName = elementName
            currentSourceText = ""
        } else {
            currentElementName = ""
        }
    }

    func parser(_: XMLParser, foundCharacters string: String) {
        if currentElementName.characters.count > 0 {
            currentSourceText = currentSourceText + string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI _: String?, qualifiedName _: String?) {
        if elementName == currentElementName {
            if currentSourceText.characters.count > 0 {
                if lastSourceText == currentSourceText {
                    let obj = TargetTextModel(sourceText: lastSourceText, targetText: currentSourceText, line: line, flag: parser.lineNumber)
                    obj.appendLine()
                    line = line + 1
                    targetTexts.append(obj)
                } else {
                    lastSourceText = currentSourceText
                }
            }
        }
    }

    func parserDidEndDocument(_: XMLParser) {
        if targetTexts.count == 0 {
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "解析\(self.XMLName)时提取文本算法出错，请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        } else {
            if parseIsFinished != nil {
                parseIsFinished!()
            }
            if txtArray.count < 1 {
                createTXT()
            } else {
                replaceXML()
            }
        }
    }

    func parser(_: XMLParser, parseErrorOccurred parseError: Error) {
        DispatchQueue.main.async {
            NSAlert.alertModal(messageText: "警告⚠️", informativeText: "解析\(self.XMLName)发生错误：\(parseError)\n请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
        }
    }
}

extension XMLParserTool {
    fileprivate func createTXT() {
        var txt: String = ""
        for text in targetTexts {
            txt = txt + text.targetText + "\r\n"
        }
        guard let range: Range = XMLName.range(of: ".xml") else {
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "发生未知错误1", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
            return
        }
        XMLName = XMLName.substring(to: range.lowerBound)
        let name = XMLName
        TXTEditor.writeToOutput(txt: txt, fileName: name)
    }

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
        } catch {
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "警告⚠️", informativeText: "读取\((filePath as NSString).lastPathComponent)错误，请截图并联系开发者", firstButtonTitle: "确定", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        }
    }

    fileprivate func replaceXML() {
        let url = URL(fileURLWithPath: filePath)
        do {
            var xmlDocumet = try String(contentsOf: url)
            var xmls: [String] = []
            while true {
                if let range = xmlDocumet.range(of: "\r\n") {
                    xmls.append(xmlDocumet.substring(to: range.lowerBound))
                    xmlDocumet = xmlDocumet.substring(from: range.upperBound)
                } else {
                    break
                }
            }

            NSLog(xmls.last!)

            for target in targetTexts.enumerated() {
                let i = target.offset
                let el = target.element
                xmls[el.flag - 1] = String(format: "    <Cell><Data ss:Type=\"String\">%@</Data></Cell>", arguments: [txtArray[i]])
            }
            var targetString: String = ""
            for xmltext in xmls {
                targetString = targetString.appending(xmltext.appending("\r\n"))
            }
            TXTEditor.writeToOutput(xml: targetString, fileName: (filePath as NSString).lastPathComponent)
        } catch {
            DispatchQueue.main.async {
                NSAlert.alertModal(messageText: "xml地址错误", informativeText: "导入读取xml地址出错", firstButtonTitle: "ok", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        }
    }
}
