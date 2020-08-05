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

protocol StartCaseDelegate: class {
    func transitionToCase()
}

struct ClientMessage: Codable {
    var started_game: Bool?
    var started_case: Bool?
    var player_id: Int?
    var selected_option: Int?
    var selected_case_id: Int?
}

class Client {
    //Singleton
    static let shared = Client()
    var serverMessage: [String:Any]?
    
    var connectionDelegate: ConnectionDelegate?
    var startGameDelegate: StartGameDelegate?
    var startCaseDelegate: StartCaseDelegate?
    
    //Client Message
    var ClientInfo = ClientMessage(started_game: nil, started_case: nil, player_id: nil, selected_option: nil, selected_case_id: nil)
    
    //Server Message
    var playerID: Int?
    var RC: Int?
    var selectedOption: Int?
    var selectedCase: Int?
    var situationDescription: String?
    var selectedCaseDescription: String?
    var selectedCaseTitle: String?
    var optionsButtonsNames: [String]?
    var isConnected: Bool?
    var startGame: Bool?
    var startCase: Bool?
    var serverStatusMessage: String?
    
    func connectToServer(){
        Socket.shared.delegate = Client.shared
        Socket.shared.setupNetwork()
    }
    
    func sendClientInfo(){
        let message = try! JSONEncoder().encode(Client.shared.ClientInfo)
        let messageLength = String(bytes: message, encoding: .utf8)?.count
        
        Socket.shared.sendToServer(message: message, message_length: messageLength ?? 0)
    }
    
    func updateClientStartedGame(){
        ClientInfo.started_game = true
    }
    
    func updateClientStartedCase(){
        ClientInfo.started_case = true
    }
    
    func updateClientPlayerID(){
        ClientInfo.player_id = Client.shared.playerID
    }
    
    func updateClientSelectedOption(option: Int){
        ClientInfo.selected_option = option
    }
    
    func updateClientSelectedCaseID(caseID: Int){
        ClientInfo.selected_case_id = caseID
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
        
        if let startCase = serverMessage?["startCase"] as? Bool{
            Client.shared.startCase = startCase
            
            startCaseDelegate?.transitionToCase()
        }
        
        //Se o jogador tiver conseguido se conectar (por espaço e disponibilidade do servidor)
        if Client.shared.isConnected == true{
            if let sv = serverMessage?["players"] as? [[String: AnyObject]]{
                Client.shared.selectedOption = sv[Client.shared.playerID!]["selectedOption"] as? Int
                Client.shared.selectedCase = sv[Client.shared.playerID!]["selectedCase"] as? Int
                Client.shared.selectedCaseTitle = sv[Client.shared.playerID!]["selectedCaseTitle"] as? String
                Client.shared.selectedCaseDescription = sv[Client.shared.playerID!]["selectedCaseDescription"] as? String
            }
            
            Client.shared.RC = serverMessage?["RC"] as? Int
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
