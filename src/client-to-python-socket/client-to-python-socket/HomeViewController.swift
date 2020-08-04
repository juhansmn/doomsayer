//
//  HomeViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var serverStatusLabel: UILabel!
    @IBOutlet var button: UIButton!
    var isPlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHome()
    }
    
    func updateHome(){
        let serverStatusText = Client.shared.serverStatusMessage
        
        serverStatusLabel.text = serverStatusText
        serverStatusLabel.textAlignment = .center
        
        switch Client.shared.isConnected{
        case true:
            isPlay = true
            button.setTitle("JOGAR", for: .normal)
        case false:
            isPlay = false
            button.setTitle("ATUALIZAR", for: .normal)
            
        default:
            break
        }
    }

    @IBAction func touchButton(_ sender: Any) {
        if isPlay{
            
            let message = try! JSONEncoder().encode(ClientMessage(started_game: true, player_id: Client.shared.playerID, selected_option: nil, selected_case_id: nil, selected_case_name: nil))
            let messageLength = String(bytes: message, encoding: .utf8)?.count
            
            Socket.shared.sendToServer(message: message, message_length: messageLength ?? 0)
            performSegue(withIdentifier: "segueToLoading", sender: nil)
        }
        else{
            updateHome()
        }
    }
}
