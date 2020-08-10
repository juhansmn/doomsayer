//
//  CasesListViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class CasesListViewController: UIViewController {

    @IBOutlet var RClabel: UILabel!
    @IBOutlet var RCImageView: UIImageView!
    @IBOutlet var caseOneImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let special_color = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1.0)
        RClabel.textColor = special_color
        RClabel.textAlignment = .center
        
        if Client.shared.RC! > 0{
            //Icone feliz
            RCImageView.image = UIImage(named: "icon-small-happy")
            RClabel.text = "Bom trabalho!"
        }
        else{
            //Icone triste
            RCImageView.image = UIImage(named: "icon-small-sad")
            RClabel.text = "Faça sua parte!"
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        caseOneImageView.isUserInteractionEnabled = true
        caseOneImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        Client.shared.updateClientSelectedCaseID(caseID: 0)
        
        Client.shared.sendClientInfo()
        
        performSegue(withIdentifier: "segueToStory", sender: self)
    }
}
