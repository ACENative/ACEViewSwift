//
//  ACEView.swift
//  ACEViewSwift
//
//  Created by Vasilis Akoinoglou on 18/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import Cocoa
import WebKit

let ACE_JAVASCRIPT_DIRECTORY = "___ACE_VIEW_JAVASCRIPT_DIRECTORY___"
public let ACETextDidEndEditingNotification = "ACETextDidEndEditingNotification"

// MARK: ACEViewDelegate

/** 
 The ACEViewDelegate protocol is implemented by objects that wish to monitor the ACEView for content changes. 
 */
@objc public protocol ACEViewDelegate {
    
    /**
     Posts a notification that the text has changed and forwards this message to the delegate if it responds.

     - Parameter notification: The ACETextDidEndEditingNotification notification that is posted to the default notification center.
    */
    optional func textDidChange(notification: NSNotification)
    
    /** Provides the print settings to be used for a print job. Defaults to application shared settings.*/
    optional func printInformation() -> NSPrintInfo
    
    /** Provides the desired font size for printing. Defaults to 10px */
    optional func printFontSize() -> Int
    
    /** Provides the desired height for page headers and footers. Defaults to 0.0px */
    optional func printHeaderHeight() -> Float
    optional func printFooterHeight() -> Float
    
    /** Draws the headers and footers. Defaults to no headers and footers */
    optional func drawPrintHeaderForPage(page: Int, inRect: NSRect)
    optional func drawPrintFooterForPage(page: Int, inRect: NSRect)
    
    /** Called before starting and ending a print job */
    optional func startPrintOperation(printOperation: NSPrintOperation)
    optional func endPrintOperation()
    
    /** Called after the ACEView has been loaded */
    optional func aceViewDidLoad()
}


// MARK: - ACEView

// Exported methods to JSContext
@objc protocol ACEViewJSExports : JSExport {
    func aceTextDidChange()
}

/**
 This class provides the main public interface for the ACEView. 
 */
@objc public class ACEView: NSScrollView, NSTextFinderClient, WebFrameLoadDelegate, WebUIDelegate, ACEViewJSExports {
    
    private var editor: ACEEditor!
    
    /**
     The ACEView delegate.
     
     - SeeAlso: ACEViewDelegate
     */
    public var delegate: ACEViewDelegate?
    
    public var firstSelectedRange: NSRange = NSRange()
    
    /*--------------------------------------------------------------------------------*/
    
    // MARK: - ACEView interaction
    
    /** 
     Sets the cursor to the editor view.
    */
    public func focus() {
        context.focusEditor()
    }
    
    /**
     Retrieve and Set the content of the underlying ACE Editor.
     
     Uses [editor.getValue()](http://ace.ajax.org/#Editor.getValue) & [editor.setValue()](http://ace.ajax.org/#Editor.setValue).
     
     - Returns: The ACE Editor content.
     */
    public var string: String {
        get {
            return editor.string
        }
        set {
            editor.string = newValue
        }
    }
    
    /**
     Set the syntax highlighting mode.
     
     Uses [editor.getSession().setMode()](http://ace.ajax.org/#EditSession.setMode).
     
     - SeeAlso: ACEMode
     */
    public var mode: ACEMode {
        get {
            return editor.getSession().getMode()
        }
        set {
            editor.getSession().setMode(newValue)
        }
    }
    
    /**
     Set the syntax highlighting mode with an inline parameter.
     
     Uses [editor.getSession().setMode()](http://ace.ajax.org/#EditSession.setMode).
     
     - SeeAlso: ACEMode
     */
    public func setMode(mode: ACEMode, inline: Bool) {
        editor.getSession().setMode(mode, inline: inline)
    }
    
    /**
     Set the theme.
     
     Uses [editor.setTheme()](http://ace.ajax.org/#Editor.setTheme).
     
     - SeeAlso: ACETheme
     */
    public var theme: ACETheme {
        get {
            return editor.getTheme()
        }
        set {
            editor.setTheme(newValue)
        }
    }
    
