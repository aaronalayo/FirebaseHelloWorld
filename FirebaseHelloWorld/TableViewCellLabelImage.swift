//
//  TableViewCellLabelImage.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 17/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit

class TableViewCellLabelImage: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bodyView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
