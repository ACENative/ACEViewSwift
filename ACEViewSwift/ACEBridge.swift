//
//  ACEBridge.swift
//  ACEViewSwift
//
//  Created by Vasilis Akoinoglou on 20/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import Foundation
import WebKit

class ACEBridgedObject {
    
    /// The underlying JSValue of the object
    var jsValue: JSValue
    
    /// The designated initializer for all ACEBridgedObjects
    init(jsValue: JSValue) {
        self.jsValue = jsValue
    }
    
    /**
     This function translates a native call to the respective JS one.
     _Note:_ By default it directly translates a call based on the caller signature
     */
    func jsCall(functionName: String = __FUNCTION__, arguments: [AnyObject]! = nil) -> JSValue {
        let selector = functionName.stringByReplacingOccurrencesOfString("()", withString: "")
        return jsValue.invokeMethod(selector, withArguments: arguments)
    }
    
}

/*--------------------------------------------------------------------------------*/

class ACESession: ACEBridgedObject {
    
    func getOption(option: String) -> JSValue {
        return jsCall(arguments: [option])
    }
    
    func setOptions(options: [String:AnyObject]) {
        jsCall(arguments: [options])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getMode() -> ACEMode {
        let modeName = getOption("mode").toString().componentsSeparatedByString("/")
        return ACEMode(name: modeName.last!)
    }

    func setMode(mode: ACEMode, inline: Bool = false) {
        let modeName = mode.name
        let args = [
            "path": "ace/mode/\(modeName)",
            "inline": inline
        ]
        jsCall("setMode", arguments: [args])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getUseWrapMode() -> Bool {
        return jsCall().toBool()
    }
    
    func setUseWrapMode(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getWrapLimitRange() -> NSRange {
        let range = jsCall().toDictionary()
        let min = (range["min"] as? Int) ?? 0
        let max = (range["max"] as? Int) ?? 0
        return NSRange(location: min, length: max)
    }
    
    func setWrapLimitRange(range: NSRange) {
        setUseWrapMode(true)
        jsCall(arguments: [range.location, range.length])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getLength() -> Int {
        return Int(jsCall().toInt32())
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getLine(line: Int) -> String {
        return jsCall(arguments: [line]).toString()
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getNewLineMode() -> String {
        return jsCall().toString()
    }
    
    func setNewLineMode(mode: String) {
        jsCall(arguments: [mode])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getUseSoftTabs() -> Bool {
        return jsCall().toBool()
    }
    
    func setUseSoftTabs(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getTabSize() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setTabSize(size: Int) {
        jsCall(arguments: [size])
    }
    
}

/*--------------------------------------------------------------------------------*/

class ACEEditor: ACEBridgedObject {

    var string: String {
        get {
            return getValue()
        }
        set {
            jsValue.context.evaluateScript("reportChanges = false;")
            setValue(newValue)
            jsCall("clearSelection")
            jsCall("moveCursorTo", arguments: [0,0])
            jsValue.context.evaluateScript("reportChanges = true;")
            jsValue.context.evaluateScript("ACEView.aceTextDidChange();")
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getValue() -> String {
        return jsCall().toString()
    }
    
    func setValue(value: String) {
        jsCall(arguments:[value])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getSession() -> ACESession {
        return ACESession(jsValue: jsCall())
    }
    
    /*--------------------------------------------------------------------------------*/

    func getTheme() -> ACETheme {
        let themeName = getOption("theme").toString().componentsSeparatedByString("/")
        return ACETheme(name: themeName.last!)
    }
    
    func setTheme(theme: ACETheme) {
        jsCall(arguments: ["ace/theme/\(theme.name)"])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getWrapBehavioursEnabled() -> Bool {
        return jsCall().toBool()
    }
    
    func setWrapBehavioursEnabled(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getShowInvisibles() -> Bool {
        return jsCall().toBool()
    }
    
    func setShowInvisibles(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getReadOnly() -> Bool {
        return jsCall().toBool()
    }
    
    func setReadOnly(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getShowFoldWidgets() -> Bool {
        return jsCall().toBool()
    }
    
    func setShowFoldWidgets(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getFadeFoldWidgets() -> Bool {
        return jsCall().toBool()
    }
    
    func setFadeFoldWidgets(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getHighlightActiveLine() -> Bool {
        return jsCall().toBool()
    }
    
    func setHighlightActiveLine(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getHighlightGutterLine() -> Bool {
        return jsCall().toBool()
    }
    
    func setHighlightGutterLine(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getHighlightSelectedWord() -> Bool {
        return jsCall().toBool()
    }
    
    func setHighlightSelectedWord(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getDisplayIndentGuides() -> Bool {
        return jsCall().toBool()
    }
    
    func setDisplayIndentGuides(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getAnimatedScroll() -> Bool {
        return jsCall().toBool()
    }
    
    func setAnimatedScroll(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/

    func getScrollSpeed() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setScrollSpeed(speed: Int) {
        jsCall(arguments: [speed])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getKeyboardHandler() -> ACEKeyboardHandler {
        let handler = jsCall().toDictionary()
        if let id = handler["$id"] as? String {
            switch id {
                case "ace/keyboard/vim": return .Vim
                case "ace/keyboard/emacs": return .Emacs
                default: break
            }
        }
        return .Ace
    }
    
    func setKeyboardHandler(handler: ACEKeyboardHandler) {
        jsValue.context.evaluateScript("editor.setKeyboardHandler(\(handler.command))")
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getOption(option: String) -> JSValue {
        return jsCall(arguments: [option])
    }
    
    func setOptions(options: [String:AnyObject]) {
        jsCall(arguments: [options])
    }
    
    /*--------------------------------------------------------------------------------*/

    var basicAutocomplete: Bool {
        get {
            return getOption("enableBasicAutocompletion").toBool()
        }
        set {
            let options = ["enableBasicAutocompletion":newValue]
            setOptions(options)
        }
    }

    /*--------------------------------------------------------------------------------*/

    var enableLiveAutocompletion: Bool {
        get {
            return getOption("enableLiveAutocompletion").toBool()
        }
        set {
            let options = ["enableLiveAutocompletion":newValue]
            setOptions(options)
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var enableSnippets: Bool {
        get {
            return getOption("enableSnippets").toBool()
        }
        set {
            let options = ["enableSnippets":newValue]
            setOptions(options)
        }
    }
    
    /*--------------------------------------------------------------------------------*/

    var emmet: Bool {
        get {
            return getOption("emmet").toBool()
        }
        set {
            let options = ["emmet":newValue]
            setOptions(options)
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getPrintMarginColumn() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setPrintMarginColumn(margin: Int) {
        jsCall(arguments: [margin])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getShowPrintMargin() -> Bool {
        return jsCall().toBool()
    }
    
    func setShowPrintMargin(flag: Bool) {
        jsCall(arguments: [flag])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getFontSize() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setFontSize(size: Int) {
        jsCall(arguments: [size])
    }
    
    /*--------------------------------------------------------------------------------*/

    var fontFamily: String {
        get {
            let family = getOption("fontFamily").toString()
            return family == "undefined" ? "None" : family
        }
        set {
            let options = ["fontFamily":newValue]
            setOptions(options)
        }
    }
    
    /*--------------------------------------------------------------------------------*/

    func goToLine(line: Int, column:Int, animated: Bool) {
        jsCall(arguments: [line, column, animated])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var showLineNumbers: Bool {
        get {
            return getOption("showLineNumbers").toBool()
        }
        set {
            let options = ["showLineNumbers":newValue]
            setOptions(options)
        }
    }
    
    /*--------------------------------------------------------------------------------*/

    var showGutter: Bool {
        get {
            return getOption("showGutter").toBool()
        }
        set {
            let options = ["showGutter":newValue]
            setOptions(options)
        }
    }
    
}

class ACEContext {

    private var jsContext: JSContext
    
    weak var aceView: ACEView? {
        didSet {
            jsContext.setObject(aceView, forKeyedSubscript: "ACEView")
        }
    }
    
    var editor: ACEEditor
    
    var exceptionHandler: ((JSContext!, JSValue!) -> Void)! {
        didSet {
            jsContext.exceptionHandler = exceptionHandler
        }
    }
    
    init(context: JSContext) {
        self.jsContext = context
        self.editor = ACEEditor(jsValue: context.objectForKeyedSubscript("editor"))
    }

    func evaluateScript(script: String) -> JSValue! {
        return jsContext.evaluateScript(script)
    }

    func focusEditor() {
        jsContext.evaluateScript("focusEditor();")
    }
    
}