    /**
     Turn wrapping behaviour on or off.
     
     Specifies whether to use wrapping behaviors or not, i.e. automatically wrapping the selection with characters such as brackets when such a character is typed in.
     
     Uses [editor.setWrapBehavioursEnabled()](http://ace.ajax.org/#Editor.setWrapBehavioursEnabled).
     
     - SeeAlso: useSoftWrap
     - SeeAlso: wrapLimitRange
     */
    public var wrappingBehavioursEnabled: Bool {
        get {
            return editor.getWrapBehavioursEnabled()
        }
        set {
            editor.setWrapBehavioursEnabled(newValue)
        }
    }
    
    
    /**
     Sets whether or not line wrapping is enabled.
     
     Define the wrap limit with wrapLimitRange.
     
     Uses [editor.getSession().setUseWrapMode()](http://ace.ajax.org/#EditSession.setUseWrapMode).
     
     - SeeAlso: wrappingBehavioursEnabled
     - SeeAlso: wrapLimitRange
     */
    public var useSoftWrap: Bool {
        get {
            return editor.getSession().getUseWrapMode()
        }
        set {
            editor.getSession().setUseWrapMode(newValue)
        }
    }
    
    /**
     Sets the boundaries of wrap.
     
     Uses [editor.getSession().setWrapLimitRange()](http://ace.ajax.org/#EditSession.setWrapLimitRange).
     
     - SeeAlso: wrappingBehavioursEnabled
     - SeeAlso: useSoftWrap
     */
    public var wrapLimitRange: NSRange {
        get {
            return editor.getSession().getWrapLimitRange()
        }
        set {
            editor.getSession().setWrapLimitRange(newValue)
        }
    }
    
    /**
     Show or hide invisible characters.
     
     Uses [editor.setShowInvisibles()](http://ace.ajax.org/#Editor.setShowInvisibles).
     */
    public var showInvisibles: Bool {
        get {
            return editor.getShowInvisibles()
        }
        set {
            editor.setShowInvisibles(newValue)
        }
    }
    
    /**
     Set read only mode. Prevents content from being changed interactively.
     
     Uses [editor.setReadOnly()](http://ace.ajax.org/#Editor.setReadOnly).
     */
    public var readOnly: Bool {
        get {
            return editor.getReadOnly()
        }
        set {
            editor.setReadOnly(newValue)
        }
    }
    
    /**
     Show or hide folding widgets.
     
     Uses [editor.setShowFoldWidgets()](http://ace.ajax.org/#Editor.setShowFoldWidgets).
     */
    public var showFoldWidgets: Bool {
        get {
            return editor.getShowFoldWidgets()
        }
        set {
            editor.setShowFoldWidgets(newValue)
        }
    }
    
    /**
     Enable fading of folding widgets.
     
     Uses [editor.setFadeFoldWidgets()](http://ace.ajax.org/#Editor.setFadeFoldWidgets).
     */
    public var fadeFoldWidgets: Bool {
        get {
            return editor.getFadeFoldWidgets()
        }
        set {
            editor.setFadeFoldWidgets(newValue)
        }
    }
    
    /**
     Highlight the active line.
     
     Uses [editor.setHighlightActiveLine()](http://ace.ajax.org/#Editor.setHighlightActiveLine).
     */
    public var highlightActiveLine: Bool {
        get {
            return editor.getHighlightActiveLine()
        }
        set {
            editor.setHighlightActiveLine(newValue)
        }
    }
    
    /**
     Highlight the gutter line.
     
     Uses [editor.setHighlightGutterLine()](http://ace.ajax.org/#Editor.setHighlightGutterLine).
     
     - Warning: The ACE Editor documentation for this behaviour is incomplete.
     */
    public var highlightGutterLine: Bool {
        get {
            return editor.getHighlightGutterLine()
        }
        set {
            editor.setHighlightGutterLine(newValue)
        }
    }
    
    /**
     Highlight the selected word.
     
     Uses [editor.setHighlightSelectedWord()](http://ace.ajax.org/#Editor.setHighlightSelectedWord).
     */
    public var highlightSelectedWord: Bool {
        get {
            return editor.getHighlightSelectedWord()
        }
        set {
            editor.setHighlightSelectedWord(newValue)
        }
    }
    
    /**
     Display indent guides.
     
     Uses [editor.setDisplayIndentGuides()](http://ace.ajax.org/#Editor.setDisplayIndentGuides).
     */
    public var displayIndentGuides: Bool {
        get {
            return editor.getDisplayIndentGuides()
        }
        set {
            editor.setDisplayIndentGuides(newValue)
        }
    }
    
    /**
     Enable animated scrolling.
     
     Uses [editor.setAnimatedScroll()](http://ace.ajax.org/#Editor.setAnimatedScroll).
     
     - Warning: The ACE Editor documentation for this behaviour is incomplete.
     */
    public var animatedScroll: Bool {
        get {
            return editor.getAnimatedScroll()
        }
        set {
            editor.setAnimatedScroll(newValue)
        }
    }
    
