//
//  PlayersViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    @IBOutlet var youLabel: UILabel!
    @IBOutlet var partnerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let special_color = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1.0)
        youLabel.textColor = special_color
        youLabel.text = "Você"
        youLabel.textAlignment = .center
        
        partnerLabel.text = "Seu parceiro"
        partnerLabel.textColor = .white
        partnerLabel.textAlignment = .center
    
    }
    @IBAction func confirmButton(_ sender: Any) {
        transitionToCases()
    }
    
    func transitionToCases(){
        performSegue(withIdentifier: "segueToCases", sender: nil)
    }
}
