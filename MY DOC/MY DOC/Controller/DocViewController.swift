//
//  DocViewController.swift
//  MY DOC
//
//  Created by Sushant on 02/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import SVProgressHUD

class DocViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var noDataLabel: UILabel!
    private let service = GTLRDriveService()
    var alertController = UIAlertController()
    @IBOutlet weak var listTableView: UITableView!
    private var doneFetchingFiles = true
    private var nextPageToken: String!
    var query : GTLRQuery!
    var fileResult: [File] = [File].init()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.listTableView.register(UINib(nibName: Constant.FileCell, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier)
        self.service.authorizer = FileViewModel.shared().user.authentication.fetcherAuthorizer()
        self.listTableView.isHidden = true
        self.noDataLabel.isHidden = true
        self.listFiles()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Fetch  Files Methods
    
    func listFiles() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 13
        query.pageToken = nextPageToken
        self.service.executeQuery(query,
                                  delegate: self,
                                  didFinish: #selector( self.displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    
    @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                       finishedWithObject result : GTLRDrive_FileList,
                                       error : NSError?) {
        SVProgressHUD.dismiss()
        if let error = error {
            let alert = UIAlertController().showAlert(title: "Error", message: error.debugDescription)
            self.present(alert, animated: true, completion: nil)
            self.noDataLabel.isHidden = false
            return
        }
        
        if  result.nextPageToken?.count ?? 0 > 0 {
            self.doneFetchingFiles = false
        }else {
            self.doneFetchingFiles = true
        }
        
        if let files = result.files, !files.isEmpty {
            self.nextPageToken = result.nextPageToken
            FileViewModel.shared().getFile(filesArray: result.files ?? []) { fileArray in
                self.fileResult.append(contentsOf: fileArray)
                self.listTableView.isHidden = false
                self.listTableView.reloadData()
            }
        } else {
            self.doneFetchingFiles = true
        }
    }
    
    // MARK: - Tableview Delegate And Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.listTableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier, for: indexPath) as? FileViewCell {
            cell.configureCell(fileResult: self.fileResult[indexPath.row])
            cell.closure = { result in
                self.startDownload(cell)
            }
            return cell
        }
        return FileViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        self.query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: self.fileResult[indexPath.row].id ?? "")
        service.executeQuery(query) { (ticket, file, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                if let fileData = file as? GTLRDataObject {
                    if  let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.DocDetailViewController) as? DocDetailViewController {
                        detailsViewController.fileDetail = self.fileResult[indexPath.row]
                        detailsViewController.fileData = fileData.data as Data
                        self.navigationController?.pushViewController(detailsViewController, animated: true)
                    }
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.listTableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height-50) {
                if !doneFetchingFiles {
                    listFiles()
                }
            }
        }
    }
    
    
   
     func startDownload(_ sender: FileViewCell) {
       // textView.text.append("\n Download Started")
        let url = URL.init(string: "https://www.dropbox.com/s/r6lr4zlw12ipafm/SpeedTracker_movie.mov?dl=1")
        let downloadManager = DownloadManager.shared
        downloadManager.tableId = 1200
        downloadManager.folderPath = "video"
        //sender.progressView.progress
        let downloadTaskLocal =  downloadManager.activate().downloadTask(with: url!)
        downloadTaskLocal.resume()
        downloadManager.onProgress = { (row, tableId, progress) in
             DispatchQueue.main.async {
                sender.progressView.setProgress(progress, animated: true)
            }
        }
    }
}


