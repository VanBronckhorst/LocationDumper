//
//  LogFileHelper.swift
//  LocationDumper
//
//  Created by Filippo on 9/28/16.
//  Copyright © 2016 Pellolio. All rights reserved.
//

import Foundation

func saveToFile(probes: [Probe], onSuccess: @escaping ()->(), onError: @escaping (Error?)->()) {
    let file = "log" + String(floor(Date().timeIntervalSince1970)) + ".json" //this is the file. we will write to and read from it
    
    if probes.count == 0 {
        return
    }
    var postString = "["
    
    for p in probes {
        postString += p.toJSON() + ",";
    }
    
    postString.remove(at: postString.index(before: postString.endIndex))
    postString += "]"
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let path = dir.appendingPathComponent(file)
        
        //writing
        do {
            try postString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            onSuccess()
        }
        catch {
            onError(nil)
        }
        
    }
}
