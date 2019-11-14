//
//  ACEViewSwiftTests.swift
//  ACEViewSwiftTests
//
//  Created by Vasilis Akoinoglou on 24/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import XCTest
@testable import ACEViewSwift

//MARK: Helpers
extension XCTestCase {
    
    func assertBooleanProperty(_ property: inout Bool, name: String, defaultValue: Bool) {
        
        func flagMsg(_ flag: Bool) -> String { return flag ? "turned on" : "turned off" }
        
        XCTAssertEqual(property, defaultValue, "\(name) should be \(flagMsg(defaultValue)) by default")
        property = !defaultValue
        XCTAssertEqual(property, !defaultValue, "\(name) should be \(flagMsg(!defaultValue)) now")
    }
    
    func assertIntProperty(_ property: inout Int, name: String, defaultValue: Int, testValue: Int) {
        XCTAssertEqual(property, defaultValue, "\(name) should be \(defaultValue) by default")
        property = testValue
        XCTAssertEqual(property, testValue, "\(name) should be \(testValue) now")
    }
    
}

/*--------------------------------------------------------------------------------*/
//MARK: - Testing
class ACEViewSwiftTests: XCTestCase {
    
    class ACEDelegate: ACEViewDelegate {
        
        var didLoadExpectation: XCTestExpectation?
        
        // didLoad should be called on the delegate
        @objc func aceViewDidLoad() {
            didLoadExpectation?.fulfill()
        }
    }
    
    var aceView: ACEView!
    var delegate: ACEDelegate!
    
    func wait(seconds: TimeInterval = 5.0) {
        waitForExpectations(timeout: seconds, handler: nil)
    }
    
