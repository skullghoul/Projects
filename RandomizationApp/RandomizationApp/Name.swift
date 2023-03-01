//
//  Nmae.swift
//  RandomizationApp
//
//  Created by Zander Ewell on 2/24/23.
//

import Foundation

struct Name {
    var name: String
}

class MyDecoder {
    func decode(fileAtPath filePath: String) -> Name? {
        // Read the file contents into a string
        guard let fileContents = try? String(contentsOfFile: filePath) else {
            return nil
        }
        
        // Parse the string to extract the data you want
        let nameRegex = try! NSRegularExpression(pattern: "name: \"([^\"]+)\"", options: [])
        let nameMatches = nameRegex.matches(in: fileContents, range: NSRange(fileContents.startIndex..., in: fileContents))
        let name = nameMatches[0].range(at: 1)
        let nameString = String(fileContents[Range(name, in: fileContents)!])
        
        
        // Convert the parsed data into a MyData object

        let myData = Name(name: nameString)
        
        return myData
    }
}
