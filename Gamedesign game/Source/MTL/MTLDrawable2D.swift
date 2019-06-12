//
//  MTLDrawable2D.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import MetalKit
import Cocoa
import Metal

class MTLDrawable2D {
    
    let device: MTLDevice
    let library: MTLLibrary
    
    let vertex_function: MTLFunction
    let fragment_function: MTLFunction
    let vertex_buffer: MTLBuffer
    let index_buffer: MTLBuffer
    let index_count: Int
    let uniform_buffer: MTLBuffer
    let fragment_function_texture: MTLTexture?
    
    private lazy var pipeline_state: MTLRenderPipelineState = {
        
        let pplDescriptor = MTLRenderPipelineDescriptor()
        pplDescriptor.vertexFunction = vertex_function
        pplDescriptor.fragmentFunction = fragment_function
        
        pplDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        guard let ps = try? device.makeRenderPipelineState(descriptor: pplDescriptor) else {
            fatalError("Cannot create pipeline state.")
        }
        return ps
    }()
    
    init(device: MTLDevice, library: MTLLibrary, drawable: inout Drawable2D) {
        self.device = device
        self.library = library
        
        self.vertex_buffer = MTLDrawable2D.create_vertex_buffer(device, &drawable)
        self.index_buffer = MTLDrawable2D.create_index_buffer(device, &drawable)
        self.index_count = drawable.index_buffer_source.count
        
        self.uniform_buffer = MTLDrawable2D.create_uniform_buffer(device, &drawable)
        
        self.vertex_function = MTLDrawable2D.create_vertex_function(library, &drawable)
        self.fragment_function = MTLDrawable2D.create_fragment_function(library, &drawable)
        
        if let texture_name = drawable.fragment_func_texture_name {
            let nsImage = NSImage(named: texture_name)
            let cgImage = nsImage?.cgImage(forProposedRect: nil, context: nil, hints: nil)
            guard cgImage != nil else {
                fatalError("Cannot create CGImage!")
            }
            self.fragment_function_texture = MTLDrawable2D.create_texture(device, cgImage!, &drawable)
        } else {
            self.fragment_function_texture = nil
        }
        
    }
    
    func draw(_ encoder: MTLRenderCommandEncoder) {
        encoder.setRenderPipelineState(pipeline_state)
        encoder.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
        encoder.setVertexBuffer(uniform_buffer, offset: 0, index: 1)
        encoder.setFragmentBuffer(uniform_buffer, offset: 0, index: 0)
        if fragment_function_texture != nil {
            encoder.setFragmentTexture(fragment_function_texture, index: 0)
        }
        encoder.drawIndexedPrimitives(type: .triangleStrip, indexCount: index_count, indexType: .uint16, indexBuffer: index_buffer, indexBufferOffset: 0)
    }
    
    static func create_vertex_buffer(_ device: MTLDevice, _ drawable: inout Drawable2D) -> MTLBuffer {
        guard let buff = device.makeBuffer(bytes: drawable.vertex_buffer_source.floatArray, length: sizeof(drawable.vertex_buffer_source.floatArray), options: [.storageModeManaged]) else {
            fatalError("Cannot create vertex buffer!")
        }
        return buff
    }
    
    static func create_index_buffer(_ device: MTLDevice, _ drawable: inout Drawable2D) -> MTLBuffer {
        guard let buff = device.makeBuffer(bytes: drawable.index_buffer_source, length: sizeof(drawable.index_buffer_source), options: [.storageModeManaged]) else {
            fatalError("Cannot create index buffer!")
        }
        return buff
    }
    
    static func create_uniform_buffer(_ device: MTLDevice, _ drawable: inout Drawable2D) -> MTLBuffer {
        guard let buff = device.makeBuffer(bytes: drawable.uniform_buffer_source.floatArray, length: sizeof(drawable.uniform_buffer_source.floatArray), options: [.storageModeShared]) else {
            fatalError("Cannot create unfiform buffer!")
        }
        return buff
    }
    
    static func create_vertex_function(_ library: MTLLibrary, _ drawable: inout Drawable2D) -> MTLFunction {
        guard let f = library.makeFunction(name: drawable.vertex_func_name) else {
            fatalError("Cannot create vertex function!")
        }
        return f
    }
    
    static func create_fragment_function(_ library: MTLLibrary, _ drawable: inout Drawable2D) -> MTLFunction {
        guard let f = library.makeFunction(name: drawable.fragment_func_name) else {
            fatalError("Cannot create fragment function!")
        }
        return f
    }
    
    static func create_texture(_ device: MTLDevice, _ image: CGImage, _ drawable: inout Drawable2D) -> MTLTexture {
        let loader = MTKTextureLoader(device: device)
        guard let texture = try? loader.newTexture(cgImage: image, options: nil) else {
            fatalError("Cannot create texture!")
        }
        return texture
    }
}
