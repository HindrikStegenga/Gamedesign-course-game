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
    @IBOutlet var rightBar: NSView!
    @IBOutlet var mtkView: MTKView!
    @IBOutlet var mainView: MainView!
    
    var mtlRenderer: MTLRenderer!
    var playerDrawable: Drawable2D!
    var gridSize: Int = 25
    var accelerationFactor: Float = 3.33
    
    var pressedUp: Bool = false
    var pressedDown: Bool = false
    var pressedLeft: Bool = false
    var pressedRight: Bool = false
    
    override func viewDidLoad() {
        guard mtkView != nil, mainView != nil else {
            fatalError("Failure")
        }
        
        mainView.keyDownDelegate = pressedKey
        mainView.keyUpDelegate = unPressedKey
        
        self.mtlRenderer = MTLRenderer(mtkView: mtkView)
        self.mtlRenderer.updateClosure = self.update
        setupWorld()
    }
    
    func reset() {
        pressedUp = false
        pressedDown = false
        pressedLeft = false
        pressedRight = false
        mtlRenderer.clearDrawables()
        setupWorld()
    }
    
    func setupWorld() {
        
        playerDrawable = Drawable2D.Square()
        guard let playerBuf = playerDrawable.uniform_buffer_source as? DefaultUniformBuffer else { return }
        
        playerDrawable.fragment_func_name = "player_fragment_func"
        
        playerBuf.color = [1,1,1,1]
        playerDrawable.position = [Float(gridSize)/4,Float(gridSize/4)]
        playerDrawable.rotation = 0.0
        playerDrawable.scale = 1.0
        playerDrawable.fragment_func_texture_name = "gray_man_2"
        setGridSizeCorrectMatrix(drawable: playerDrawable)
        mtlRenderer.addDrawable(drawable: playerDrawable)
        
        let clearValue = 1.0 / 255.0 * 236.0
        mtlRenderer.mtkView.clearColor = MTLClearColor(red: clearValue, green: clearValue, blue: clearValue, alpha: 1)
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                
                guard row == 1 || column == 1 || row == gridSize - 2 || column == gridSize - 2 else {continue}
                
                let square = Drawable2D.Square()
                
                guard let buf = square.uniform_buffer_source as? DefaultUniformBuffer else {
                    continue
                }
                
                buf.color = [1, 0, 0, 1]
                
                square.scale = 1.0
                square.position = [Float(row), Float(column)]
                square.rotation = 0.0
                setGridSizeCorrectMatrix(drawable: square)
                mtlRenderer.addDrawable(drawable: square)
            }
        }
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
                playerDrawable.position.y = pos.y + acceleration * Float(dt)
            }
            playerDrawable.rotation = 0.0
        }
        if pressedDown {
            if pos.y > Float(lowerBound) {
                playerDrawable.position.y = pos.y - acceleration * Float(dt)
            }
            playerDrawable.rotation = 3.14
        }
        if pressedLeft {
            if pos.x > Float(leftBound) {
                playerDrawable.position.x = pos.x - acceleration * Float(dt)
            }
            playerDrawable.rotation = 3.14 / 2
        }
        if pressedRight {
            if pos.x < Float(rightBound) {
                playerDrawable.position.x = pos.x + acceleration * Float(dt)
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
    
    @IBAction func didPressResetBtn(_ sender: NSButton) {
        self.reset()
        self.resignFirstResponder()
        mainView.becomeFirstResponder()
    }
}
