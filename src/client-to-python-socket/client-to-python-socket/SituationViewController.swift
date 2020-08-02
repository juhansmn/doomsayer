//
//  SituationViewController.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 30/07/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import SpriteKit

class SituationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SituationScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .aspectFill
        
        let skView = view as! SKView
        
        skView.presentScene(scene)
    }
    
    //Método que adiciona imagem
    //Método que carrega texto (cada tela de situação tem um ID. Uma outra classe vai pegar o JSON de cada situação retornar o texto para carregar essa opção por opção e resumo)
    //Método de navegação (baseado em parâmetro com o que o servidor retornar)
    //Atualiza id (recebe do servidor)

    /*
    MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
