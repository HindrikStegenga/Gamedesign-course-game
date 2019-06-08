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
    
    var mtlRenderer: MTLRenderer!
    
    override func viewDidLoad() {
        
        guard mtkView != nil else {
            fatalError("Failure")
        }
        
        self.mtlRenderer = MTLRenderer(mtkView: mtkView)
        
        
        let square = Drawable2D.Square()
        
        guard let buf = square.uniform_buffer_source as? DefaultUniformBuffer else {
            return
        }
        buf.matrix.setScale([0.5,0.5,1])
        mtlRenderer.addDrawable(drawable: square)
    }
}
