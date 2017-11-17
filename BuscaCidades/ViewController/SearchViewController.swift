//
//  SearchViewController.swift
//  BuscaCidades
//
//  Created by Vinicius Torres on 11/16/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var estadoTF: UITextField!
    @IBOutlet weak var cidadeTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cidadesResult: [Cidade] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
    }
    
    func configureViews() {
        cidadeTF.layer.cornerRadius = 0
        cidadeTF.layer.borderColor = UIColor.black.cgColor
        cidadeTF.layer.borderWidth = 1.0
        
        estadoTF.layer.cornerRadius = 0
        estadoTF.layer.borderColor = UIColor.black.cgColor
        estadoTF.layer.borderWidth = 1.0
        
        searchBtn.layer.cornerRadius = 0
        searchBtn.layer.borderColor = UIColor.black.cgColor
        searchBtn.layer.borderWidth = 1.0
  
        
    }
    
    @IBAction func search(_ sender: Any) {
        
        self.searchBtn.isHidden = true
        self.activityIndicator.startAnimating()
        
        let cidadeForSearch = cidadeTF.text ?? ""
        let estadoForSearch = estadoTF.text ?? ""
        
        Service.getCidadesFiltered(cidadeForSearch ,estadoForSearch, onComplete: { cidades in
            if let cidadesEncontradas = cidades {
                DispatchQueue.main.async {
                    print("cidades encontradas: \(cidadesEncontradas.count)")
                    self.activityIndicator.stopAnimating()
                    self.searchBtn.isHidden = false
                    self.cidadesResult = cidadesEncontradas
                    self.performSegue(withIdentifier: "searchToResult", sender: self)
                }
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToResult" {
            let resultVC = segue.destination as! ResultViewController
            resultVC.cidades = self.cidadesResult
        }
    }
}

