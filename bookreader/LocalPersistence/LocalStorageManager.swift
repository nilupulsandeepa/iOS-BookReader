//
//  LocalStorageManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import Foundation

public class LocalStorageManager {
    //---- MARK: Properties
    public static var shared: LocalStorageManager = LocalStorageManager()
    
    private var fileManager: FileManager? = nil
    
    //---- MARK: Constructor
    private init() {
        fileManager = FileManager.default
    }
    
    //---- MARK: Action Methods
    public func saveFileInLocalStorage(fileData: Data, fileName: String, folderName: String) -> String {
        if (fileManager != nil) {
            let documentsDirectory: URL = fileManager!.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var finalURL: URL = documentsDirectory.appending(component: folderName)
            
            
            try! fileManager!.createDirectory(at: finalURL, withIntermediateDirectories: true)
            
            finalURL = finalURL.appending(component: fileName)
            
            if (fileManager!.fileExists(atPath: finalURL.path())) {
                try? fileManager!.removeItem(at: finalURL)
            }
            
            
            fileManager!.createFile(atPath: finalURL.path(), contents: fileData)
            
            return "/\(folderName)/\(fileName)"
        }
        return ""
    }
    
    public func getFileDataInLocalStorage(filePath: String) -> Data? {
        if let docPath: URL = fileManager?.urls(for: .documentDirectory, in: .userDomainMask)[0] {
            let profileImgPath: URL = docPath.appending(path: filePath)
            return FileManager.default.contents(atPath: profileImgPath.path())
        }
        return nil
    }
    
    //---- MARK: Helper Methods
    
}
