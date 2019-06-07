//
//  MainViewController.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Cocoa

class MainViewController : NSViewController {
    
    override func viewDidLoad() {
        guard let windowContent = self.view as? MetalView else {
            fatalError("Failure")
        }
        
        windowContent.drawables.append(Triangle())
        
        windowContent.initalizeMTL()
    }
}
