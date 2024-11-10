//
//  FIRStorageManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-08.
//

import Foundation
import Firebase
import FirebaseStorage

public class FIRStorageManager {
    
    //---- MARK: Properties
    public static let shared: FIRStorageManager = FIRStorageManager()
    
    private var storageReference: StorageReference? = nil
    
    //---- MARK: Initialization
    init() {
        storageReference = Storage.storage().reference()
    }
    
    //---- MARK: Action Methods
    public func getFile() {
        storageReference?.child("/books/-O9-mNJolBCjdEXdTQWI.txt").downloadURL(completion: {
            (url, error) in
            if let url {
                let request = URLRequest(url: url)
                URLSession.shared.downloadTask(with: request) {
                    (tempUrl, response, error) in
                    if let tempUrl {
                        let content = try? String(contentsOf: tempUrl)
                        print(content)
                    } else {
                        print("Download")
                        print(error?.localizedDescription)
                    }
                }.resume()
            } else {
                print("REferee")
                print(error?.localizedDescription)
            }
        })
    }
}
