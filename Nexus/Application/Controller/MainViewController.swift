//
//  MainViewController.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/18.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet var parserButton: NSButton!
    @IBOutlet var parserView: DragDropView!
    @IBOutlet var importView: DropDragView!
    fileprivate var isParsing: Bool = false
    fileprivate var isImporting: Bool = false
    fileprivate var xmls: [String] = []
    fileprivate var txts: [String] = []
    fileprivate var flag: Int = 0
    fileprivate var mark: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setup()
    }
}

extension MainViewController {
    fileprivate func setup() {
        parserView.getDraggingFilePath = {
            (files: [String]) in
            self.displayFileName(files: files, isParser: true)
        }
        importView.getDraggingFilePath = {
            (files: [String]) in
            self.displayFileName(files: files, isParser: false)
        }
    }
}

extension MainViewController {
    fileprivate func importTXT() {
        mark = 0
        DispatchQueue.global().async {
            if self.txts.count > 0, self.xmls.count > 0 {
                for txt in self.txts {
                    let name = (txt as NSString).lastPathComponent
                    let range: Range = name.range(of: ".txt")!
                    let tf = name.substring(to: range.lowerBound)
                    for xml in self.xmls {
                        let name = (xml as NSString).lastPathComponent
                        let range: Range = name.range(of: ".xml")!
                        let xf = name.substring(to: range.lowerBound)
                        if tf == xf {
                            OperationQueue().addOperation {
                                let editor = TXTEditor()
                                editor.importIsFinished = {
                                    self.mark += 1
                                    if self.mark == self.txts.count {
                                        self.isImporting = false
                                    }
                                }
                                editor.importTXT(filePath: txt, xmlPath: xml)
                            }
                        }
                    }
//                    if self.mark == 0 {
//                        DispatchQueue.main.async {
//                            NSAlert.alertModal(messageText: "xml和txt应该有一样的名字", informativeText: "不匹配", firstButtonTitle: "ok", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
//                        }
//                    }
                }
            } else {
                NSAlert.alertModal(messageText: "need xml and txt!", informativeText: "both are indispensable", firstButtonTitle: "ok", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
            }
        }
    }

    fileprivate func parseXML() {
        flag = 0
        DispatchQueue.global().async {
            if self.xmls.count > 0 {
                for xml in self.xmls {
                    OperationQueue().addOperation {
                        let parser = XMLParserTool()
                        parser.parseIsFinished = {
                            self.flag += 1
                            if self.flag == self.xmls.count {
                                self.isParsing = false
                                DispatchQueue.main.async {
                                    NSAlert.alertModal(messageText: "parser", informativeText: "parser is finished", firstButtonTitle: "done", secondButtonTitle: nil, thirdButtonTitle: nil, firstButtonReturn: nil, secondButtonReturn: nil, thirdButtonReturn: nil)
                                }
                            }
                        }
                        parser.parse(filePath: xml)
                    }
                }
            }
        }
    }

    fileprivate func displayFileName(files: [String], isParser: Bool) {
        if isParser {
            xmls = []
            for file in files {
                if file.hasSuffix(".xml") {
                    xmls.append(file)
                }
                if xmls.count > 0 {
                    var names: String = ""
                    for name in xmls {
                        let nsString: NSString = name as NSString
                        names.append(nsString.lastPathComponent)
                        names.append("\n")
                    }
                    parserView.fileNamesField.stringValue = names
                    parserView.fileNamesField.isHidden = false
                } else {
                    importView.fileNamesField.isHidden = false
                    parserView.fileNamesField.stringValue = "仅支持xml文档"
                }
            }
        } else {
            txts = []
            for file in files {
                if file.hasSuffix(".txt") {
                    txts.append(file)
                }
                if txts.count > 0 {
                    var names: String = ""
                    for name in txts {
                        let nsString: NSString = name as NSString
                        names.append(nsString.lastPathComponent)
                        names.append("\n")
                    }
                    importView.fileNamesField.stringValue = names
                    importView.fileNamesField.isHidden = false
                } else {
                    importView.fileNamesField.isHidden = false
                    importView.fileNamesField.stringValue = "仅支持txt文档"
                }
            }
        }
    }
}

// MARK: - parserButtonAction

extension MainViewController {
    @IBAction func startParser(_: NSButton) {
        if isParsing == false {
            parseXML()
            isParsing = true
        }
    }

    @IBAction func improtAction(_: NSButton) {
//        if isImporting == false {
        importTXT()
//            isImporting = true
//        }
    }
}
