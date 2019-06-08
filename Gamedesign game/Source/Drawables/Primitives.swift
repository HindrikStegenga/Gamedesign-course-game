//
//  Primitives.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Metal

extension Drawable2D {
    
    static func Triangle() -> Drawable2D {
        
        var vertices: [Float] = []
        vertices.append(contentsOf: Vertex(position: [-1.0, -1.0, 0.0, 1.0], texture_coord: [0.0, 1.0]).values)
        vertices.append(contentsOf: Vertex(position: [1.0, -1.0, 0.0, 1.0], texture_coord: [0.5, 0.0]).values)
        vertices.append(contentsOf: Vertex(position: [0.0, 1.0, 0.0, 1.0], texture_coord: [1.0, 1.0]).values)
        
        return Drawable2D(position: (0.0 ,0.0), rotation: 0.0, vertices: vertices, indices: [
                0,1,2
            ], uniform: DefaultUniformBuffer())
    }
    
    static func Square() -> Drawable2D {
        var vertices: [Float] = []
        vertices.append(contentsOf: Vertex(position: [-1.0, -1.0, 0.0, 1.0], texture_coord: [0.0, 1.0]).values)
        vertices.append(contentsOf: Vertex(position: [1.0, -1.0, 0.0, 1.0], texture_coord: [1.0, 1.0]).values)
        vertices.append(contentsOf: Vertex(position: [1.0, 1.0, 0.0, 1.0], texture_coord: [1.0, 0.0]).values)
        vertices.append(contentsOf: Vertex(position: [-1.0, 1.0, 0.0, 1.0], texture_coord: [0.0, 0.0]).values)
        
        return Drawable2D(position: (0.0 ,0.0), rotation: 0.0, vertices: vertices, indices: [
                0,1,2,2,0,3
            ], uniform: DefaultUniformBuffer())
    }
    
}
