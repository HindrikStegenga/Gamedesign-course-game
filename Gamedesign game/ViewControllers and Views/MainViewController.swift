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
    var gridSize: Int = 50
    
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
    
    func setupWorld() {
        
        let width = Float(mtkView.drawableSize.width)
        let height = Float(mtkView.drawableSize.height)
        
        playerDrawable = Drawable2D.Square()
        guard let playerBuf = playerDrawable.uniform_buffer_source as? DefaultUniformBuffer else { return }
        
        
        playerBuf.color = [1,1,0,1]
        playerDrawable.position = [Float(gridSize)/2,Float(gridSize/2)]
        playerDrawable.scale = 1.0
        setGridSizeCorrectMatrix(drawable: playerDrawable)
        mtlRenderer.addDrawable(drawable: playerDrawable)
        
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                
                guard row == 1 || column == 1 || row == gridSize - 2 || column == gridSize - 2 else {continue}
                
                let square = Drawable2D.Square()
                
                guard let buf = square.uniform_buffer_source as? DefaultUniformBuffer else {
                    continue
                }
                
                buf.color = [0.82, 0.04, 0.04, 1]
                
                buf.matrix.setScale([Float(1 / width * (width / Float(gridSize))), Float(1 / height * (height / Float(gridSize))), 0.0])
                
                let posX = Float.remap(Float(row) + 0.5, 0, Float(gridSize), -1, 1)
                let posY = Float.remap(Float(column) + 0.5, 0, Float(gridSize), -1, 1)
                
                buf.matrix.setPosition([posX, posY, 0])
                
                
                mtlRenderer.addDrawable(drawable: square)
            }
        }
    }
    
    func setGridSizeCorrectMatrix(drawable: Drawable2D) {
        guard let buf = drawable.uniform_buffer_source as? DefaultUniformBuffer else { return }
        
        let width = Float(mtkView.drawableSize.width)
        let height = Float(mtkView.drawableSize.height)
        buf.matrix = Matrix()
        
        let posX = Float.remap(drawable.position.x + 0.5, 0, Float(gridSize), -1, 1)
        let posY = Float.remap(drawable.position.y + 0.5, 0, Float(gridSize), -1, 1)
        
        buf.matrix.setPosition([posX, posY, 0])
        buf.matrix.setRotation([0,0,0])
        buf.matrix.setScale([Float(1 / width * (width / Float(gridSize))) * drawable.scale, Float(1 / height * (height / Float(gridSize))) * drawable.scale, 0.0])
    }
    
    func update(dt: CFTimeInterval) {
        
        let pos = playerDrawable.position
        let acceleration : Float = 15.0
        
        if pressedUp {
            playerDrawable.position.y = pos.y + acceleration * Float(dt)
        }
        if pressedDown {
            playerDrawable.position.y = pos.y - acceleration * Float(dt)
        }
        if pressedLeft {
            playerDrawable.position.x = pos.x - acceleration * Float(dt)
        }
        if pressedRight {
            playerDrawable.position.x = pos.x + acceleration * Float(dt)
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
}
