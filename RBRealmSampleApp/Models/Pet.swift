//
//  Pet.swift
//  RealmNoteApp
//
//  Created by Rahmi on 17.12.2018.
//  Copyright © 2018 rbozdag. All rights reserved.
//

import Foundation
import RealmSwift

class Pet: Object {
    @objc dynamic var petName: String?
    @objc dynamic weak var owner: User?

    convenience init(petName: String, owner: User?) {
        self.init()
        self.petName = petName
        self.owner = owner
    }
}

