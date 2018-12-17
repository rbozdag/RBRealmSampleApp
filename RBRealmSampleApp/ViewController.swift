//
//  ViewController.swift
//  RealmNoteApp
//
//  Created by Rahmi on 17.12.2018.
//  Copyright © 2018 rbozdag. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    @IBOutlet weak var contentLabel: UILabel!

    lazy var realm: Realm? = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            print("ViewController", "unable to initialize Realm")
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printPets(nil)
    }

    @IBAction func clearAllData() {
        do {
            try realm?.write { [weak self] in
                self?.realm?.objects(User.self).forEach { [weak self] in
                    self?.realm?.delete($0)
                }

                self?.realm?.objects(Pet.self).forEach { [weak self] in
                    self?.realm?.delete($0)
                }
            }
        } catch {
            print("ViewController", "unable to delete")
        }
    }

    static let TagPetName = 0
    static let TagUserName = 1

    @IBAction func addTestData(_ sender: Any?) {
        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        alert.addTextField {
            $0.tag = ViewController.TagPetName
            $0.placeholder = "Pet Name"
        }

        alert.addTextField {
            $0.tag = ViewController.TagUserName
            $0.placeholder = "Owner Name"
        }

        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let petNameTf = alert.textFields?.first(where: { return $0.tag == ViewController.TagPetName }) else { return }
            guard let userNameTf = alert.textFields?.first(where: { return $0.tag == ViewController.TagUserName }) else { return }

            var user: User?
            if let userName = userNameTf.text, userName.count > 0 {
                user = User(name: userName, pet: nil)
            }

            var pet: Pet?
            if let petName = petNameTf.text, petName.count > 0 {
                pet = Pet(petName: petName, owner: user)
                do { //add
                    try self?.realm?.write { [weak self] in
                        self?.realm?.add(pet!)
                    }
                } catch {
                    print("ViewController", "unable to add pet")
                }
            }

            if let user = user {
                do {
                    try self?.realm?.write { // update
                        user.pet = pet
                    }
                } catch {
                    print("ViewController", "unable to add user")
                }
            }
            
            self?.printPets(nil)
        })

        self.present(alert, animated: true, completion: { })
    }

    @IBAction func printPets(_ sender: Any?) {
        let pets = realm?.objects(Pet.self)
        contentLabel.text = pets?.reduce("", { result, pet in return "\(result!)\n\(pet.petName!), owner: \(pet.owner?.name ?? "-")" })
    }

    @IBAction func printOwners(_ sender: Any?) {
        let pets = realm?.objects(User.self)
        contentLabel.text = pets?.reduce("", { result, user in return "\(result!)\n\(user.name!), pet: \(user.pet?.petName ?? "-")" })
    }
}

