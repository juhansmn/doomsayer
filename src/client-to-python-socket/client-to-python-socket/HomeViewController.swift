//
//  HomeViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 01/08/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var serverStatusLabel: UILabel!
    @IBOutlet var button: UIButton!
    var isPlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateHome()
    }
    
    func updateHome(){
        let serverStatusText = Client.shared.returnServerStatus()
        
        serverStatusLabel.text = serverStatusText
        
        var image = UIImage()
        
        switch Client.shared.serverStatus{
        case 0:
            isPlay = true
            image = UIImage(named: "buttonPlay")!
        case 1:
            isPlay = false
            image = UIImage(named: "buttonUpdate")!
            
        default:
            break
        }
        
        button.setImage(image, for: .normal)
    }

    @IBAction func touchButton(_ sender: Any) {
        if isPlay{
            performSegue(withIdentifier: "segueToLoading", sender: nil)
        }
        else{
            updateHome()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
