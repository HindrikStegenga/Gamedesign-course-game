//
//  MTLRenderer.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import MetalKit
import Metal

class MTLRenderer : NSObject, MTKViewDelegate {
    
    var drawables: [(Drawable2D, MTLDrawable2D)] = []
    
    let mtkView: MTKView!
    let device: MTLDevice!
    let defaultCommandQueue: MTLCommandQueue!
    let library: MTLLibrary!
    
    
    init(mtkView: MTKView) {
        self.mtkView = mtkView
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
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
        
        super.init()
        mtkView.device = self.device
        mtkView.delegate = self
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        
        guard let rpd = view.currentRenderPassDescriptor, let currentDrawable = view.currentDrawable else {
            print("Error occurred fetching rpd and drawable.")
            return
        }
        
        rpd.colorAttachments[0].texture = currentDrawable.texture
        rpd.colorAttachments[0].clearColor = view.clearColor
        rpd.colorAttachments[0].loadAction = .clear
        
        guard let commandBuffer = defaultCommandQueue.makeCommandBuffer() else {
            print("Error occurred fetching commandbuffer.")
            return
        }
        
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: rpd) else {
            print("Error occurred fetching renderCommandEncoder.")
            return
        }
        
        for drawable in drawables {
            drawable.1.draw(encoder)
        }
        
        encoder.endEncoding()
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
    }
    
    func addDrawable(drawable: Drawable2D) {
        var drawable = drawable
        let mtlDrawable = MTLDrawable2D(device: device, library: library, drawable: &drawable)
        drawables.append((drawable, mtlDrawable))
    }
}
