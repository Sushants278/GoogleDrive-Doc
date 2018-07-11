//
//  Util.swift
//  MY DOC
//
//  Created by Sushant on 02/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getPathExtension() -> String {
        return (self as NSString).pathExtension
    }
}

// MARK: - Get UIImage

extension UIImage {
    
   class func getImage(fileName : String ) -> UIImage {
        let fileExtn = fileName.getPathExtension()
        switch fileExtn {
        case "png" :
            return UIImage.init(named: "png") ?? UIImage()
        case "jpg" ,"jpeg":
            return UIImage.init(named: "jpg") ?? UIImage()
        case "doc", "docx" :
            return UIImage.init(named: "doc") ?? UIImage()
        case "pdf" :
            return UIImage.init(named: "pdf") ?? UIImage()
        case "ppt","pptx" :
            return UIImage.init(named: "ppt") ?? UIImage()
        case "xls":
            return UIImage.init(named: "xls") ?? UIImage()
        case "txt":
            return UIImage.init(named: "txt") ?? UIImage()
        default:
            return UIImage.init(named: "other") ?? UIImage()
        }
    }
}

// MARK: - Common Alert Controller

extension UIAlertController {
    func showAlert(title : String, message: String) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        
        return alert
    }
}