    func waitWithRunLoop(seconds: TimeInterval) {
        let startTime = NSDate.timeIntervalSinceReferenceDate
        while NSDate.timeIntervalSinceReferenceDate - startTime < seconds {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, false);
        }
    }
    
    override func setUp() {
        super.setUp()
        
        aceView = ACEView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        
        delegate = ACEDelegate()
        aceView.delegate = delegate
        
        let readyExpectation = expectation(description: "onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            print("Ready...")
        }
        
        wait()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStringAccessor() {
        XCTAssertTrue(self.aceView.string.isEmpty, "String should be empty on initialization")
        let newValue = "Something"
        self.aceView.string = newValue
        XCTAssertEqual(self.aceView.string, newValue, "String should be 'Something' at this point")
    }
    
    func testMode() {
        XCTAssertEqual(self.aceView.mode.name, "text", "Mode should be 'text' by default")
        let newMode = ACEMode.html
        self.aceView.mode = newMode
        XCTAssertEqual(self.aceView.mode, newMode)
        XCTAssertEqual(self.aceView.mode.name, "html", "Mode should be now changed to 'html'")
    }
    
    func testModeInline() {
        XCTAssertEqual(self.aceView.mode.name, "text", "Mode should be 'text' by default")
        let newMode = ACEMode.php
        self.aceView.setMode(newMode, inline: true)
        waitWithRunLoop(seconds: 1)
        XCTAssertEqual(self.aceView.mode, newMode)
        XCTAssertEqual(self.aceView.mode.name, "php", "Mode should be now changed to 'html'")
    }
    
    func testTheme() {
        XCTAssertNotEqual(self.aceView.theme.name, "monokai", "Theme should not be 'Monokai' by default")
        let newTheme = ACETheme.monokai
        self.aceView.theme = newTheme
        XCTAssertEqual(self.aceView.theme, ACETheme.monokai)
        XCTAssertEqual(self.aceView.theme.name, "monokai", "Mode should be now changed to 'Monokai'")
    }
    
    func testWrapBehavioursEnabled() {
        assertBooleanProperty(&self.aceView.wrappingBehavioursEnabled, name: "Wrapping behaviours", defaultValue: true)
    }
    
    func testSoftWrap() {
        assertBooleanProperty(&self.aceView.useSoftWrap, name: "Soft wrapping", defaultValue: false)
    }
    
    func testWrapLimitRange() {
        XCTAssertTrue(NSEqualRanges(self.aceView.wrapLimitRange, NSRange()), "Wrap limit range should be zero by default")
        XCTAssertEqual(self.aceView.useSoftWrap, false, "Soft wrapping should be turned off by default")
        let newRange = NSRange(location: 2, length: 4)
        self.aceView.wrapLimitRange = newRange
        XCTAssertTrue(NSEqualRanges(self.aceView.wrapLimitRange, newRange), "Wrap limit range should be now changed to new value")
        XCTAssertEqual(self.aceView.useSoftWrap, true, "Soft wrapping should be now changed to true")
    }
    
    func testShowInvisibles() {
        assertBooleanProperty(&self.aceView.showInvisibles, name: "Invisible characters", defaultValue: false)
    }
    
    func testReadOnly() {
        assertBooleanProperty(&self.aceView.readOnly, name: "Read only mode", defaultValue: false)
    }
    
    func testShowFoldWidgets() {
        assertBooleanProperty(&self.aceView.showFoldWidgets, name: "Show fold widgets", defaultValue: true)
    }
    
    func testFadeFoldWidgets() {
        assertBooleanProperty(&self.aceView.fadeFoldWidgets, name: "Fade fold widgets", defaultValue: false)
    }
    
    func testHighlightActiveLine() {
        assertBooleanProperty(&self.aceView.highlightActiveLine, name: "Highlight active line", defaultValue: true)
    }
    
    func testHighlightGutterLine() {
        assertBooleanProperty(&self.aceView.highlightGutterLine, name: "Highlight gutter line", defaultValue: true)
    }
    
    func testHighlightSelectedWord() {
        assertBooleanProperty(&self.aceView.highlightSelectedWord, name: "Highlight selected word", defaultValue: true)
    }
    
    func testDisplayIndentGuides() {
        assertBooleanProperty(&self.aceView.displayIndentGuides, name: "Display indent guides", defaultValue: true)
    }
    
    func testAnimatedScroll() {
        assertBooleanProperty(&self.aceView.animatedScroll, name: "Animated scroll", defaultValue: false)
    }
    
    func testScrollSpeed() {
        assertIntProperty(&self.aceView.scrollSpeed, name: "Scroll speed", defaultValue: 2, testValue: 3)
    }
    
    func testKeyboardHandler() {
        XCTAssertEqual(self.aceView.keyboardHandler, ACEKeyboardHandler.ace, "Keyboard handler should be Ace by default")
        self.aceView.keyboardHandler = .emacs
        XCTAssertEqual(self.aceView.keyboardHandler, ACEKeyboardHandler.emacs, "Keyboard handler should be Emacs now")
        self.aceView.keyboardHandler = .vim
        XCTAssertEqual(self.aceView.keyboardHandler, ACEKeyboardHandler.vim, "Keyboard handler should be Vim now")
        self.aceView.keyboardHandler = .ace
        XCTAssertEqual(self.aceView.keyboardHandler, ACEKeyboardHandler.ace, "Keyboard handler should be back to Ace now")
    }
    
    func testBasicAutocompletion() {
        assertBooleanProperty(&self.aceView.basicAutoCompletion, name: "Basic autocompletion", defaultValue: false)
    }
    
    func testLiveAutocompletion() {
        assertBooleanProperty(&self.aceView.liveAutocompletion, name: "Live autocompletion", defaultValue: false)
    }
    
    func testSnippets() {
        assertBooleanProperty(&self.aceView.snippets, name: "Snippets", defaultValue: false)
    }
    
    func testEmmet() {
        assertBooleanProperty(&self.aceView.emmet, name: "Emmet", defaultValue: false)
    }
    
    func testPrintMarginColumn() {
        assertIntProperty(&self.aceView.printMarginColumn, name: "Print margin column", defaultValue: 80, testValue: 90)
    }
    
    func testShowPrintMargin() {
        assertBooleanProperty(&self.aceView.showPrintMargin, name: "Show print margin", defaultValue: true)
    }
    
    func testFontSize() {
        assertIntProperty(&self.aceView.fontSize, name: "Font size", defaultValue: 12, testValue: 16)
    }
    
    func testFontFamily() {
        XCTAssertEqual(self.aceView.fontFamily, "None", "Font family should not be set by default")
        self.aceView.fontFamily = "Hack"
        XCTAssertEqual(self.aceView.fontFamily, "Hack", "Font family should be set now")
    }
    
    func testShowLineNumbers() {
        assertBooleanProperty(&self.aceView.showLineNumbers, name: "Show line numbers", defaultValue: true)
    }
    
    func testShowGutter() {
        assertBooleanProperty(&self.aceView.showGutter, name: "Show gutter", defaultValue: true)
    }
    
    func testLength() {
        XCTAssertEqual(self.aceView.length, 1, "One row by default")
        self.aceView.string = "This \n should \n take four \n rows"
        XCTAssertEqual(self.aceView.length, 4)
    }
    
    func testGetLine() {
        XCTAssertEqual(self.aceView.getLine(0), "", "First line should be empty by default")
        self.aceView.string = "This \n should \n take four \n rows"
        XCTAssertEqual(self.aceView.getLine(0), "This ")
        XCTAssertEqual(self.aceView.getLine(3), " rows")
    }
    
    func testNewLineMode() {
        XCTAssertEqual(self.aceView.newLineMode, "auto", "New line mode should be on 'auto' by default")
    }
    
    func testUseSoftTabs() {
        assertBooleanProperty(&self.aceView.useSoftTabs, name: "Use soft tabs", defaultValue: true)
    }
    
    func testTabSize() {
        assertIntProperty(&self.aceView.tabSize, name: "Tab size", defaultValue: 4, testValue: 8)
    }
    
    func testEditability() {
        XCTAssertTrue(self.aceView.isEditable)
    }
    
    var stringCopy = ""
    
    func testStringBinding() {
        self.stringCopy = ""
        self.bind(NSBindingName(rawValue: "stringCopy"), to: self.aceView, withKeyPath: "string", options: nil)
        self.aceView.string = "hello"
        XCTAssertEqual(self.stringCopy, "hello")
    }
}
