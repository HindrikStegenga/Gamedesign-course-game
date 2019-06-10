//
//  Matrix.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import simd

struct Matrix {
    static func makeTranslationMatrix(tx: Float, ty: Float) -> matrix_float4x4 {
        var matrix = matrix_identity_float4x4
        
        matrix[0,3] = tx
        matrix[1,3] = ty
        
        return matrix
    }
    
    static func makeRotationMatrix(angle: Float) -> simd_float4x4 {
        let rows = [
            simd_float4( cos(angle), sin(angle), 0, 0),
            simd_float4(-sin(angle), cos(angle), 0, 0),
            simd_float4( 0,          0,          1, 0),
            simd_float4( 0,          0,          0, 1)
        ]
        
        return float4x4(rows: rows)
    }
    
    static func makeScaleMatrix(xScale: Float, yScale: Float) -> simd_float4x4 {
        let rows = [
            simd_float4(xScale,      0,     0,      0),
            simd_float4(     0, yScale,     0,      0),
            simd_float4(     0,      0,     1,      0),
            simd_float4(     0,      0,     0,      1)
        ]
        
        return float4x4(rows: rows)
    }
}
