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
    @discardableResult func jsCall(_ functionName: String = #function, arguments: [AnyObject]! = nil) -> JSValue {
        let selector = functionName.replacingOccurrences(of: "()", with: "")
        return jsValue.invokeMethod(selector, withArguments: arguments)
    }
    
}

/*--------------------------------------------------------------------------------*/

class ACESession: ACEBridgedObject {
    
    func getOption(_ option: String) -> JSValue {
        return jsCall(arguments: [option as AnyObject])
    }
    
    func setOptions(_ options: [String:AnyObject]) {
        jsCall(arguments: [options as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getMode() -> ACEMode {
        var modeName = getOption("mode").toString().components(separatedBy: "/").last!
        modeName = modeName.replacingOccurrences(of: "-inline$", with: "", options: .regularExpression)
        return ACEMode(name: modeName)
    }
    
    func setMode(_ mode: ACEMode, inline: Bool = false) {
        let modeName = mode.name
        let args = [
            "path": "ace/mode/\(modeName)",
            "inline": inline
        ] as [String : Any]
        jsCall("setMode", arguments: [args as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getUseWrapMode() -> Bool {
        return jsCall().toBool()
    }
    
    func setUseWrapMode(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getWrapLimitRange() -> NSRange {
        let range = jsCall().toDictionary()
        let min = (range?["min"] as? Int) ?? 0
        let max = (range?["max"] as? Int) ?? 0
        return NSRange(location: min, length: max)
    }
    
    func setWrapLimitRange(_ range: NSRange) {
        setUseWrapMode(true)
        jsCall(arguments: [range.location as AnyObject, range.length as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getLength() -> Int {
        return Int(jsCall().toInt32())
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getLine(_ line: Int) -> String {
        return jsCall(arguments: [line as AnyObject]).toString()
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getNewLineMode() -> String {
        return jsCall().toString()
    }
    
    func setNewLineMode(_ mode: String) {
        jsCall(arguments: [mode as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getUseSoftTabs() -> Bool {
        return jsCall().toBool()
    }
    
    func setUseSoftTabs(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getTabSize() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setTabSize(_ size: Int) {
        jsCall(arguments: [size as AnyObject])
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
            jsCall("moveCursorTo", arguments: [0 as AnyObject,0 as AnyObject])
            jsValue.context.evaluateScript("reportChanges = true;")
            jsValue.context.evaluateScript("editor.getSession().setUndoManager(new ace.UndoManager());")
            jsValue.context.evaluateScript("ACEView.aceTextDidChange();")
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getValue() -> String {
        return jsCall().toString()
    }
    
    func setValue(_ value: String) {
        jsCall(arguments:[value as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getSession() -> ACESession {
        return ACESession(jsValue: jsCall())
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getTheme() -> ACETheme {
        let themeName = getOption("theme").toString().components(separatedBy: "/")
        return ACETheme(name: themeName.last!)
    }
    
    func setTheme(_ theme: ACETheme) {
        jsCall(arguments: ["ace/theme/\(theme.name)" as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getWrapBehavioursEnabled() -> Bool {
        return jsCall().toBool()
    }
    
    func setWrapBehavioursEnabled(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getShowInvisibles() -> Bool {
        return jsCall().toBool()
    }
    
    func setShowInvisibles(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getReadOnly() -> Bool {
        return jsCall().toBool()
    }
    
    func setReadOnly(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getShowFoldWidgets() -> Bool {
        return jsCall().toBool()
    }
    
    func setShowFoldWidgets(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getFadeFoldWidgets() -> Bool {
        return jsCall().toBool()
    }
    
    func setFadeFoldWidgets(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getHighlightActiveLine() -> Bool {
        return jsCall().toBool()
    }
    
    func setHighlightActiveLine(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getHighlightGutterLine() -> Bool {
        return jsCall().toBool()
    }
    
    func setHighlightGutterLine(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getHighlightSelectedWord() -> Bool {
        return jsCall().toBool()
    }
    
    func setHighlightSelectedWord(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getDisplayIndentGuides() -> Bool {
        return jsCall().toBool()
    }
    
    func setDisplayIndentGuides(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getAnimatedScroll() -> Bool {
        return jsCall().toBool()
    }
    
    func setAnimatedScroll(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getScrollSpeed() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setScrollSpeed(_ speed: Int) {
        jsCall(arguments: [speed as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getKeyboardHandler() -> ACEKeyboardHandler {
        let handler = jsCall().toDictionary()
        if let id = handler?["$id"] as? String {
            switch id {
            case "ace/keyboard/vim": return .vim
            case "ace/keyboard/emacs": return .emacs
            default: break
            }
        }
        return .ace
    }
    
    func setKeyboardHandler(_ handler: ACEKeyboardHandler) {
        jsValue.context.evaluateScript("editor.setKeyboardHandler(\(handler.command))")
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getOption(_ option: String) -> JSValue {
        return jsCall(arguments: [option as AnyObject])
    }
    
    func setOptions(_ options: [String:AnyObject]) {
        jsCall(arguments: [options as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var basicAutocomplete: Bool {
        get {
            return getOption("enableBasicAutocompletion").toBool()
        }
        set {
            let options = ["enableBasicAutocompletion":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var enableLiveAutocompletion: Bool {
        get {
            return getOption("enableLiveAutocompletion").toBool()
        }
        set {
            let options = ["enableLiveAutocompletion":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var enableSnippets: Bool {
        get {
            return getOption("enableSnippets").toBool()
        }
        set {
            let options = ["enableSnippets":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var emmet: Bool {
        get {
            return getOption("emmet").toBool()
        }
        set {
            let options = ["emmet":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getPrintMarginColumn() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setPrintMarginColumn(_ margin: Int) {
        jsCall(arguments: [margin as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getShowPrintMargin() -> Bool {
        return jsCall().toBool()
    }
    
    func setShowPrintMargin(_ flag: Bool) {
        jsCall(arguments: [flag as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func getFontSize() -> Int {
        return Int(jsCall().toInt32())
    }
    
    func setFontSize(_ size: Int) {
        jsCall(arguments: [size as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var fontFamily: String {
        get {
            let family = getOption("fontFamily").toString()
            return family! == "undefined" ? "None" : family!
        }
        set {
            let options = ["fontFamily":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    func goToLine(_ line: Int, column:Int, animated: Bool) {
        jsCall(arguments: [line as AnyObject, column as AnyObject, animated as AnyObject])
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var showLineNumbers: Bool {
        get {
            return getOption("showLineNumbers").toBool()
        }
        set {
            let options = ["showLineNumbers":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
    /*--------------------------------------------------------------------------------*/
    
    var showGutter: Bool {
        get {
            return getOption("showGutter").toBool()
        }
        set {
            let options = ["showGutter":newValue]
            setOptions(options as [String : AnyObject])
        }
    }
    
}

class ACEContext {
    
    fileprivate var jsContext: JSContext
    
    weak var aceView: ACEView? {
        didSet {
            jsContext.setObject(aceView, forKeyedSubscript: "ACEView" as (NSCopying & NSObjectProtocol)!)
        }
    }
    
    var editor: ACEEditor
    
    var exceptionHandler: ((JSContext?, JSValue?) -> Void)! {
        didSet {
            jsContext.exceptionHandler = exceptionHandler 
        }
    }
    
    init(context: JSContext) {
        self.jsContext = context
        self.editor = ACEEditor(jsValue: context.objectForKeyedSubscript("editor"))
    }
    
    @discardableResult
    func evaluateScript(_ script: String) -> JSValue! {
        return jsContext.evaluateScript(script)
    }
    
    func focusEditor() {
        jsContext.evaluateScript("focusEditor();")
    }
    
}
