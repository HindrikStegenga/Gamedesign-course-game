//
//  default_shaders.metal
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float2 texture_coord;
    float2 padding;
};

struct UniformBuffer {
    float4x4 modelMatrix;
    float4 color;
};

vertex Vertex default_vertex_func(constant Vertex *vertices [[buffer(0)]],
                                  constant UniformBuffer &uniforms [[buffer(1)]],
                                  uint vid [[vertex_id]]) {

    float4x4 matrix = uniforms.modelMatrix;
    Vertex in = vertices[vid];
    Vertex out;
    out.position = matrix * float4(in.position);
    out.texture_coord = in.texture_coord;
    return out;
}

fragment float4 default_fragment_func(Vertex vert [[stage_in]], constant UniformBuffer &uniforms [[buffer(0)]]) {
    float2 uv = vert.texture_coord;
    uv = uv * 2.0 - 1.0;
    bool inside = length(uv) < 0.5;
    
    return inside ? float4(0) : uniforms.color;
}
