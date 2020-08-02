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
    var selected_option: String
}

struct Case: Codable {
    var player_id: Int
    var selected_case_id: Int
    var selected_case_name: String
}

class Client {
    //Singleton
    static let shared = Client()
    
    let clientSocket = Socket()
    
    var serverMessage: [String:Any]?
    
    var playerID: Int?
    var playerName: String?
    var RC: Int?
    var selectedOption: Int?
    var selectedCase: Int?
    var topImageName: String?
    var situationDescription: String?
    var optionsButtonsNames: [String]?
    var serverStatus: Int?
    var serverStatusMessage: String?
    
    func connectToServer(){
        clientSocket.delegate = Client.shared
        clientSocket.setupNetwork()
    }
    
    func returnTopImageName(situationId: Int) -> String{
        return "A"
    }
    
    func returnOptionsNames(situationId: Int) -> [String]{
        return ["", "B"]
    }
    
    func returnSituationDescription(situationId: Int) -> String{
        return "B"
    }
    
    func returnServerStatus() -> String{
        return "B"
    }
    
    func updateAttributes(){
        //Recebe o JSON
        //Separa o JSON
        //Atualiza os atributos com cada posição do JSON
        
        print("AAAAA")
        
        Client.shared.RC = serverMessage?["player_id"] as? Int
        //Client.shared.selectedOption = serverMessage?["player_id"] as! Int
        //Client.shared.selectedCase = serverMessage?["player_id"] as? Int
        Client.shared.topImageName = (serverMessage?["selected_option"]) as? String
        //Client.shared.situationDescription = serverMessage?["player_id"] as! String
        //Client.shared.optionsButtonsNames = serverMessage?["player_id"] as! [String]
        //Client.shared.serverStatus = serverMessage?["player_id"] as! Int
        
        
        print(serverMessage!["player_id"], Client.shared.RC)
    }
}

extension Client: ClientDelegate{
    func receivedMessage(message: String) {
        do{
            serverMessage = try JSONSerialization.jsonObject(with: message.data(using: .utf8)!, options: []) as? [String:Any]
            //let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .fragmentsAllowed)
            updateAttributes()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
