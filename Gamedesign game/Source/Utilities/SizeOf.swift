//
//  SizeOf.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation

func sizeof <T> (_ : T.Type) -> Int
{
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ : T) -> Int
{
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ value : [T]) -> Int
{
    return (MemoryLayout<T>.size * value.count)
}

func strideof <T> (_ : T.Type) -> Int
{
    return (MemoryLayout<T>.stride)
}

func strideof <T> (_ : T) -> Int
{
    return (MemoryLayout<T>.stride)
}

func strideof <T> (_ value : [T]) -> Int
{
    return (MemoryLayout<T>.stride * value.count)
}
