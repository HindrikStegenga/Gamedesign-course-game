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
    
    // This keeps track of the system time of the last render
    var lastRenderTime: CFTimeInterval? = nil
    // This is the current time in our app, starting at 0, in units of seconds
    var currentTime: Double = 0
    
    var updateClosure: ((CFTimeInterval)->())? = nil
    
    let mtkView: MTKView!
    let device: MTLDevice!
    let defaultCommandQueue: MTLCommandQueue!
    let library: MTLLibrary!
    let uniformUpdateSemaphore = DispatchSemaphore(value: 1)
    
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
        
        // Compute dt
        let systemTime = CACurrentMediaTime()
        let timeDifference = (lastRenderTime == nil) ? 0 : (systemTime - lastRenderTime!)
        // Save this system time
        lastRenderTime = systemTime
        
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
        
        uniformUpdateSemaphore.wait()
        updateClosure?(timeDifference)
        
        for drawable in drawables {
            
            //Uniform buf is directly mapped in host memory, so no need to notify device.
            let ptr = drawable.1.uniform_buffer.contents()
            memcpy(ptr, drawable.0.uniform_buffer_source.floatArray, sizeof(drawable.0.uniform_buffer_source.floatArray))
            
            drawable.1.draw(encoder)
        }
        
        encoder.endEncoding()
        commandBuffer.present(currentDrawable)
        commandBuffer.addCompletedHandler() {
            _ in
            self.uniformUpdateSemaphore.signal()
        }
        commandBuffer.commit()
    }
    
    func addDrawable(drawable: Drawable2D) {
        var drawable = drawable
        let mtlDrawable = MTLDrawable2D(device: device, library: library, drawable: &drawable)
        drawables.append((drawable, mtlDrawable))
    }
    
    func removeDrawable(drawable: inout Drawable2D) {
        drawables = drawables.filter {
            $0.0 !== drawable
        }
    }
    
    func clearDrawables() {
        drawables.removeAll()
    }
}
