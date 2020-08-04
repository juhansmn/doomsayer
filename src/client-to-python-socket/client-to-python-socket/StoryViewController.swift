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
        
        textLabel.text = "Essa é uma cidade que não deveria existir, onde os cidadãos são envoltos numa realidade de violência constante num lugar famoso apenas pela sua quantidade de lixo, corporativismo e caos urbano. Você e seu parceiro são cidadãos comuns levados, pela necessidade ou ambições particulares, a se tornarem Doomsayers, cidadãos que escolhem se envolver nessa ultra violência recompensados com dinheiro e pontos como bom cidadão para \"garantir paz\" para a Sociedade. Faça sua parte."
        
    }
    @IBAction func confirmButton(_ sender: Any) {
        transitionToPlayers()
    }
    
    func transitionToPlayers(){
        performSegue(withIdentifier: "segueToPlayers", sender: nil)
    }
}
