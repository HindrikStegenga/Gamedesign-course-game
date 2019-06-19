//
//  TutorialVC.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 17/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Cocoa

class TutorialViewController : NSViewController, NSWindowDelegate {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var continueButton: NSButton!
    
    var delegate: (()->())? = nil
    
    let textSets: [String] = [
        """
        Ow no... the dreaded day has come! The day of your retirement!
        Sadly, your hair is falling out, but today is also your lucky day.
        You won a coupon to do a minute of free shopping at the grocery store.
        You must collect as many hair-care bottles as you can in one minute.
        3... 2... 1...
        """
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.view.window?.delegate = self
        textView.string = textSets.first!
    }
    
    
    func windowWillClose(_ notification: Notification) {
        self.delegate?()
    }
    
    @IBAction func didPressContinueBtn(_ sender: NSButton) {
        self.view.window?.performClose(nil)
    }
}
