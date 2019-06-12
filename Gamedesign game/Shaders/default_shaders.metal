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
    
    constexpr float value = 1.0 / 255.0 * 236.0;
    return inside ? float4(value) : uniforms.color;
}

constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);

fragment float4 player_fragment_func(Vertex vert [[stage_in]], constant UniformBuffer &uniforms [[buffer(0)]], texture2d<float> colorTexture [[texture(0)]]) {
    float2 uv = vert.texture_coord;
    float4 color = colorTexture.sample(textureSampler, vert.texture_coord);
    if (color.a < 0.1) {
        discard_fragment();
    }
    return color;
    
    bool line = false;
    float lineThickness = 0.25;
    
    if (uv.y > 1.0 - lineThickness) {
        line = true;
    }
    
    if (uv.x < 0.5 + (lineThickness/2)) {
        //calculate coord
        float xpoint = ((1 - uv.y) * 0.5);
        if (uv.x > xpoint - (lineThickness/2) && uv.x < xpoint + (lineThickness/2)) {
            line = true;
        }
    }
    
    if (uv.x > 0.5 - (lineThickness/2)) {
        //calculate coord
        float xpoint = ((uv.y) * 0.5) + 0.5;
        if (uv.x > xpoint - (lineThickness/2) && uv.x < xpoint + (lineThickness/2)) {
            line = true;
        }
    }
    
    return line ? uniforms.color : float4(0);
}
