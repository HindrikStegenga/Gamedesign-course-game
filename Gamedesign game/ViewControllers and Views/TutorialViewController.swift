//
//  TutorialVC.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 17/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Cocoa

class TutorialViewController : NSViewController {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var continueButton: NSButton!
    
    let textSets: [String] = [
        """
        Ow no... the dreaded day has come! The day of your retirement!
        Sadly, your hair is becoming gray, but today is also your lucky day.
        You won a coupon to do free shopping at the grocery store.
        You must collect as many anti-gray-hair shampoo bottles as you can in one minute.
        3... 2... 1...
        """
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.string = textSets.first!
    }
    
    
    @IBAction func didPressContinueBtn(_ sender: NSButton) {
        self.view.window?.performClose(nil)
    }
}
