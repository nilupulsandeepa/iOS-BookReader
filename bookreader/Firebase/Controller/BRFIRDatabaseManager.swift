//
//  BRFIRManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import Foundation
import FirebaseDatabase

public class BRFIRDatabaseManager {
    //---- MARK: Properties
    public static var shared: BRFIRDatabaseManager = BRFIRDatabaseManager()
    
    private var g_DBReference: DatabaseReference!
    
    init() {
        g_DBReference = Database.database().reference()
        
        let authorsname = [
            "Elara Wrenstone",
            "Jaxon Hargrave",
            "Lysandra Frost",
            "Orion Blackwood",
            "Celeste Ravensong",
            "Theodore Ironhart",
            "Vivienne Ashford",
            "Ezra Nightshade",
            "Adelaide Winterborne",
            "Sebastian Dusk",
            "Evander Silverthorn",
            "Maris Hawke",
            "Thalia Moonridge",
            "Rowan Thornfield",
            "Leona Wildfire",
            "Finnian Stormrider",
            "Dahlia Emberfall",
            "Aric Stonebrook",
            "Seraphine Graves",
            "Caelan Swiftfoot",
            "Isolde Farrow",
            "Quinn Starling",
            "Lucien Redgrave",
            "Sienna Goldcrest",
            "Jasper Darkmoor",
            "Eleonora Crowe",
            "Alaric Steelwind",
            "Ivy Briarwood",
            "Atticus Hollow",
            "Malia Frostfire",
            "Roderick Ravenshade",
            "Selene Darkspear",
            "Gideon Stormwall",
            "Ophelia Glass",
            "Victor Blackthorn",
        ]
        let books = [
            "-O9-mNJolBCjdEXdTQWI",
            "-O9-mNJolBCjdEXdTQWJ",
            "-O9-mNJolBCjdEXdTQWK",
            "-O9-mNJolBCjdEXdTQWL",
            "-O9-mNJolBCjdEXdTQWM",
            "-O9-mNJolBCjdEXdTQWN",
            "-O9-mNJolBCjdEXdTQWO",
            "-O9-mNJolBCjdEXdTQWP",
            "-O9-mNJolBCjdEXdTQWQ",
            "-O9-mNJolBCjdEXdTQWR",
            "-O9-mNJolBCjdEXdTQWS",
            "-O9-mNJolBCjdEXdTQWU",
            "-O9-mNJolBCjdEXdTQWT",
            "-O9-mNJpDX9hA96DXCps",
            "-O9-mNJpDX9hA96DXCpt",
            "-O9-mNJpDX9hA96DXCpu",
            "-O9-mNJpDX9hA96DXCpv",
            "-O9-mNJpDX9hA96DXCpw",
            "-O9-mNJpDX9hA96DXCpx",
            "-O9-mNJpDX9hA96DXCpy",
            "-O9-mNJpDX9hA96DXCpz",
            "-O9-mNJpDX9hA96DXCq-",
            "-O9-mNJpDX9hA96DXCq0",
            "-O9-mNJpDX9hA96DXCq1",
            "-O9-mNJpDX9hA96DXCq2",
            "-O9-mNJpDX9hA96DXCq3",
            "-O9-mNJpDX9hA96DXCq4",
            "-O9-mNJpDX9hA96DXCq5",
            "-O9-mNJpDX9hA96DXCq6",
            "-O9-mNJpDX9hA96DXCq7",
            "-O9-mNJpDX9hA96DXCq8",
            "-O9-mNJpDX9hA96DXCq9",
            "-O9-mNJpDX9hA96DXCqA",
            "-O9-mNJpDX9hA96DXCqB",
            "-O9-mNJpDX9hA96DXCqC"
        ]
        let authors = [
        "-O9SNnxbVr8XSdkeV0U1",
        "-O9SNnxbVr8XSdkeV0U2",
        "-O9SNnxbVr8XSdkeV0U3",
        "-O9SNnxbVr8XSdkeV0U4",
        "-O9SNnxbVr8XSdkeV0U5",
        "-O9SNnxbVr8XSdkeV0U6",
        "-O9SNnxbVr8XSdkeV0U7",
        "-O9SNnxbVr8XSdkeV0U8",
        "-O9SNnxbVr8XSdkeV0U9",
        "-O9SNnxbVr8XSdkeV0UA",
        "-O9SNnxbVr8XSdkeV0UB",
        "-O9SNnxbVr8XSdkeV0UC",
        "-O9SNnxbVr8XSdkeV0UD",
        "-O9SNnxbVr8XSdkeV0UE",
        "-O9SNnxbVr8XSdkeV0UF",
        "-O9SNnxbVr8XSdkeV0UG",
        "-O9SNnxbVr8XSdkeV0UH",
        "-O9SNnxbVr8XSdkeV0UI",
        "-O9SNnxbVr8XSdkeV0UJ",
        "-O9SNnxbVr8XSdkeV0UK",
        "-O9SNnxbVr8XSdkeV0UL",
        "-O9SNnxbVr8XSdkeV0UM",
        "-O9SNnxbVr8XSdkeV0UN",
        "-O9SNnxcv4km8YAG4-yb",
        "-O9SNnxcv4km8YAG4-yc",
        "-O9SNnxcv4km8YAG4-yd",
        "-O9SNnxcv4km8YAG4-ye",
        "-O9SNnxcv4km8YAG4-yf",
        "-O9SNnxcv4km8YAG4-yg",
        "-O9SNnxcv4km8YAG4-yh",
        "-O9SNnxcv4km8YAG4-yi",
        "-O9SNnxcv4km8YAG4-yj",
        "-O9SNnxcv4km8YAG4-yk",
        "-O9SNnxcv4km8YAG4-yl",
        "-O9SNnxcv4km8YAG4-ym"
        ]
//        for (i, book) in books.enumerated() {
//            let child = g_DBReference.child("/books/\(book)")
//            child.child("authorName").setValue(authorsname[i])
//            child.child("authorId").setValue(authors[i])
////            child.child("id").getData(completion: {
////                (ss, err) in
////                print(err!.value)
////            })
//        }
    //        let child = g_DBReference.child("/books/\(books[11])")
    //        child.child("authorName").setValue(authorsname[11])
    //        child.child("authorId").setValue(authors[11])
    }
    
    //---- MARK: Action Methods
    public func observeDataAtPathOnce(path: String, completion: @escaping (DataSnapshot) -> Void) {
        g_DBReference.child(path).observeSingleEvent(of: .value, with: {
            snapshot  in
            completion(snapshot)
        })
    }
    
    public func setValueAtPath(path: String, value: Any?, completion: @escaping () -> Void) {
        g_DBReference.child(path).setValue(value) {
            (error, dbRef) in
            print(error?.localizedDescription)
            completion()
        }
    }
}
