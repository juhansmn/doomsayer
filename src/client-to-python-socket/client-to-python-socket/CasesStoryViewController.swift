//
//  CasesStoryViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class CasesStoryViewController: UIViewController {

    @IBOutlet var caseTitleLabel: UILabel!
    @IBOutlet var caseInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.shared.caseInfoDelegate = self
        
    }
    
    @IBAction func backToCases(_ sender: Any) {
        performSegue(withIdentifier: "segueToCases", sender: self)
    }
    
    @IBAction func confirmCase(_ sender: Any) {
        performSegue(withIdentifier: "segueToLoading", sender: self)
    }
}

extension CasesStoryViewController: CaseInfoDelegate{
    func showCaseInfo(){
        let special_color = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1.0)
        caseTitleLabel.textColor = special_color
        caseTitleLabel.text = Client.shared.selectedCaseTitle
        caseTitleLabel.textAlignment = .center
        
        caseInfoLabel.text = Client.shared.selectedCaseDescription
    }
}
