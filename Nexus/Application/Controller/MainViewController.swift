//
//  MainViewController.swift
//  Nexus
//
//  Created by 王靖凯 on 2017/3/18.
//  Copyright © 2017年 王靖凯. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var parserButton: NSButton!
    @IBOutlet weak var parserView: DragDropView!
    @IBOutlet weak var importView: DropDragView!
    fileprivate var isParsing: Bool = false
    fileprivate var isImporting: Bool = false
    fileprivate var xmls: [String] = []
    fileprivate var txts: [String] = []
    fileprivate var flag: Int = 0
    fileprivate var mark: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.setup()
    }

}

extension MainViewController {
    
    fileprivate func setup() {
        parserView.getDraggingFilePath = {
            ( files: [String] ) in
            self.displayFileName(files: files,isParser: true)
        }
        importView.getDraggingFilePath = {
            ( files: [String] ) in
            self.displayFileName(files: files,isParser: false)
        }
    }
    
}

extension MainViewController {
    
    fileprivate func importTXT() {
        mark = 0
        DispatchQueue.global().async {
            if self.txts.count > 0,self.xmls.count > 0 {
                for txt in self.txts {
                    
                    OperationQueue().addOperation {
                        let editor = TXTEditor()
                        editor.importIsFinished = {
                            self.mark += 1
                            if self.mark == self.txts.count {
                                self.isImporting = false
                            }
                        }
                        editor.importTXT(filePath: txt)
                    }
                }
            }else{
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
    
    fileprivate func displayFileName(files: [String],isParser: Bool) {
        if isParser {
            self.xmls = []
            for file in files {
                if file.hasSuffix(".xml") {
                    self.xmls.append(file)
                }
                if self.xmls.count > 0 {
                    var names: String = ""
                    for name in self.xmls {
                        let nsString: NSString = name as NSString
                        names.append(nsString.lastPathComponent)
                        names.append("\n")
                    }
                    self.parserView.fileNamesField.stringValue = names
                    self.parserView.fileNamesField.isHidden = false
                }else{
                    self.importView.fileNamesField.isHidden = false
                    self.parserView.fileNamesField.stringValue = "仅支持xml文档"
                }
            }
        }else{
            self.txts = []
            for file in files {
                if file.hasSuffix(".txt") {
                    self.txts.append(file)
                }
                if self.txts.count > 0 {
                    var names: String = ""
                    for name in self.txts {
                        let nsString: NSString = name as NSString
                        names.append(nsString.lastPathComponent)
                        names.append("\n")
                    }
                    self.importView.fileNamesField.stringValue = names
                    self.importView.fileNamesField.isHidden = false
                }else{
                    self.importView.fileNamesField.isHidden = false
                    self.importView.fileNamesField.stringValue = "仅支持txt文档"
                }
            }
        }
    }
}

// MARK: - parserButtonAction
extension MainViewController {
    
    @IBAction func startParser(_ sender: NSButton) {
        if isParsing == false {
            self.parseXML()
           isParsing = true
        }
    }
    
    @IBAction func improtAction(_ sender: NSButton) {
//        if isImporting == false {
            self.importTXT()
//            isImporting = true
//        }
    }
    
}

