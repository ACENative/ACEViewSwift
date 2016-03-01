//
//  Enums.swift
//  ACEViewSwift
//
//  Created by Vasilis Akoinoglou on 17/11/15.
//  Copyright © 2015 Vasilis Akoinoglou. All rights reserved.
//

import Foundation

/// The ACE Syntax Highlighting Mode
public enum ACEMode: Int {
    case
    ASCIIDoc,
    C9Search,
    CPP,
    Clojure,
    Coffee,
    Coldfusion,
    CSharp,
    CSS,
    Diff,
    GLSL,
    Golang,
    Groovy,
    Haxe,
    HTML,
    Jade,
    Java,
    JavaScript,
    JSON,
    JSP,
    JSX,
    Latex,
    LESS,
    Liquid,
    Lua,
    Luapage,
    Markdown,
    OCaml,
    Perl,
    PGSQL,
    PHP,
    Powershell,
    Python,
    ObjC,
    Ruby,
    SCAD,
    Scala,
    SCSS,
    SH,
    SQL,
    SVG,
    Swift,
    Tcl,
    Text,
    Textile,
    Typescript,
    XML,
    XQuery,
    YAML,
    
    Count // keep track of the enum size automatically
    
    /**
    The ACE Mode names
    - Returns: A list of mode names
    */
    public static func modeNames() -> [String] {
        return [
            "asciidoc",
            "c9search",
            "c_cpp",
            "clojure",
            "coffee",
            "coldfusion",
            "csharp",
            "css",
            "diff",
            "glsl",
            "golang",
            "groovy",
            "haxe",
            "html",
            "jade",
            "java",
            "javascript",
            "json",
            "jsp",
            "jsx",
            "latex",
            "less",
            "liquid",
            "lua",
            "luapage",
            "markdown",
            "ocaml",
            "perl",
            "pgsql",
            "php",
            "powershell",
            "python",
            "objectivec",
            "ruby",
            "scad",
            "scala",
            "scss",
            "sh",
            "sql",
            "svg",
            "swift",
            "tcl",
            "text",
            "textile",
            "typescript",
            "xml",
            "xquery",
            "yaml"
        ]
    }
    
    /**
     The ACE Human Mode names
     - Returns: A list of mode names ('human' versions)
     */
    public static func humanModeNames() -> [String] {
        return [
            "ASCII Doc",
            "C9 Search",
            "C++",
            "Clojure",
            "Coffee",
            "ColdFusion",
            "C#",
            "CSS",
            "Diff",
            "GLSL",
            "Go",
            "Groovy",
            "Haxe",
            "HTML",
            "Jade",
            "Java",
            "JavaScript",
            "JSON",
            "JSP",
            "JSX",
            "Latex",
            "LESS",
            "Liquid",
            "Lua",
            "Luapage",
            "Markdown",
            "OCaml",
            "Perl",
            "PGSQL",
            "PHP",
            "Powershell",
            "Python",
            "Objective-C",
            "Ruby",
            "SCAD",
            "Scala",
            "SCSS",
            "SH",
            "SQL",
            "SVG",
            "Swift",
            "Tcl",
            "Text",
            "Textile",
            "Typescript",
            "XML",
            "XQuery",
            "YAML"
        ]
    }
    
    /// The name of the Mode
    public var name: String {
        return ACEMode.modeNames()[self.rawValue]
    }
    
    /// The 'human' name of the mode
    public var humanName: String {
        return ACEMode.humanModeNames()[self.rawValue]
    }
    
    /// The designated initializer
    init(name: String) {
        let index = ACEMode.modeNames().indexOf(name)
        self = ACEMode(rawValue: index!)!
    }
}

/// The ACE Theme
public enum ACETheme: Int {
    case
    Ambiance = 0,
    Chrome,
    Clouds,
    CloudsMidnight,
    Cobalt,
    CrimsonEditor,
    Dawn,
    Dreamweaver,
    Eclipse,
    Github,
    IdleFingers,
    Merbivore,
    MerbivoreSoft,
    MonoIndustrial,
    Monokai,
    PastelOnDark,
    SolarizedDark,
    SolarizedLight,
    Textmate,
    Tomorrow,
    TomorrowNight,
    TomorrowNightBlue,
    TomorrowNightBright,
    TomorrowNightEighties,
    Twilight,
    VibrantInk,
    Xcode,
    
    Count,  // keep track of the enum size automatically
    
    None
    
    public static func themeNames() -> [String] {
        return [
            "ambiance",
            "chrome",
            "clouds",
            "clouds_midnight",
            "cobalt",
            "crimson_editor",
            "dawn",
            "dreamweaver",
            "eclipse",
            "github",
            "idle_fingers",
            "merbivore",
            "merbivore_soft",
            "mono_industrial",
            "monokai",
            "pastel_on_dark",
            "solarized_dark",
            "solarized_light",
            "textmate",
            "tomorrow",
            "tomorrow_night",
            "tomorrow_night_blue",
            "tomorrow_night_bright",
            "tomorrow_night_eighties",
            "twilight",
            "vibrant_ink",
            "xcode"
        ]
    }
    
    public static func humanThemeNames() -> [String] {
        return [
            "Ambiance",
            "Chrome",
            "Clouds",
            "Clouds Midnight",
            "Cobalt",
            "Crimson Editor",
            "Dawn",
            "Dreamweaver",
            "Eclipse",
            "Github",
            "Idle Fingers",
            "Merbivore",
            "Merbivore Soft",
            "Mono Industrial",
            "Monokai",
            "Pastel on Dark",
            "Solarized Dark",
            "Solarized Light",
            "Textmate",
            "Tomorrow",
            "Tomorrow Night",
            "Tomorrow Night Blue",
            "Tomorrow Night Bright",
            "Tomorrow Night Eighties",
            "Twilight",
            "Vibrant Ink",
            "Xcode"
        ]
    }
    
    var name: String {
        guard self != .None else { return "None" }
        return ACETheme.themeNames()[self.rawValue]
    }
    
    var humanName: String {
        guard self != .None else { return "None" }
        return ACETheme.humanThemeNames()[self.rawValue]
    }
    
    init(name: String) {
        if let index = ACETheme.themeNames().indexOf(name) {
            self = ACETheme(rawValue: index)!
        } else {
            self = ACETheme.None
        }
    }
}


public enum ACEKeyboardHandler: Int {
    case Ace, Emacs, Vim,
    Count // keep track of the enum size automatically
    
    public static func commands() -> [String] {
        return [
            "null",
            "require(\"ace/keyboard/emacs\").handler",
            "require(\"ace/keyboard/vim\").handler"
        ]
    }
    
    public static func humanNames() -> [String] {
        return [
            "Ace",
            "Emacs",
            "Vim"
        ]
    }
    
    var command: String {
        return ACEKeyboardHandler.commands()[self.rawValue]
    }
    
    var humanName: String {
        return ACEKeyboardHandler.humanNames()[self.rawValue]
    }
    
    init(command: String) {
        let index = ACEKeyboardHandler.commands().indexOf(command)!
        self = ACEKeyboardHandler(rawValue: index)!
    }
}
