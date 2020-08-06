//
//  EndingCaseViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class EndingCaseViewController: UIViewController {

    @IBOutlet var endingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        endingLabel.text = Client.shared.situationDescription

    }
    @IBAction func transitionToCaseList(_ sender: Any) {
        performSegue(withIdentifier: "segueToCases", sender: .none)
    }
}
