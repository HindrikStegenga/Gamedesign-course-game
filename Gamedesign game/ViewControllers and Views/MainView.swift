//
//  MainView.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Cocoa
import MetalKit

class MainView : NSView {
    
    var keyDownDelegate: ((NSEvent)->())! = nil
    var keyUpDelegate: ((NSEvent)->())! = nil
    
    override func keyDown(with event: NSEvent) {
        keyDownDelegate?(event)
    }
    
    override func keyUp(with event: NSEvent) {
        keyUpDelegate?(event)
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
}
