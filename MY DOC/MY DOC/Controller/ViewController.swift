//
//  ViewController.swift
//  MY DOC
//
//  Created by Sushant on 01/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import SVProgressHUD

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    var alertController = UIAlertController()
    private let scopes = [kGTLRAuthScopeDrive]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLbl.text = Constant.headerLblText
        GIDSignIn.sharedInstance().scopes = scopes
    }
    
    // MARK: - SignIn Method
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        if let error = error {
            self.showAlert(title: "Error", message: error.localizedDescription)
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.dismiss()
            if  let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.DocViewIdentifier) as? DocViewController {
                //detailsViewController.googleUser = user
                FileViewModel.shared().user = user
                self.navigationController?.pushViewController(detailsViewController, animated: true)
            }
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        SVProgressHUD.dismiss()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        var alert = UIAlertController()
        alert = alert.showAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
}

