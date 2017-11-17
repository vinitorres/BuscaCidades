//
//  ResultTableViewCell.swift
//  BuscaCidades
//
//  Created by Vinicius Torres on 11/16/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet var nomeCidade: UILabel!
    @IBOutlet var estadoCidade: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
