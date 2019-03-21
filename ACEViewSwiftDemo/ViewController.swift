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
    
    @objc dynamic let syntaxModes = ACEMode.humanModeNames()
    @objc dynamic let themes      = ACETheme.humanThemeNames()
    @objc dynamic let handlers    = ACEKeyboardHandler.humanNames()

    override func viewDidLoad() {
        super.viewDidLoad()

        let htmlFilePath = Bundle.main.path(forResource: "HTML5", ofType: "html")!
        let html = try! String(contentsOfFile: htmlFilePath, encoding: String.Encoding.utf8)
        
        syntaxPopup.selectItem(at: ACEMode.html.rawValue)
        themePopup.selectItem(at: ACETheme.xcode.rawValue)
        keyboardHandlerPopup.selectItem(at: ACEKeyboardHandler.ace.rawValue)
        
        aceView.onReady = { [unowned self] in
            self.aceView.string = html
            self.aceView.mode = .html
            self.aceView.theme = .xcode
            self.aceView.keyboardHandler = .ace
            self.aceView.showPrintMargin = true
            self.aceView.showInvisibles = false
            self.aceView.basicAutoCompletion = true
            self.aceView.liveAutocompletion = true
            self.aceView.snippets = true
            self.aceView.emmet = true
            self.aceView.focus()
        }
    }

    @IBAction func syntaxModeChanged(_ sender: NSPopUpButton) {
        aceView.mode = ACEMode(rawValue: sender.indexOfSelectedItem)!
    }

    @IBAction func themeChanged(_ sender: NSPopUpButton) {
        aceView.theme = ACETheme(rawValue: sender.indexOfSelectedItem)!
    }
    
    @IBAction func keyboardHandlerChanged(_ sender: NSPopUpButton) {
        aceView.keyboardHandler = ACEKeyboardHandler(rawValue: sender.indexOfSelectedItem)!
    }

}

