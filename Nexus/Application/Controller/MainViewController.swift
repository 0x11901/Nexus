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
    fileprivate var xmls: [String] = []
    
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
            self.displayFileName(files: files)
        }
    }
    
}

extension MainViewController {
    
    fileprivate func displayFileName(files: [String]) {
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
                self.parserView.fileNamesField.stringValue = "仅支持xml文档"
            }
        }
    }
    
}

extension MainViewController {
    
    @IBAction func startParser(_ sender: NSButton) {
        
        NSLog("jhagfsghfkashfkjahfahf")
        
    }
    
}

