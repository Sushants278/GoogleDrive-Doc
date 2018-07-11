//
//  DocReaderViewController.swift
//  MY DOC
//
//  Created by Sushant on 03/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import UIKit
import WebKit

class DocReaderViewController: UIViewController ,WKUIDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    var filePath: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFile()
    }
    
    func loadFile() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let tempFilePath = paths.appendingPathComponent(self.filePath ?? "")
        self.webView.uiDelegate = self
        let targetURL = URL.init(fileURLWithPath: tempFilePath)
        self.webView.loadFileURL(targetURL, allowingReadAccessTo: targetURL)
    }
}
