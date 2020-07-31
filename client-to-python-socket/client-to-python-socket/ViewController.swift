//
//  ViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 21/06/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let clientSocket = Socket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clientSocket.delegate = self
        clientSocket.setupNetwork()
        
        let message = try! JSONEncoder().encode(Situation(player_id: 20000, selected_option: 01))
        let messageLength = String(bytes: message, encoding: .utf8)?.count
        
        clientSocket.sendToServer(message: message, message_length: messageLength ?? 0)
    }
    
    @IBAction func buttonSair(_ sender: Any) {
        let message = try! JSONEncoder().encode(Situation(player_id: 01, selected_option: 02))
            clientSocket.sendToServer(message: message, message_length: message.count)
    }
}

extension ViewController: ClientDelegate{
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

