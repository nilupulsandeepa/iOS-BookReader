//
//  FIRManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

public class FIRDatabaseManager {
    //---- MARK: Properties
    public static var shared: FIRDatabaseManager = FIRDatabaseManager()
    
    private var dbReference: DatabaseReference!
    private var firestoreDbReference: Firestore!
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
    
    public func batchUpdateChildrens(children: [String: Any], completion: @escaping () -> Void) {
        dbReference.updateChildValues(children) {
            (Error, dbRef) in
            completion()
        }
    }
}
