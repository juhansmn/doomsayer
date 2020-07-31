//
//  Client.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 30/07/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import Foundation

struct Situation: Codable {
    var player_id: Int
    var selected_option: Int
}

struct Case: Codable {
    var player_id: Int
    var selected_case_id: Int
    var selected_case_name: String
}

class Client {
    let clientSocket = Socket()
    var playerID: Int?
    var playerName: String?
    var RC: Int?
    var selectedOption: Int?
    var selectedCase: Int?
    var topImageName: String?
    var situationDescription: String?
    var optionsNames: [String]?
    
    func connectToServer(){
        clientSocket.delegate = self
        clientSocket.setupNetwork()
    }
    
    func returnTopImageName(id: Int) -> String{
        return "A"
    }
    
    func returnOptionsNames(id: Int) -> [String]{
        return ["A", "B"]
    }
    
    func returnDescription(id: Int) -> String{
        return "A"
    }
    
    func updateAttributes(){
        //Recebe o JSON
        //Separa o JSON
        //Atualiza os atributos com cada posição do JSON
    }
    
    /*
     id do usuario
     nome
     rc
     players_options
     caso_selecionado
     imagem
     botoes
     descricao da situacao
     */
    
    //retorna cada dado
}

extension Client: ClientDelegate{
    func receivedMessage(message: String) {
        do{
            let jsonArray = try JSONSerialization.jsonObject(with: message.data(using: .utf8)!, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .fragmentsAllowed)
            print(jsonData)
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
