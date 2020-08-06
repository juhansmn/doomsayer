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
    
    @IBOutlet var youImageView: UIImageView!
    @IBOutlet var partnerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let special_color = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1.0)
        youLabel.textColor = special_color
        youLabel.text = "Você"
        youLabel.textAlignment = .center
        print("AAAAAAAAAAAAA")
        print(Client.shared.potraitNumber)
        youImageView.image = UIImage(named: "\(String(Client.shared.potraitNumber!))-idle")
        
        partnerLabel.text = "Seu parceiro"
        partnerLabel.textColor = .white
        partnerLabel.textAlignment = .center
        
        if Client.shared.potraitNumber == 1{
            partnerImageView.image = UIImage(named: "2-idle")
        }
        else{
            partnerImageView.image = UIImage(named: "1-idle")
        }

    
    }
    @IBAction func confirmButton(_ sender: Any) {
        transitionToCases()
    }
    
    func transitionToCases(){
        performSegue(withIdentifier: "segueToCases", sender: nil)
    }
}
