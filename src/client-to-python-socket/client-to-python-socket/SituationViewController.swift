//
//  SituationViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 30/07/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import SpriteKit

class SituationViewController: UIViewController {

    @IBOutlet var buttons : [UIButton]!
    var buttonWasSelected = false
    var selectedButton: Int?
    var confirmed = false
    @IBOutlet var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Atualiza label
        //Atualiza botões
        
        confirmButton.isHidden = true
        
        /*
        let scene = SituationScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .aspectFill
        
        let skView = view as! SKView
        
        skView.presentScene(scene)
        */
    }
    @IBAction func touchedButton(sender: UIButton) {
        
        if buttonWasSelected && selectedButton == sender.tag && !confirmed{
            for button in buttons{
                if button.tag != sender.tag{
                    button.isHidden = false
                }
            }
            buttonWasSelected = false
            selectedButton = nil
            buttons[sender.tag].setImage(UIImage(named: ""), for: .normal)
            confirmButton.isHidden = true
        }
        
        else if !buttonWasSelected && !confirmed{
            for button in buttons{
                if button.tag != sender.tag{
                    button.isHidden = true
                }
            }
            buttonWasSelected = true
            selectedButton = sender.tag
            buttons[sender.tag].setImage(UIImage(named: ""), for: .normal)
            confirmButton.isHidden = false
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        //Ao clicar no de OK, uma mensagem é enviada para o servidor, ao isso acontecer, o ícone do jogador fica escuro (SituationDelegate para escurecer a do seu parceiro).
    }
}
