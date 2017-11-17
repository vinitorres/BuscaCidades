//
//  DetailsViewController.swift
//  BuscaCidades
//
//  Created by Vinicius Torres on 11/17/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var pointsLbl: UILabel!
    
    var textPoints = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pointsLbl.text = textPoints
        
    }


}