    /**
     Change the mouse scroll speed.
     
     Uses [editor.setScrollSpeed()](http://ace.ajax.org/#Editor.setScrollSpeed).
     */
    public var scrollSpeed: Int {
        get {
            return editor.getScrollSpeed()
        }
        set {
            editor.setScrollSpeed(newValue)
        }
    }
    
    /**
     Set the keyboard handler.
     
     Uses [editor.setKeyboardHandler()]( http://ace.ajax.org/#Editor.setKeyboardHandler ).
     
     - SeeAlso: ACETheme
     */
    public var keyboardHandler: ACEKeyboardHandler {
        get {
            return editor.getKeyboardHandler()
        }
        set {
            editor.setKeyboardHandler(newValue)
        }
    }
    
    /**
     Enable basic autocomplete.
     
     Uses [editor.setOptions({ enableBasicAutocompletion: BOOL })]
     */
    public var basicAutoCompletion: Bool {
        get {
            return editor.basicAutocomplete
        }
        set {
            editor.basicAutocomplete = newValue
        }
    }
    
    /**
     Enable live autocompletion.
     
     Uses [editor.setOptions({ enableLiveAutocompletion: BOOL })]
     */
    public var liveAutocompletion: Bool {
        get {
            return editor.enableLiveAutocompletion
        }
        set {
            editor.enableLiveAutocompletion = newValue
        }
    }
    
    /**
     Enable snippets.
     
     Uses [editor.setOptions({ enableSnippets: BOOL })]
     */
    public var snippets: Bool {
        get {
            return editor.enableSnippets
        }
        set {
            editor.enableSnippets = newValue
        }
    }
    
    /**
     Enable emmet.
     
     Uses [editor.setOptions({ emmet: BOOL })]
     */
    public var emmet: Bool {
        get {
            return editor.emmet
        }
        set {
            editor.emmet = newValue
        }
    }
    
    /**
     Sets the column defining where the print margin should be.
     
     Uses [editor.setPrintMarginColumn()]( http://ace.ajax.org/#Editor.setPrintMarginColumn ).
     */
    public var printMarginColumn: Int {
        get {
            return editor.getPrintMarginColumn()
        }
        set {
            editor.setPrintMarginColumn(newValue)
        }
    }
    
    /**
     Shows the print margin
     
     Uses [editor.setShowPrintMargin()]( http://ace.ajax.org/#api=editor&nav=setShowPrintMargin ).
     
     */
    public var showPrintMargin: Bool {
        get {
            return editor.getShowPrintMargin()
        }
        set {
            editor.setShowPrintMargin(newValue)
        }
    }
    
    /**
     Sets the font size.
     
     Uses [editor.setFontSize()](http://ace.ajax.org/#Editor.setFontSize).
     */
    public var fontSize: Int {
        get {
            return editor.getFontSize()
        }
        set {
            editor.setFontSize(newValue)
        }
    }
    
    /**
     Sets the font family.
     
     Uses [editor.setOptions({ fontFamily: NSString })]
     */
    public var fontFamily: String {
        get {
            return editor.fontFamily
        }
        set {
            editor.fontFamily = newValue
        }
    }
    
    /**
     Moves the cursor to the specified line number, and also into the indiciated column.
     
     Uses [editor.goToLine()].
     
     - Parameters:
     - line: The line number to go to
     - column: The column number to go to
     - animated: If `true` animates scolling
     */
    public func goToLine(line: Int, column:Int, animated: Bool) {
        editor.goToLine(line, column: column, animated: animated)
    }
    
    /**
     Enable line numbers.
     
     Uses [editor.setOption('showLineNumbers', BOOL )]
     */
    public var showLineNumbers: Bool {
        get {
            return editor.showLineNumbers
        }
        set {
            editor.showLineNumbers = newValue
        }
    }
    
    /**
     Enable gutter.
     
     Uses [editor.setOption('showGutter', BOOL )]
     */
    public var showGutter: Bool {
        get {
            return editor.showGutter
        }
        set {
            editor.showGutter = newValue
        }
    }
    
    /**
     Returns the number of rows in the document.
     
     Uses [editor.getSession().getLength()]
     */
    public var length: Int {
        get {
            return editor.getSession().getLength()
        }
    }
    
