//
//  TaskList.swift
//  RealmNoteApp
//
//  Created by Rahmi on 17.12.2018.
//  Copyright © 2018 rbozdag. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    @objc dynamic var name: String?
    @objc dynamic weak var pet: Pet?

    convenience init(name: String?, pet: Pet?) {
        self.init()
        self.name = name
        self.pet = pet
    }
}
