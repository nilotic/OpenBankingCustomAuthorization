// 
//  Logger.swift
//
//  Created by Den Jo on 2021/07/23.
//  Copyright © finddy Inc. All rights reserved.
//

import os.log

func log(_ type: LogType = .error, _ message: Any?, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    var logMessage = ""
    
    // Add file, function name
    if let filename = file.split(separator: "/").map(String.init).last?.split(separator: ".").map({ String($0) }).first {
        logMessage = "\(type.rawValue) [\(filename)  \(function)]\((type == .info) ? "" : " ✓\(line)")"
    }

    os_log("%s", "\(logMessage)  ➜  \(message ?? "")\n ‎‎")
    #endif
}

