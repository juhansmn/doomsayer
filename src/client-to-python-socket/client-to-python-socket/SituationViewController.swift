//
//  SituationViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 30/07/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class SituationViewController: UIViewController {

    @IBOutlet var buttons : [UIButton]!
    var buttonWasSelected = false
    var selectedButton: Int?
    var confirmed = false
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var youImageView: UIImageView!
    @IBOutlet var partnerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.shared.situationDelegate = self
        
        //Atualiza label
        descriptionLabel.text = Client.shared.situationDescription
        
        youImageView.image = UIImage(named: "\(String(Client.shared.potraitNumber!))-idle")
        
        if Client.shared.potraitNumber == 1{
            partnerImageView.image = UIImage(named: "2-idle")
        }
        else{
            partnerImageView.image = UIImage(named: "1-idle")
        }
        
        //Atualiza botões
        buttons[0].setTitle("INVESTIGAR", for: .normal)
        buttons[1].setTitle("MATAR", for: .normal)
        buttons[2].setTitle("AMEAÇAR", for: .normal)
        buttons[3].setTitle("FUGIR", for: .normal)
        
        confirmButton.isHidden = true
        
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
            buttons[sender.tag].setImage(UIImage(named: "button\(String(sender.tag))-idle"), for: .normal)
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
            buttons[sender.tag].setImage(UIImage(named: "button\(String(sender.tag))-ready"), for: .normal)
            print(sender.tag)
            confirmButton.isHidden = false
        }
    }
    
    
    @IBAction func confirm(_ sender: Any) {
        youImageView.image = UIImage(named: "\(String(Client.shared.potraitNumber!))-ready")
        Client.shared.updateClientSelectedOption(option: selectedButton!)
        Client.shared.sendClientInfo()
        Client.shared.updateClientSituationID()
    }
}

extension SituationViewController: SituationDelegate{
    func partnerConfirmed(){
        if Client.shared.potraitNumber == 1{
            partnerImageView.image = UIImage(named: "2-ready")
        }
        else{
            partnerImageView.image = UIImage(named: "1-ready")
        }
    }
    
    func showResult(){
        for button in buttons{
            button.isHidden = true
            if button.tag == Client.shared.result{
                button.isHidden = false
                button.setImage(UIImage(named: "\(String(button.tag))-idle"), for: .normal)
            }
        }
        updateInfo()
    }
    func updateInfo(){
        //Atualiza label
        descriptionLabel.text = Client.shared.situationDescription
        
        youImageView.image = UIImage(named: "\(String(Client.shared.potraitNumber!))-idle")
        
        if Client.shared.potraitNumber == 1{
            partnerImageView.image = UIImage(named: "2-idle")
        }
        else{
            partnerImageView.image = UIImage(named: "1-idle")
        }
        
        for button in buttons{
            button.isHidden = false
            button.setImage(UIImage(named: "\(String(button.tag))-idle"), for: .normal)
        }
        
        confirmButton.isHidden = true
        
        buttonWasSelected = false
        selectedButton = nil
        confirmed = false
        
    }
    func endCase(){
        performSegue(withIdentifier: "segueToEnding", sender: .none)
    }
}
