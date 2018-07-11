//
//  DocDetailViewController.swift
//  MY DOC
//
//  Created by Sushant on 02/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import SVProgressHUD

class DocDetailViewController: UIViewController {
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var ViewDocButton: UIButton!
    @IBOutlet weak var docImageView: UIImageView!
    private let service = GTLRDriveService()
    var docController: UIDocumentInteractionController?
    var fileData : Data!
    var query : GTLRQuery?
    var fileDetail : File?
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.docNameLbl.text = self.fileDetail?.name
        self.docImageView.image = UIImage.getImage(fileName: (self.fileDetail?.name) ?? "doc")
        self.service.authorizer = FileViewModel.shared().user.authentication.fetcherAuthorizer()
        self.saveFileInLocal()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            self.clearTempFile()
            self.fileData = nil
        }
    }
    
    // MARK: - Save And Delete File From Sandbox
    
    func saveFileInLocal() {
        if fileData.count > 0 {
            let filePath = "\(self.documentsPath)/\(self.fileDetail?.name ?? "")"
            do {
                try fileData.write(to: URL.init(fileURLWithPath: filePath))
                self.fileData = nil
            }catch {
                print("error while file saving")
            }
        }
    }
    
    func clearTempFile() {
        guard let items = try? FileManager.default.contentsOfDirectory(atPath: self.documentsPath) else { return }
        for item in items {
            let completePath = self.documentsPath.appending("/").appending(item)
            try? FileManager.default.removeItem(atPath: completePath)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func viewDocButtonClicked(_ sender: Any) {
        if  let readerViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.DocReaderViewController) as? DocReaderViewController {
            readerViewController.filePath = self.fileDetail?.name
            self.navigationController?.pushViewController(readerViewController, animated: true)
        }
    }
}
