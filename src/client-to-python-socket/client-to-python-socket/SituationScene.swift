//
//  SituationScene.swift
//  client-to-python-socket
//
//  Created by Juan Suman on 30/07/20.
//  Copyright © 2020 Juan Suman. All rights reserved.
//

import SpriteKit

class SituationScene: SKScene{
    let viewController = SituationViewController.self
    let topImage = SKSpriteNode()
    let situationDescription = SKLabelNode()
    let optionsButtons = [SKSpriteNode]()
    let confirmationButton = SKSpriteNode()
    
    var situationID = 0
    
    override func didMove(to view: SKView) {
        situationID = Client.shared.situationID ?? 0
        
        for (i, option) in optionsButtons.enumerated(){
            setupButton(button: option, name: "option\(i)", height: 60, width: 200, x: 0, y: 0)
        }
        setupButton(button: confirmationButton, name: "confimationButton", height: 60, width: 60, x: 0, y: 0)
        
        updateInformation(id: situationID)
    }
    
    //Atualiza informações da Cena
    func updateInformation(id: Int){
        //Adiciona imagem 
        //Carrega texto
    }
    
    func setupDescription(){
        situationDescription.fontSize = 69
        situationDescription.fontColor = SKColor.white
        situationDescription.position = CGPoint(x: 0, y: 0)
    }
    
    func updateDescription(){
        let text = Client.shared.returnSituationDescription(situationId: situationID)
        situationDescription.text = ""
    }
    
    //Configura botões
    func setupButton(button: SKSpriteNode, name: String, height: CGFloat, width: CGFloat, x: Int, y: Int){
        button.name = name
        button.size.height = height
        button.size.width = width
        button.position = CGPoint(x: x, y: y)
        button.zPosition = 1
        
        self.addChild(button)
        
        //Ao clicar no botão, mandar as opções para o servidor (se for igual, vai pra próxima Situação, se são diferentes, vai pro Desempate)
        //Se for pra próxima Situação, atualiza todas as informações
    }
    
    func updateOptions(){
        let buttons = Client.shared.returnOptionsNames(situationId: situationID)
        
        for (i, option) in optionsButtons.enumerated(){
            option.texture = SKTexture(imageNamed: buttons[i])
        }
    }
}
