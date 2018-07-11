//
//  FileViewModel.swift
//  MY DOC
//
//  Created by Sushant on 02/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleAPIClientForREST

class FileViewModel {
    
    //Singletone Object
    private static var sharedFileViewModel: FileViewModel = {
        let sharedFileViewModel = FileViewModel()
        return sharedFileViewModel
    }()
    
    class func shared() -> FileViewModel {
        return sharedFileViewModel
    }
    var files: [File] = [File]()
    var user = GIDGoogleUser()
    
    // MARK: - Map Data IN Custome Array

    func getFile(filesArray : [GTLRDrive_File] , completion:@escaping ([File]) -> Void) {
        files.removeAll()
        for file in filesArray {
            var fileTemp = File()
            fileTemp.name = file.name
            fileTemp.kind = file.kind
            fileTemp.mimeType = file.mimeType
            fileTemp.id = file.identifier
            files.append(fileTemp)
        }
        completion(files)
    }
    
    
}
