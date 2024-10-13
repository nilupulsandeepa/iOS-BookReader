//
//  BRFIRManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import Foundation
import FirebaseDatabase

public class BRFIRDatabaseManager {
    var ref: DatabaseReference!

    init() {
        ref = Database.database().reference()
        ref.child("/users/hhhhhh").getData(completion: {
            err, snapshot in
            var ss = snapshot!.value! as! [String: Any]
            print(ss["rented_books"]! as! [String])
        })
//        let books: [String] = [
//            "Echoes of Eternity",
//            "The Forgotten Chronicles",
//            "Whispers in the Dark",
//            "Shadows of the Lost City",
//            "The Celestial Code",
//            "Beneath the Starlit Sea",
//            "The Silent Prophecy",
//            "Fragments of a Broken World",
//            "The Enchanted Key",
//            "Legacy of the Firestone",
//            "The Winter’s Secret",
//            "Through the Veil",
//            "The Midnight Tapestry",
//            "Winds of Destiny",
//            "The Keeper's Dilemma",
//            "The Last Ember",
//            "Daughters of the Moonlight",
//            "The Crimson Crown",
//            "Sands of the Forgotten",
//            "Veil of Shadows",
//            "The Alchemist’s Curse",
//            "Beyond the Silver Horizon",
//            "Fates Entwined",
//            "The Obsidian Mirror",
//            "Waking the Serpent",
//            "Echoes from the Abyss",
//            "The Lantern's Glow",
//            "Threads of Fate",
//            "The Ghosts of Emberfall",
//            "Secrets of the Hollow Tree",
//            "The Dragon’s Tear",
//            "Realm of the Fallen",
//            "Beneath the Iron Sky",
//            "The Timekeeper’s Apprentice",
//            "Crown of Ash and Bone"
//        ]
//        let recent: [String] = [
//            "-O9-mNJolBCjdEXdTQWI",
//            "-O9-mNJolBCjdEXdTQWJ",
//            "-O9-mNJolBCjdEXdTQWK",
//            "-O9-mNJolBCjdEXdTQWL",
//            "-O9-mNJolBCjdEXdTQWM",
//            "-O9-mNJolBCjdEXdTQWN",
//            "-O9-mNJolBCjdEXdTQWO",
//            "-O9-mNJolBCjdEXdTQWP",
//            "-O9-mNJolBCjdEXdTQWQ",
//            "-O9-mNJolBCjdEXdTQWR",
//            "-O9-mNJolBCjdEXdTQWS",
//            "-O9-mNJolBCjdEXdTQWT",
//            "-O9-mNJolBCjdEXdTQWU",
//            "-O9-mNJpDX9hA96DXCps",
//            "-O9-mNJpDX9hA96DXCpt"
//        ]
//        for i in 0..<recent.count {
//            let ss = ref.child("/recent_books/\(recent[i])")
//            ss.setValue(["id": recent[i], "name": books[i]])
//        }
        
    }
}
