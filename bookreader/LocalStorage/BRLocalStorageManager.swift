//
//  BRLocalStorageManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import Foundation

public class BRLocalStorageManager {
    //---- MARK: Properties
    public static var shared: BRLocalStorageManager = BRLocalStorageManager()
    
    private var g_FileManager: FileManager? = nil
    
    //---- MARK: Constructor
    private init() {
        g_FileManager = FileManager.default
    }
    
    //---- MARK: Action Methods
    public func saveFileInLocalStorage(fileData: Data, fileName: String, folderName: String) -> String {
        if (g_FileManager != nil) {
            let m_DocumentsDirectory: URL = g_FileManager!.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var m_FinalURL: URL = m_DocumentsDirectory.appending(component: folderName)
            
            
            try! g_FileManager!.createDirectory(at: m_FinalURL, withIntermediateDirectories: true)
            
            m_FinalURL = m_FinalURL.appending(component: fileName)
            
            if (g_FileManager!.fileExists(atPath: m_FinalURL.path())) {
                try? g_FileManager!.removeItem(at: m_FinalURL)
            }
            
            
            g_FileManager!.createFile(atPath: m_FinalURL.path(), contents: fileData)
            
            return "/\(folderName)/\(fileName)"
        }
        return ""
    }
    
    public func getFileDataInLocalStorage(filePath: String) -> Data? {
        if let m_DocPath: URL = g_FileManager?.urls(for: .documentDirectory, in: .userDomainMask)[0] {
            let m_ProfileImgPath: URL = m_DocPath.appending(path: filePath)
            return FileManager.default.contents(atPath: m_ProfileImgPath.path())
        }
        return nil
    }
    
    //---- MARK: Helper Methods
    
}
