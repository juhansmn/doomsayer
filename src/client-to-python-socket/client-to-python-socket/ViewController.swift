//
//  ViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 21/06/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func buttonConnect(_ sender: Any) {
        Client.shared.connectionDelegate = self
        Client.shared.connectToServer()
    }
}

extension ViewController: ConnectionDelegate{
    func transitionToHome(){
        performSegue(withIdentifier: "segueToHome", sender: nil)
    }
}

