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
        
        let readyExpectation = expectationWithDescription("onReady")
        
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
        let newMode = ACEMode.HTML
        self.aceView.mode = newMode
        XCTAssertEqual(self.aceView.mode, newMode)
        XCTAssertEqual(self.aceView.mode.name, "html", "Mode should be now changed to 'html'")
    }
    
    func testTheme() {
        XCTAssertEqual(self.aceView.theme.name, "None", "Theme should be 'None' by default")
        let newTheme = ACETheme.Monokai
        self.aceView.theme = newTheme
        XCTAssertEqual(self.aceView.theme, ACETheme.Monokai)
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
    
}
