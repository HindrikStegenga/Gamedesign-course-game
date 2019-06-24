//
//  MainViewController.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import MetalKit
import Metal
import Cocoa

class MainViewController : NSViewController {
    
    @IBOutlet var topBar: NSView!
    @IBOutlet var mtkView: MTKView!
    @IBOutlet var mainView: MainView!
    @IBOutlet weak var bottleCountLabel: NSTextField!
    @IBOutlet weak var secondCountLabel: NSTextField!
    
    var saddleBrown: simd_float4 = [0.545, 0.271, 0.075, 1]
    var maxBoxCount = 10
    var bottleCount = 6
    var hitBottleCount = 0
    
    var mtlRenderer: MTLRenderer!
    var playerDrawable: Drawable2D!
    var bottleDrawables: [Drawable2D] = []
    var boxDrawables: [Drawable2D] = []
    var gridSize: Int = 25
    var accelerationFactor: Float = 3.33
    
    var pressedUp: Bool = false
    var pressedDown: Bool = false
    var pressedLeft: Bool = false
    var pressedRight: Bool = false
    
    var totalSecondCount = 60
    var currentSecondCount = 0
    var gameTimer: Timer? = nil
    
    override func viewDidLoad() {
        guard mtkView != nil, mainView != nil else {
            fatalError("Failure")
        }
        
        mainView.keyDownDelegate = pressedKey
        mainView.keyUpDelegate = unPressedKey
        
        self.mtlRenderer = MTLRenderer(mtkView: mtkView)
        
        #if DEBUG
            reset()
        #else
            self.performSegue(withIdentifier: "tutorialSegue", sender: nil)
        #endif
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "tutorialSegue":
            let vc = segue.destinationController as! TutorialViewController
            vc.delegate = {
                self.reset()
            }
        case "endGameSegue":
            let vc = segue.destinationController as! EndGameViewController
            vc.score = hitBottleCount
            vc.delegate = {
                self.reset()
            }
        default:
            return
        }
    }
    
    func reset() {
        
        if gameTimer != nil {
            gameTimer?.invalidate()
        }
        
        pressedUp = false
        pressedDown = false
        pressedLeft = false
        pressedRight = false
        bottleDrawables = []
        boxDrawables = []
        hitBottleCount = 0
        bottleCountLabel.stringValue = "Collected bottles: \(hitBottleCount)"
        mtlRenderer.clearDrawables()
        setupWorld()
        
        currentSecondCount = 0
        self.secondCountLabel.stringValue = "Time: \(totalSecondCount)"
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            timer in
            
            if self.currentSecondCount < self.totalSecondCount {
                self.currentSecondCount += 1
                self.secondCountLabel.stringValue = "Time: \(self.totalSecondCount - self.currentSecondCount)"
                return
            }
            timer.invalidate()
            self.mtlRenderer.updateClosure = nil
            self.performSegue(withIdentifier: "endGameSegue", sender: self.hitBottleCount)
        })
        
        //Set the update closure, triggering the drawloop
        mtlRenderer.updateClosure = update
    }
    
    func setupWorld() {
        let clearValue = 1.0 / 255.0 * 236.0
        mtlRenderer.mtkView.clearColor = MTLClearColor(red: clearValue, green: clearValue, blue: clearValue, alpha: 1)
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                
                guard row == 1 || column == 1 || row == gridSize - 2 || column == gridSize - 2 else {continue}
                
                let square = Drawable2D.Square()
                
                guard let buf = square.uniform_buffer_source as? DefaultUniformBuffer else {
                    continue
                }
                
                buf.color = saddleBrown
                
                square.scale = 1.0
                square.position = [Float(row), Float(column)]
                square.rotation = 0.0
                setGridSizeCorrectMatrix(drawable: square)
                mtlRenderer.addDrawable(drawable: square)
            }
        }
        
        playerDrawable = Drawable2D.Square()
        guard let playerBuf = playerDrawable.uniform_buffer_source as? DefaultUniformBuffer else { return }
        
        playerDrawable.fragment_func_name = "player_fragment_func"
        
        playerBuf.color = [1,1,1,1]
        playerDrawable.position = [Float(gridSize)/2,Float(gridSize/2)]
        playerDrawable.rotation = 0.0
        playerDrawable.scale = 1.0
        playerDrawable.fragment_func_texture_name = "gray_man_2"
        setGridSizeCorrectMatrix(drawable: playerDrawable)
        mtlRenderer.addDrawable(drawable: playerDrawable)
        
        setupGroceryStore()
    }
    
    func setGridSizeCorrectMatrix(drawable: Drawable2D) {
        guard let buf = drawable.uniform_buffer_source as? DefaultUniformBuffer else { return }
        
        let width = Float(mtkView.drawableSize.width)
        let height = Float(mtkView.drawableSize.height)
        
        let posX = Float.remap(drawable.position.x + 0.5, 0, Float(gridSize), -1, 1)
        let posY = Float.remap(drawable.position.y + 0.5, 0, Float(gridSize), -1, 1)
        
        let scaleMatrix = Matrix.makeScaleMatrix(xScale: Float(1 / width * (width / Float(gridSize))) * drawable.scale,
                                                 yScale: Float(1 / height * (height / Float(gridSize))) * drawable.scale)
        
        let translationMatrix = Matrix.makeTranslationMatrix(tx: posX, ty: posY)
        let rotationMatrix = Matrix.makeRotationMatrix(angle: drawable.rotation)
        
        buf.matrix = rotationMatrix * scaleMatrix * translationMatrix
    }
    
    func update(dt: CFTimeInterval) {
        
        let pos = playerDrawable.position
        let acceleration : Float = Float(gridSize) / accelerationFactor
        
        let upperBound = gridSize - 3;
        let lowerBound = 2;
        let leftBound = 2;
        let rightBound = gridSize - 3;
        
        
        if pressedUp {
            if pos.y < Float(upperBound) {
                let newY = pos.y + acceleration * Float(dt)
                if !willCollideWithBox(x: pos.x, y: newY) {
                    playerDrawable.position.y = newY
                }
            }
            playerDrawable.rotation = 0.0
        }
        if pressedDown {
            if pos.y > Float(lowerBound) {
                let newY = pos.y - acceleration * Float(dt)
                if !willCollideWithBox(x: pos.x, y: newY) {
                    playerDrawable.position.y = newY
                }
            }
            playerDrawable.rotation = 3.14
        }
        if pressedLeft {
            if pos.x > Float(leftBound) {
                let newX = pos.x - acceleration * Float(dt)
                if !willCollideWithBox(x: newX, y: pos.y) {
                    playerDrawable.position.x = newX
                }
            }
            playerDrawable.rotation = 3.14 / 2
        }
        if pressedRight {
            if pos.x < Float(rightBound) {
                let newX = pos.x + acceleration * Float(dt)
                if !willCollideWithBox(x: newX, y: pos.y) {
                    playerDrawable.position.x = newX
                }
            }
            playerDrawable.rotation = -3.14 / 2
        }
        
        if pressedUp, pressedLeft {
            playerDrawable.rotation = 3.14 / 4
        }
        if pressedUp, pressedRight {
            playerDrawable.rotation = -3.14 / 4
        }
        if pressedDown, pressedLeft {
            playerDrawable.rotation = 3.14 / 2 + (3.14 / 4)
        }
        if pressedDown, pressedRight {
            playerDrawable.rotation = -3.14 / 2 - (3.14 / 4)
        }
        
        setGridSizeCorrectMatrix(drawable: playerDrawable)
        updateBottles()
    }
    
    func willCollideWithBox(x: Float,y: Float) -> Bool {
        for box in boxDrawables {
            
            let distX = abs(x - box.position.x)
            let distY = abs(y - box.position.y)
            
            if sqrt(distX * distX + distY * distY) < 1.4 {
                NSSound(named: "hit")!.play()
                return true
            }
        }
        return false
    }
    
    func updateBottles() {
        
        while bottleDrawables.count != bottleCount {
            createNewBottle()
        }
        
        for (index, var bottle) in bottleDrawables.enumerated().reversed() {
            let xPlayer = playerDrawable.position.x
            let yPlayer = playerDrawable.position.y
            
            let distX = abs(xPlayer - bottle.position.x)
            let distY = abs(yPlayer - bottle.position.y)
            
            if sqrt(distX * distX + distY * distY) < 0.7 {
                //Hit
                NSSound(named: "ring")!.play()
                hitBottleCount += 1
                bottleCountLabel.stringValue = "Collected bottles: \(hitBottleCount)"
                bottleDrawables.remove(at: index)
                mtlRenderer.removeDrawable(drawable: &bottle)
            }
        }
        
    }
    
    func createNewBottle() {
        let (x,y) = getValidBottlePosition()
        
        let bottle = Drawable2D.Square()
        guard let buf = bottle.uniform_buffer_source as? DefaultUniformBuffer else {
            return
        }
        buf.color = [1,1,1,1]
        bottle.fragment_func_name = "player_fragment_func"
        bottle.rotation = 0.0
        bottle.position = [Float(x), Float(y)]
        bottle.scale = 1.0
        bottle.fragment_func_texture_name = "bottle"
        bottleDrawables.append(bottle)
        setGridSizeCorrectMatrix(drawable: bottle)
        mtlRenderer.addDrawable(drawable: bottle)
    }
    
    func getValidBottlePosition() -> (Int,Int) {
        let x = Int.random(in: 2..<gridSize-2)
        let y = Int.random(in: 2..<gridSize-2)
        
        for bottle in bottleDrawables {
            let distX = abs(Float(x) - bottle.position.x)
            let distY = abs(Float(y) - bottle.position.y)
            
            if sqrt(distX * distX + distY * distY) < 4.0 {
                return getValidBottlePosition()
            }
        }
        
        for box in boxDrawables {
            let distX = abs(Float(x) - box.position.x)
            let distY = abs(Float(y) - box.position.y)
            
            if sqrt(distX * distX + distY * distY) < 3.0 {
                return getValidBottlePosition()
            }
        }
        
        let distX = abs(Float(x) - playerDrawable.position.x)
        let distY = abs(Float(y) - playerDrawable.position.y)
        if sqrt(distX * distX + distY * distY) < 4.0 {
            return getValidBottlePosition()
        }
        
        return (x,y)
    }
    
    func pressedKey(event: NSEvent) {
        switch event.keyCode {
        case 13: //W
            pressedUp = true
        case 1:
            pressedDown = true
        case 0:
            pressedLeft = true
        case 2:
            pressedRight = true
        default:
            ()
        }
    }
    
    func unPressedKey(with event: NSEvent) {
        switch event.keyCode {
        case 13: //W
            pressedUp = false
        case 1:
            pressedDown = false
        case 0:
            pressedLeft = false
        case 2:
            pressedRight = false
        default:
            ()
        }
    }
    
    func setupGroceryStore() {
        topLoop: while boxDrawables.count != maxBoxCount {
            //Apple boxes are twice as big.
            
            let x = Int.random(in: 3..<gridSize-3)
            let y = Int.random(in: 3..<gridSize-3)
            
            for box in boxDrawables {
                let distX = abs(Float(x) - box.position.x)
                let distY = abs(Float(y) - box.position.y)
                
                if sqrt(distX * distX + distY * distY) < 5.0 {
                    continue topLoop
                }
            }
            
            let distX = abs(Float(x) - playerDrawable.position.x)
            let distY = abs(Float(y) - playerDrawable.position.y)
            
            if sqrt(distX * distX + distY * distY) < 5.0 {
                continue topLoop
            }
            
            let appleBox = Drawable2D.Square()
            guard let buf = appleBox.uniform_buffer_source as? DefaultUniformBuffer else {
                return
            }
            buf.color = [1,1,1,1]
            appleBox.fragment_func_name = "player_fragment_func"
            appleBox.rotation = 0.0
            appleBox.position = [Float(x), Float(y)]
            appleBox.scale = 2.0
            appleBox.fragment_func_texture_name = "apples"
            setGridSizeCorrectMatrix(drawable: appleBox)
            boxDrawables.append(appleBox)
            mtlRenderer.addDrawable(drawable: appleBox)
        }
    }
    
    @IBAction func didPressResetBtn(_ sender: NSButton) {
        self.reset()
        self.resignFirstResponder()
        mainView.becomeFirstResponder()
    }
}
