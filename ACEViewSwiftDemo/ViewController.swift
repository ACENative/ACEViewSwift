//
//  ViewController.swift
//  ACEViewSwiftDemo
//
//  Created by Vasilis Akoinoglou on 25/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import Cocoa
import ACEViewSwift

class ViewController: NSViewController {

    @IBOutlet weak var aceView: ACEView!
    @IBOutlet weak var syntaxPopup: NSPopUpButton!
    @IBOutlet weak var themePopup: NSPopUpButton!
    @IBOutlet weak var keyboardHandlerPopup: NSPopUpButton!
    
    let syntaxModes = ACEMode.humanModeNames()
    let themes      = ACETheme.humanThemeNames()
    let handlers    = ACEKeyboardHandler.humanNames()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let htmlFilePath = NSBundle.mainBundle().pathForResource("HTML5", ofType: "html")!
        let html = try! String(contentsOfFile: htmlFilePath, encoding: NSUTF8StringEncoding)
        
        syntaxPopup.selectItemAtIndex(ACEMode.HTML.rawValue)
        themePopup.selectItemAtIndex(ACETheme.Xcode.rawValue)
        keyboardHandlerPopup.selectItemAtIndex(ACEKeyboardHandler.Ace.rawValue)
        
        aceView.onReady = { [unowned self] in
            self.aceView.string = html
            self.aceView.mode = .HTML
            self.aceView.theme = .Xcode
            self.aceView.keyboardHandler = .Ace
            self.aceView.showPrintMargin = true
            self.aceView.showInvisibles = false
            self.aceView.basicAutoCompletion = true
            self.aceView.liveAutocompletion = true
            self.aceView.snippets = true
            self.aceView.emmet = true
            self.aceView.focus()
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func syntaxModeChanged(sender: NSPopUpButton) {
        aceView.mode = ACEMode(rawValue: sender.indexOfSelectedItem)!
    }

    @IBAction func themeChanged(sender: NSPopUpButton) {
        aceView.theme = ACETheme(rawValue: sender.indexOfSelectedItem)!
    }
    
    @IBAction func keyboardHandlerChanged(sender: NSPopUpButton) {
        aceView.keyboardHandler = ACEKeyboardHandler(rawValue: sender.indexOfSelectedItem)!
    }

}

