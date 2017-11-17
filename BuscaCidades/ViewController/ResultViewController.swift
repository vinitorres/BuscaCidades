//
//  ResultViewController.swift
//  BuscaCidades
//
//  Created by Vinicius Torres on 11/16/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cidadeSelecionada: Cidade?
    var pontos: String = ""
    
    var cidades: [Cidade] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ResultTableCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        
        if cidades.count < 1 {
            let message = "Nenhuma cidade foi encontrada."
            let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height:  self.view.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = .none;
        }
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultToDetails" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.textPoints = "A pontuação da Cidade \(cidadeSelecionada?.nome ?? "") é \(pontos)"
        }
    }
 
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cidades.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.selectionStyle = .none
        
        cell.nomeCidade.text = cidades[indexPath.section].nome ?? ""
        cell.estadoCidade.text = cidades[indexPath.section].estado ?? ""
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.cidadeSelecionada = cidades[indexPath.section]
        
        Service.getPontosCidade(cidadeSelecionada: cidadeSelecionada!) { (pontos) in
            if let pontosEncontrados = pontos {
                DispatchQueue.main.async {
                    self.pontos = pontosEncontrados
                    self.performSegue(withIdentifier: "resultToDetails", sender: self)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
}
