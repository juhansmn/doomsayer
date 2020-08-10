//
//  StoryViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let special_color = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1.0)
        titleLabel.textColor = special_color
        titleLabel.text = "20XX. Azimov."
        
        textLabel.text = "Essa é uma cidade que não deveria existir, onde os cidadãos estão presos numa realidade de violência e caos urbano. Você e seu parceiro são cidadãos comuns levados, pela necessidade ou ambições particulares, a se tornarem Doomsayers, cidadãos que escolhem se envolver na ultra violência recompensados pontos como bom cidadão para \"garantir paz\" para a Sociedade. Numa sociedade vigilante, todos os alvos são conhecidos. Faça sua parte."
        
    }
    @IBAction func confirmButton(_ sender: Any) {
        transitionToPlayers()
    }
    
    func transitionToPlayers(){
        performSegue(withIdentifier: "segueToPlayers", sender: nil)
    }
}