    /**
     Returns a verbatim copy of the given line as it is in the document.
     
     Uses [editor.getSession().getLine(Number row)]
     
     - Parameter: line The line to get
     - Returns: The requested line
     */
    public func getLine(line: Int) -> String {
        return editor.getSession().getLine(line)
    }
    
    /**
     The current new line mode.
     
     Uses [EditSession.getNewLineMode()](http://ace.c9.io/api/edit_session.html#EditSession.getNewLineMode).
     */
    public var newLineMode: String {
        get {
            return editor.getSession().getNewLineMode()
        }
        set {
            editor.getSession().setNewLineMode(newValue)
        }
    }
    
    /**
     Pass true to enable the use of soft tabs.
     
     Soft tabs means you're using spaces instead of the tab character ('\t').
     
     Uses [EditSession.setUseSoftTabs(Boolean useSoftTabs)](http://ace.c9.io/api/edit_session.html#EditSession.setUseSoftTabs).
     */
    public var useSoftTabs: Bool {
        get {
            return editor.getSession().getUseSoftTabs()
        }
        set {
            editor.getSession().setUseSoftTabs(newValue)
        }
    }
    
    /**
     Set the number of spaces that define a soft tab.
     
     For example, passing in 4 transforms the soft tabs to be equivalent to four spaces. This function also emits the changeTabSize event.
     
     Uses [EditSession.setTabSize(Number tabSize)](http://ace.c9.io/api/edit_session.html#EditSession.setTabSize).
     */
    public var tabSize: Int {
        get {
            return editor.getSession().getTabSize()
        }
        set {
            editor.getSession().setTabSize(newValue)
        }
    }
    
    
    /** 
     Searches for all occurances options.needle.
     
     If found, this method returns an array of Ranges where the text first occurs. 
     If options.backwards is true, the search goes backwards in the session.
     
     Uses [Search.findAll(EditSession session)](http://ace.c9.io/api/search.html).
     
     - Parameter: options A dictionary of search options.
     */
    public func findAll(options: NSDictionary) -> [ACESearchItem]? {
        let stringOptions = searchOptions(options)
        let script = "JSON.stringify(new Search().set(\(stringOptions)).findAll(editor.getSession()));"
        return ACESearchItem.fromString(context.evaluateScript(script).toString())
    }

    /** 
     Replaces all occurances of options.needle with the value in replacement.
     
     Uses [Editor.replaceAll(String replacement, Object options)](http://ace.c9.io/api/editor.html#Editor.replaceAll).
     
     - Parameter replacement: The replacement value
     - Parameter options: A dictionary of search options
     */
    public func replaceAll(replacement: String, options: NSDictionary) {
        
    }
    
