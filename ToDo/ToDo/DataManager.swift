//
//  DataManager.swift
//  ToDo
//
//  Created by Camila Barros on 2020-04-28.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import Foundation
import UIKit

public class DataManager {
    
    // get the Document Directory
    static fileprivate func getDocumentDirectory () -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Unable to access document directory")
        }
    }
    
    // Save any kind of codable objects. Saves one object per file
    static func save <T:Encodable> (_ obj: T, with fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(obj)
            
            if FileManager.default.fileExists(atPath: url.path) { // safe checking if the file already exists
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Load any kind of codable objects
    static func load <T:Decodable> (_ fileName: String, with type:T.Type) -> T {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) { // if file not found in directory
            fatalError("File not found at path \(url.path)")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {// get file
           
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    // Load data from the file
    static func loadData (_ fileName: String) -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) { // if file not found in directory
            fatalError("File not found at path \(url.path)")
        }
        if let data = FileManager.default.contents(atPath: url.path) {
            return data
        } else {
            fatalError("Data unavailable at path \(url.path)")
        }
    }
    
    // Load all files from a directory
    static func loadAll <T:Decodable> (_ type:T.Type) -> [T] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentDirectory().path) // dir that holds the files
            var modelObjects = [T]() // holds all the objs from files
            
            for fileName in files {
                modelObjects.append(load(fileName, with: type)) // read objs from each file
            }
            return modelObjects
        } catch {
            fatalError("Could not load files \(error.localizedDescription)")
        }
    }
    
    // Delete a file
    static func delete (_ fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError("Could not remove file")
            }
        }
    }
}
