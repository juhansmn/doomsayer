//
//  LoadingViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.shared.startGameDelegate = self
    }
}

extension LoadingViewController: StartGameDelegate{
    func transitionToStory(){
        performSegue(withIdentifier: "segueToStory", sender: nil)
    }
}
