//
//  LoadingCaseViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class LoadingCaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Client.shared.startCaseDelegate = self
        Client.shared.sendClientInfo()
        
    }
}

extension LoadingCaseViewController: StartCaseDelegate{
    func transitionToCase(){
        performSegue(withIdentifier: "segueToIntroSituation", sender: nil)
    }
}
