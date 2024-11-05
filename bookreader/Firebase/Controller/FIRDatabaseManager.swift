//
//  FIRManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import Foundation
import FirebaseDatabase

public class FIRDatabaseManager {
    //---- MARK: Properties
    public static var shared: FIRDatabaseManager = FIRDatabaseManager()
    
    private var dbReference: DatabaseReference!
    
    init() {
        dbReference = Database.database().reference()
    }
    
    //---- MARK: Action Methods
    public func observeDataAtPathOnce(path: String, completion: @escaping (DataSnapshot) -> Void) {
        dbReference.child(path).observeSingleEvent(of: .value, with: {
            snapshot  in
            completion(snapshot)
        })
    }
    
    public func setValueAtPath(path: String, value: Any?, completion: @escaping () -> Void) {
        dbReference.child(path).setValue(value) {
            (error, dbRef) in
            completion()
        }
    }
}
