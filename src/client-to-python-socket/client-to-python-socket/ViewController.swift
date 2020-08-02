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
    var i = 0
    
    @IBOutlet var buttonSair: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clientSocket.delegate = client
        //clientSocket.setupNetwork()
        
        //let message = try! JSONEncoder().encode(Situation(player_id: 20000, selected_option: "String"))
        //let messageLength = String(bytes: message, encoding: .utf8)?.count
        
        //clientSocket.sendToServer(message: message, message_length: messageLength ?? 0)

    }
    
    @IBAction func buttonSair(_ sender: Any) {
        if i == 0{
            i = 1
            buttonSair.setTitleColor(.white, for: .normal)
        }
        else{
            i = 0
            buttonSair.setTitleColor(.white, for: .normal)
        }
        let images = [UIImage(named: "nselecionado-base"), UIImage(named: "selecionado-base")]
        print(client.RC, client.topImageName)
        buttonSair.setBackgroundImage(images[i], for: .normal)
    }
}

