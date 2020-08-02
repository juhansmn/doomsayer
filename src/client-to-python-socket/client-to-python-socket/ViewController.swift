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
    let client = Client.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientSocket.delegate = client
        clientSocket.setupNetwork()
        
        let message = try! JSONEncoder().encode(Situation(player_id: 20000, selected_option: "String"))
        let messageLength = String(bytes: message, encoding: .utf8)?.count
        
        clientSocket.sendToServer(message: message, message_length: messageLength ?? 0)

    }
    
    @IBAction func buttonSair(_ sender: Any) {
        print(client.RC, client.topImageName)
    }
}

