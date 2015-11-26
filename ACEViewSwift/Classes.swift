//
//  Classes.swift
//  ACEViewSwift
//
//  Created by Vasilis Akoinoglou on 18/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import Foundation
import WebKit

class ACEWebView: WebView {
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        // disable all dragging into the WebView
        return false
    }
}

public class ACESearchItem: NSObject {
    var startColumn: Int = 0
    var startRow: Int = 0
    var endColumn: Int = 0
    var endRow: Int = 0
    
    static func fromString(text: String) -> [ACESearchItem]? {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        guard let object = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) else { return nil }
        if let object = object as? NSArray {
            return convertMultipleObjects(object)
        }
        return nil
    }
    
    private static func convertSingleObject(object: NSDictionary) -> ACESearchItem {
        let result = ACESearchItem()
        
        if let _ = object["start"] as? NSDictionary {
            result.startRow = intOrZero(object, key: "row")
            result.startColumn = intOrZero(object, key: "column")
        }
        
        if let _ = object["end"] as? NSDictionary {
            result.endRow = intOrZero(object, key: "row")
            result.endColumn = intOrZero(object, key: "column")
        }
        
        return result
    }
    
    private static func convertMultipleObjects(objects: NSArray) -> [ACESearchItem] {
        var results = [ACESearchItem]()
        for object in objects {
            if let object = object as? NSDictionary {
                results.append(convertSingleObject(object))
            }
        }
        return results
    }
    
    private static func intOrZero(dict: NSDictionary, key: String) -> Int {
        guard let val = dict.objectForKey(key)?.integerValue else { return 0 }
        return val
    }
}