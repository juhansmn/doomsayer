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

protocol CaseInfoDelegate: class {
    func showCaseInfo()
}

protocol StartCaseDelegate: class {
    func transitionToCase()
}

protocol SituationDelegate: class {
    func partnerConfirmed()
    func showResult()
    func updateInfo()
    func endCase()
}
struct ClientMessage: Codable {
    var started_game: Bool?
    var started_case: Bool?
    var player_id = 1
    var selected_option: Int?
    var selected_case_id = 0
    var situation_id = 0
}

class Client {
    //Singleton
    static let shared = Client()
    var serverMessage: [String:Any]?
    
    var connectionDelegate: ConnectionDelegate?
    var startGameDelegate: StartGameDelegate?
    var caseInfoDelegate: CaseInfoDelegate?
    var startCaseDelegate: StartCaseDelegate?
    var situationDelegate: SituationDelegate?
    
    //Client Message
    var ClientInfo = ClientMessage(started_game: false, started_case: false, player_id: 1, selected_option: 0, selected_case_id: 0, situation_id: 0)
    
    //Server Message
    var playerID: Int?
    var RC: Int?
    var selectedOption: Int?
    var selectedCase: Int?
    var situationDescription: String?
    var selectedCaseDescription: String?
    var selectedCaseTitle: String?
    var situationID: Int?
    var isConnected: Bool?
    var startGame: Bool?
    var startCase: Bool?
    var serverStatusMessage: String?
    var potraitNumber: Int?
    var result: Int?
    
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
        ClientInfo.player_id = Client.shared.playerID!
    }
    
    func updateClientSelectedOption(option: Int){
        ClientInfo.selected_option = option
    }
    
    func updateClientSelectedCaseID(caseID: Int){
        ClientInfo.selected_case_id = caseID
    }
    
    func updateClientSituationID(){
        ClientInfo.situation_id += 1
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
        
        if (serverMessage?["partnerConfirmed"] as? Bool) != nil{
            situationDelegate?.partnerConfirmed()
        }
        
        if let result = serverMessage?["result"] as? Int{
            Client.shared.result = result
            situationDelegate?.showResult()
            Client.shared.result = nil
        }
        
        if (serverMessage?["endCase"] as? Bool) != nil{
            situationDelegate?.endCase()
        }
        
        //Se o jogador tiver conseguido se conectar (por espaço e disponibilidade do servidor)
        if Client.shared.isConnected == true{

            if let sv = serverMessage?["players"] as? [[String: AnyObject]]{
                if let _ = sv[Client.shared.playerID!]["selectedCase"] as? Int{
                    Client.shared.selectedCase = sv[Client.shared.playerID!]["selectedCase"] as? Int
                    Client.shared.selectedCaseTitle = sv[Client.shared.playerID!]["selectedCaseTitle"] as? String
                    Client.shared.selectedCaseDescription = sv[Client.shared.playerID!]["selectedCaseDescription"] as? String
                    
                    caseInfoDelegate?.showCaseInfo()
                }
                
                if let selectedOption = sv[Client.shared.playerID!]["selectedOption"] as? Int{
                    Client.shared.selectedOption = selectedOption
                }
                Client.shared.potraitNumber = sv[Client.shared.playerID!]["portraitNumber"] as? Int
            }
            
            Client.shared.RC = serverMessage?["RC"] as? Int
            Client.shared.situationID = serverMessage?["situationID"] as? Int
            Client.shared.situationDescription = serverMessage?["situationDescription"] as? String
        }
        
        if (serverMessage?["updateSituation"] as? Bool) != nil{
            //situationDelegate?.updateInfo()
        }
    }
}

extension Client: ClientDelegate{
    func receivedMessage(message: String) {
        do{
            serverMessage = try JSONSerialization.jsonObject(with: message.data(using: .utf8)!, options: []) as? [String:Any]
            updateAttributes()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
