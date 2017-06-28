//
//  RequestHelper.swift
//  LocationDumper
//
//  Created by Filippo on 9/27/16.
//  Copyright © 2016 Pellolio. All rights reserved.
//

import Foundation

func postProbes(probes: [Probe], onSuccess: @escaping ()->(), onError: @escaping (Error?)->()) {
    var request = URLRequest(url: URL(string: "https://posttestserver.com/post.php?dir=pathDump")!)
    request.httpMethod = "POST"
    
    if probes.count == 0 {
        return
    }
    var postString = "["
    
    for p in probes {
        postString += p.toJSON() + ",";
    }
    
    postString.remove(at: postString.index(before: postString.endIndex))
    postString += "]"
    
    request.httpBody = postString.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let _ = data, error == nil else {                                                 // check for fundamental networking error
            onError(error)
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            onError(nil)
            return
        }
        
        onSuccess()
    }
    task.resume()
}
