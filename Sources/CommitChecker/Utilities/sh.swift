//
//  sh.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

@discardableResult
func sh(_ command: String) -> String {
    let task = Process()
    task.launchPath = Configuration.current.cli
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(data: data, encoding: String.Encoding.utf8)!
    task.waitUntilExit()
    
    guard task.terminationStatus == 0 else {
        Messenger.error(output)
    }
    
    return output
}
