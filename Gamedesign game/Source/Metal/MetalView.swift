//
//  ViewController.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Cocoa
import MetalKit

class MetalView: MTKView {
    
    var drawables: [Drawable] = []
    var library: MTLLibrary! = nil
    
    var defaultCommandQueue: MTLCommandQueue! = nil
    
    func initalizeMTL() {
        self.device = MTLCreateSystemDefaultDevice()
        guard self.device != nil else {
            fatalError("Cannot retrieve MTLDevice.")
        }
        
        self.defaultCommandQueue = self.device?.makeCommandQueue()
        guard self.defaultCommandQueue != nil else {
            fatalError("Cannot retrieve MTLCommandQueue.")
        }
        self.library = self.device!.makeDefaultLibrary()
        guard self.library != nil else {
            fatalError("Cannot retrieve default MTLLibrary.")
        }
        
        //Black clear color for the attached framebuffer
        self.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //Execute rendering process here!
        
        guard let rpd = currentRenderPassDescriptor, let currentDrawable = currentDrawable else {
            print("Error occurred fetching rpd and drawable.")
            return
        }
        
        rpd.colorAttachments[0].texture = currentDrawable.texture
        rpd.colorAttachments[0].clearColor = self.clearColor
        rpd.colorAttachments[0].loadAction = .clear
        
        guard let commandBuffer = defaultCommandQueue.makeCommandBuffer() else {
            print("Error occurred fetching commandbuffer.")
            return
        }
        
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: rpd) else {
            print("Error occurred fetching renderCommandEncoder.")
            return
        }
        
        for var drawable in drawables {
            drawable.render_drawable(device: device!, library: library, commandEncoder: encoder)
        }
        
        encoder.endEncoding()
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}

