//
//  IntroSituationViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class IntroSituationViewController: UIViewController {

    @IBOutlet var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        introLabel.text = Client.shared.situationsDescription![0]
        
    }
    
    @IBAction func startSituations(_ sender: Any) {
        performSegue(withIdentifier: "segueToSituations", sender: .none)
    }
}
