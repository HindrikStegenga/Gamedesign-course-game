//
//  EndGameViewController.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 19/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Cocoa

class EndGameViewController : NSViewController, NSWindowDelegate {
    @IBOutlet weak var scoreLabel: NSTextField!
    
    var delegate: (()->())? = nil
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.window?.delegate = self
        self.scoreLabel.stringValue = "You scored: \(score)"
    }
    
    func windowWillClose(_ notification: Notification) {
        self.delegate?()
    }
    
    @IBAction func didPressNewGameBtn(_ sender: NSButton) {
        self.view.window?.performClose(nil)
    }
    
    @IBAction func didPressQuitBtn(_ sender: NSButton) {
        NSApplication.shared.terminate(nil)
    }
}