    // MARK: - NSView overrides
    public override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        resizeWebView()
    }
    
    public override func resizeSubviewsWithOldSize(oldSize: NSSize) {
        resizeWebView()
    }
    
    // MARK: - WebView delegate methods
    public var onReady: (() -> Void)?
    
    public func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        // Export ACEView class to the JSContext
        context = ACEContext(context: webView.mainFrame.javaScriptContext)
        context.aceView = self
        editor = context.editor
        context.exceptionHandler = {context, value in
            Swift.print("Context Exception: \(value)")
        }
        
        // Callbacks
        delegate?.aceViewDidLoad?()
        onReady?()
        
    }
    
    // Warning: Getting segmentation errors in case of:
    // delegate?.function?()
    public func webViewHeaderHeight(sender: WebView!) -> Float {
        guard let printHeaderHeight = delegate?.printHeaderHeight else { return 0.0 }
        return printHeaderHeight()
    }

    // Warning: Getting segmentation errors in case of:
    // delegate?.function?()
    public func webViewFooterHeight(sender: WebView!) -> Float {
        guard let printFooterHeight = delegate?.printFooterHeight else { return 0.0 }
        return printFooterHeight()
    }

    // Warning: Getting segmentation errors in case of:
    // delegate?.function?()
    public func webView(sender: WebView!, drawHeaderInRect rect: NSRect) {
        guard
            let delegate = delegate,
            let currentPage = printOperation?.currentPage else { return }
        delegate.drawPrintHeaderForPage!(currentPage, inRect: rect)
    }

    // Warning: Getting segmentation errors in case of:
    // delegate?.function?()
    public func webView(sender: WebView!, drawFooterInRect rect: NSRect) {
        guard
            let delegate = delegate,
            let currentPage = printOperation?.currentPage else { return }
        delegate.drawPrintFooterForPage!(currentPage, inRect: rect)
    }
    
    
    public var editable: Bool {
        return true
    }
    
    // MARK: - Private Scope
    private var webView: WebView!
    private var context: ACEContext!
    private var textFinder: NSTextFinder!
    private var padding: Int!
    private var printingView: WebView!
    private var printOperation: NSPrintOperation?
    
    private func initWebView() {
        webView = ACEWebView()
        webView.frameLoadDelegate = self
        
        printingView = WebView(frame: NSRect(x: 0.0, y: 0.0, width: 300.0, height: 1.0))
        printingView.mainFrame.frameView.allowsScrolling = false
        printingView.UIDelegate = self
        
        addSubview(webView)
        borderType = .BezelBorder
        textFinder = NSTextFinder()
        textFinder.client = self
        textFinder.findBarContainer = self
        resizeWebView()
        let bundle = NSBundle(forClass: ACEView.self)
        let javascriptDirectory = aceJavascriptDirectoryPath()
        let htmlPath = htmlPageFilePath()
        let html = try! String(contentsOfFile: htmlPath, encoding: NSUTF8StringEncoding).stringByReplacingOccurrencesOfString(ACE_JAVASCRIPT_DIRECTORY, withString: javascriptDirectory)
        webView.mainFrame.loadHTMLString(html, baseURL: bundle.bundleURL)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initWebView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initWebView()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override var borderType: NSBorderType {
        didSet {
            padding = (borderType == .NoBorder) ? 0 : 1
            resizeWebView()
        }
    }
    
    private func resizeWebView() {
        if let findBarContainer = textFinder?.findBarContainer where findBarContainer.findBarVisible {
            if let findBarHeight = findBarContainer.findBarView?.frame.height {
                bounds.origin.y += findBarHeight
                bounds.size.height -= findBarHeight
            }
        }
        webView.frame = NSRect(
            x: bounds.origin.x + CGFloat(padding),
            y: bounds.origin.y + CGFloat(padding),
            width: bounds.size.width - ( 2.0 * CGFloat(padding)),
            height: bounds.size.height - (2.0 * CGFloat(padding))
        )
    }
    
    private func showFindInterface() {
        textFinder.performAction(.ShowFindInterface)
        resizeWebView()
    }
    
    private func showReplaceInterface() {
        textFinder.performAction(.ShowReplaceInterface)
        resizeWebView()
    }
    
    private lazy var allowedSelectorNamesForJavascript: [String] = {
        return ["showFindInterface", "showReplaceInterface", "aceTextDidChange", "printHTML:"]
    }()
    
    @objc public func aceTextDidChange() {
        let textDidChangeNotification = NSNotification(name: ACETextDidEndEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().postNotification(textDidChangeNotification)
        delegate?.textDidChange?(textDidChangeNotification)
    }
    
    private func searchOptions(options: NSDictionary) -> String? {
        if let json = try? NSJSONSerialization.dataWithJSONObject(options, options: NSJSONWritingOptions()) {
            return String(data: json, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
    
}

// MARK: - NSTextFinderClient methods (Ext)
extension ACEView {

    public override func performTextFinderAction(sender: AnyObject?) {
        guard let tag = sender?.valueForKey("tag") as? Int else { return }
        if let action = NSTextFinderAction(rawValue: tag) {
            textFinder.performAction(action)
        }
    }
    
    public func scrollRangeToVisible(range: NSRange) {
        firstSelectedRange = range
        context.evaluateScript(
            "editor.session.selection.clearSelection();" +
            "editor.session.selection.setRange(new Range(\(ACEStringFromRange(range, string: editor.string))));" +
            "editor.centerSelection();"
        )
    }
    
    public func replaceCharactersInRange(range: NSRange, withString string: String) {
        context.evaluateScript(
            "editor.session.replace(new Range(\(ACEStringFromRange(range, string: string))), \"\(string)\");"
        )
    }
}

// MARK: - Helpers (Ext)
extension ACEView {
    private func aceJavascriptDirectoryPath() -> String {
        let bundle = NSBundle(forClass: ACEView.self)
        return (bundle.pathForResource("ace", ofType: "js")! as NSString).stringByDeletingLastPathComponent
    }
    
    private func htmlPageFilePath() -> String {
        let bundle = NSBundle(forClass: ACEView.self)
        return bundle.pathForResource("index", ofType: "html")!
    }
}
