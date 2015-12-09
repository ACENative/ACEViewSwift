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
    
    func assertBooleanProperty(inout property: Bool, name: String, defaultValue: Bool) {
        
        func flagMsg(flag: Bool) -> String { return flag ? "turned on" : "turned off" }

        XCTAssertEqual(property, defaultValue, "\(name) should be \(flagMsg(defaultValue)) by default")
        property = !defaultValue
        XCTAssertEqual(property, !defaultValue, "\(name) should be \(flagMsg(!defaultValue)) now")
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
    
    
    func wait(seconds: NSTimeInterval = 5.0) {
        waitForExpectationsWithTimeout(seconds, handler: nil)
    }
    
    override func setUp() {
        super.setUp()
        
        aceView = ACEView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        
        delegate = ACEDelegate()
        aceView.delegate = delegate
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testACEViewInitialization() {
        
        let readyExpectation = expectationWithDescription("onReady")
        
        delegate.didLoadExpectation = expectationWithDescription("onDidLoad")
        
        // onReady should be called eventually
        aceView.onReady = {
            readyExpectation.fulfill()
        }
        
        wait()
    }
    
    func testStringAccessor() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            XCTAssertTrue(self.aceView.string.isEmpty, "String should be empty on initialization")
            let newValue = "Something"
            self.aceView.string = newValue
            XCTAssertEqual(self.aceView.string, newValue, "String should be 'Something' at this point")
        }
        
        wait()
    }
    
    func testMode() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            XCTAssertEqual(self.aceView.mode.name, "text", "Mode should be 'text' by default")
            let newMode = ACEMode.HTML
            self.aceView.mode = newMode
            XCTAssertEqual(self.aceView.mode, newMode)
            XCTAssertEqual(self.aceView.mode.name, "html", "Mode should be now changed to 'html'")
        }
        
        wait()
    }
    
    func testTheme() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            XCTAssertEqual(self.aceView.theme.name, "None", "Theme should be 'None' by default")
            let newTheme = ACETheme.Monokai
            self.aceView.theme = newTheme
            XCTAssertEqual(self.aceView.theme, ACETheme.Monokai)
            XCTAssertEqual(self.aceView.theme.name, "monokai", "Mode should be now changed to 'Monokai'")
        }
        
        wait()
    }
    
    func testWrapBehavioursEnabled() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            self.assertBooleanProperty(&self.aceView.wrappingBehavioursEnabled, name: "Wrapping behaviours", defaultValue: true)
        }
        
        wait()
    }
    
    func testSoftWrap() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            self.assertBooleanProperty(&self.aceView.useSoftWrap, name: "Soft wrapping", defaultValue: false)
        }
        
        wait()
    }
    
    func testWrapLimitRange() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            XCTAssertTrue(NSEqualRanges(self.aceView.wrapLimitRange, NSRange()), "Wrap limit range should be zero by default")
            XCTAssertEqual(self.aceView.useSoftWrap, false, "Soft wrapping should be turned off by default")
            let newRange = NSRange(location: 2, length: 4)
            self.aceView.wrapLimitRange = newRange
            XCTAssertTrue(NSEqualRanges(self.aceView.wrapLimitRange, newRange), "Wrap limit range should be now changed to new value")
            XCTAssertEqual(self.aceView.useSoftWrap, true, "Soft wrapping should be now changed to true")
        }
        
        wait()
    }
    
    func testShowInvisibles() {
        let readyExpectation = expectationWithDescription("onReady")
        
        aceView.onReady = {
            readyExpectation.fulfill()
            self.assertBooleanProperty(&self.aceView.showInvisibles, name: "Invisible characters", defaultValue: false)
        }
        
        wait()
    }
    
}
