//
//  FileViewCell.swift
//  MY DOC
//
//  Created by Sushant on 02/06/18.
//  Copyright © 2018 Striker. All rights reserved.
//

import UIKit
import UtilityFramework

class FileViewCell: UITableViewCell {
    @IBOutlet weak var fileNameLbl: UILabel!    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadBtn: UIButton!
    var closure : ((Bool) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //self.progressView.progress = 0.0
        // Configure the view for the selected state
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        closure?(true)
        
    }
    
    func configureCell(fileResult: File ){
        self.imgView.image = UIImage.getImage(fileName: fileResult.name ?? "doc")
        self.fileNameLbl.text = fileResult.name
    }
}
