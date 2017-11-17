//
//  Service.swift
//  BuscaCidades
//
//  Created by Vinicius Torres on 11/16/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import Foundation

class Service {
    
    static let BASE_URL = "http://wsteste.devedp.com.br/Master/CidadeServico.svc/rest/"
    
    static let BUSCAR_CIDADES = "BuscaTodasCidades"
    static let BUSCAR_PONTOS = "BuscaPontos"
    
    static let configuration: URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 45.0
        config.httpMaximumConnectionsPerHost = 5
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
    
        return config
    }()
    
    static let session = URLSession(configuration: configuration)
    
    static func getCidadesFiltered(_ cidadeSearch: String,_ estadoSearch:String, onComplete: @escaping (_ success: [Cidade]?)->()) {
        
        guard let url = URL(string: BASE_URL + BUSCAR_CIDADES) else {
            onComplete(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Erro with session task")
                onComplete(nil)
            } else {
                
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    guard let data = data else {
                        onComplete(nil)
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [[String: Any]]
                        
                        var temp: [Cidade] = []
                        var tempEstados: [Cidade] = []
                        var cidades: [Cidade] = []

                        for item in json {
                            let nome = item["Nome"] as! String
                            let estado = item["Estado"] as! String
                            
                            let cidade = Cidade(nome: nome, estado: estado)
                            
                            temp.append(cidade)
                        }
                        
                        
                        if estadoSearch != "" && cidadeSearch != "" {
                            
                            for filtroEstado in temp {
                                if (filtroEstado.estado?.lowercased().contains(estadoSearch.lowercased()))! {
                                    print("estado encontrado")
                                    tempEstados.append(filtroEstado)
                                }
                            }
                            
                            for filtroCidade in tempEstados {
                                if (filtroCidade.nome?.lowercased().contains(cidadeSearch.lowercased()))! {
                                    print("cidade encontrada")
                                    cidades.append(filtroCidade)
                                }
                            }
                            
                            onComplete(cidades)
                        } else if estadoSearch != "" {
                            for filtroEstado in temp {
                                if (filtroEstado.estado?.lowercased().contains(estadoSearch.lowercased()))! {
                                    print("estado encontrado")
                                    tempEstados.append(filtroEstado)
                                }
                            }
                            onComplete(tempEstados)
                        } else if cidadeSearch != "" {
                            for filtroCidade in temp {
                                if (filtroCidade.nome?.lowercased().contains(cidadeSearch.lowercased()))! {
                                    print("cidade encontrada")
                                    cidades.append(filtroCidade)
                                }
                            }
                            onComplete(cidades)
                        } else {
                            onComplete(temp)
                        }
                        
                
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("Erro no servidor:", response.statusCode)
                    onComplete(nil)
                }
                
                
                
            }
            
        }
        
        dataTask.resume()
    }
    
    static func getPontosCidade(cidadeSelecionada: Cidade, onComplete: @escaping (_ success: String?)->()) {
        
        let body = ["Nome": cidadeSelecionada.nome, "Estado": cidadeSelecionada.estado]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL(string: BASE_URL + BUSCAR_PONTOS) else {
            onComplete(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonBody
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Erro data task")
                onComplete(nil)
            } else {
                
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    guard let data = data else {
                        onComplete(nil)
                        return
                    }
                    
                    let responseData = String(data: data, encoding: String.Encoding.utf8)
                    onComplete(responseData)
                        
                    
                } else {
                    print("Erro no servidor:", response.statusCode)
                    onComplete(nil)
                }
                
                
                
            }
            
        }
        
        dataTask.resume()
    }
}

