//
//  Utilities.swift
//  ACEViewSwift
//
//  Created by Vasilis Akoinoglou on 17/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import Foundation

struct ACERangeComponent {
    var start: Int
    var end: Int
}

let ACERangeComponentZero = ACERangeComponent(start: 0, end: 0)

struct ACERange: CustomStringConvertible {
    var row: ACERangeComponent
    var column: ACERangeComponent
    
    var description: String {
        return "{ \(row.start), \(row.end) }, { \(column.start), \(column.end) }"
    }
}

let ACERangeZero = ACERange(row: ACERangeComponentZero, column: ACERangeComponentZero)

func ACEMakeRange(range: NSRange, string swiftString: String) -> ACERange {
    let string: NSString = swiftString
    var aceRange = ACERangeZero
    var characterCountIncludingCurrentLine = 0
    var characterCountForCurrentLine = 0
    var rangeLocationFound = false
    
    let chars = string.length
    var numberOfLines = chars
    var index = chars
    let stringLength = chars
    
    var lineRange: NSRange
    
    for index = 0, numberOfLines = 0; index < stringLength; numberOfLines++ {
        lineRange = string.lineRangeForRange(NSMakeRange(index, 0))
        index = NSMaxRange(lineRange)
        
        characterCountForCurrentLine = lineRange.length
        characterCountIncludingCurrentLine += characterCountForCurrentLine
        
        if !rangeLocationFound && characterCountIncludingCurrentLine >= range.location {
            aceRange.row.start = numberOfLines
            aceRange.column.start = characterCountForCurrentLine - (characterCountIncludingCurrentLine - range.location)
            rangeLocationFound = true
        }
        
        let rangeEndLocation = range.location + range.length
        if rangeLocationFound && characterCountIncludingCurrentLine >= rangeEndLocation {
            aceRange.row.end = numberOfLines
            aceRange.column.end = characterCountForCurrentLine - (characterCountIncludingCurrentLine - rangeEndLocation)
            break
        }

    }
    return aceRange
}

func ACEStringFromRange(range: NSRange, string: String) -> String {
    let aceRange = ACEMakeRange(range, string: string)
    return "\(aceRange.row.start), \(aceRange.column.start), \(aceRange.row.end), \(aceRange.column.end)"
}

