//
//  Client.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 30/07/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import Foundation

protocol ConnectionDelegate: class {
    func transitionToHome()
}

protocol StartGameDelegate: class {
    func transitionToStory()
}

struct ClientMessage: Codable {
    var started_game: Bool?
    var player_id: Int?
    var selected_option: String?
    var selected_case_id: Int?
    var selected_case_name: String?
}

class Client {
    //Singleton
    static let shared = Client()
    var serverMessage: [String:Any]?
    
    var connectionDelegate: ConnectionDelegate?
    var startGameDelegate: StartGameDelegate?
    
    var playerID: Int?
    var RC: Int?
    var selectedOption: Int?
    var selectedCase: Int?
    var topImageName: String?
    var situationDescription: String?
    var selectedCaseDescription: String?
    var optionsButtonsNames: [String]?
    var isConnected: Bool?
    var startGame: Bool?
    var serverStatusMessage: String?
    
    func connectToServer(){
        Socket.shared.delegate = Client.shared
        Socket.shared.setupNetwork()
    }
    
    func returnTopImageName(situationId: Int) -> String{
        return topImageName ?? "ERRO"
    }
    
    func returnOptionsNames(situationId: Int) -> [String]{
        return optionsButtonsNames ?? ["ERRO", "ERRO", "ERRO", "ERRO"]
    }
    
    func returnSituationDescription(situationId: Int) -> String{
        return situationDescription ?? "ERRO"
    }
    
    func returnServerStatus() -> String{
        return serverStatusMessage ?? "ERRO"
    }
    
    func updateAttributes(){
        //Checa se a mensagem é a de conexão
        if let isConnected = serverMessage?["isConnected"] as? Bool{
            Client.shared.isConnected = isConnected
            Client.shared.serverStatusMessage = serverMessage?["serverStatusMessage"] as? String
            
            connectionDelegate?.transitionToHome()
        }
        
        //Checa se a mensagem é a do ID do jogador
        if let playerID = serverMessage?["playerID"] as? Int{
            Client.shared.playerID = playerID
        }
        
        if let startGame = serverMessage?["startGame"] as? Bool{
            Client.shared.startGame = startGame
            
            startGameDelegate?.transitionToStory()
        }
        
        //Se o servidor estiver não estiver cheio
        if Client.shared.isConnected == true{
            if let sv = serverMessage?["players"] as? [[String: AnyObject]]{
                Client.shared.selectedOption = sv[Client.shared.playerID!]["selectedOption"] as? Int
                Client.shared.selectedCase = sv[Client.shared.playerID!]["selectedCase"] as? Int
                Client.shared.selectedCaseDescription = sv[Client.shared.playerID!]["selectedCaseDescription"] as? String
            }
            
            Client.shared.RC = serverMessage?["RC"] as? Int
            Client.shared.topImageName = (serverMessage?["topImageName"]) as? String
            Client.shared.situationDescription = serverMessage?["situationDescription"] as? String
            Client.shared.optionsButtonsNames = serverMessage?["optionsButtonsNames"] as? [String]
        }
    }
}

extension Client: ClientDelegate{
    func receivedMessage(message: String) {
        do{
            serverMessage = try JSONSerialization.jsonObject(with: message.data(using: .utf8)!, options: []) as? [String:Any]
            //let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .fragmentsAllowed)
            print(serverMessage)
            updateAttributes()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
