//
//  DisplayUserTableViewController.swift
//  RandomPersonApi
//
//  Created by Zander Ewell on 2/28/23.
//

import UIKit



class DisplayUserTableViewController: UITableViewController, SettingsTableViewControllerDelegate {
    func callAPI() {
//        Task {
//            do {
//                let dataOfUser = try await controller.fetchUserInfo()
//                self.user = dataOfUser
//                tableView.reloadData()
//            } catch {
//                print("Broke")
//            }
//        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userData()

    }
    
//    var controller = RandomAPIController()
    
    var user = [Response]()
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUser", for: indexPath) as! RandomUserTableViewCell

        let randomUser = user[indexPath.row]
        
        cell.nameLabel.text = "\(randomUser.results[0].name.first) \(randomUser.results[0].name.last)"
        // Configure the cell...

        return cell
    }
    


    func userData() {
        Task {
            do {
                let randomAPIController = RandomAPI.RandomAPIController()

                let randomUser = try await randomAPIController.fetchRandomUser()
                user.append(randomUser)
                let randomImage = try await randomAPIController.randomImage(from: randomUser.results[0].picture.large)

                tableView.reloadData()
            } catch {
                print(error.localizedDescription) // print the localized description of the error
            }
        }
    }
}
 



//        self.user = []

//RandomApiController().fetchRandomUsers { result in
//    switch result {
//    case .success(let randomUsers):
//        print("Fetched \(randomUsers.count) random users:")
//        for user in randomUsers {
//            print("- \(user.name.first) \(user.name.last)")
//        }
//    case .failure(let error):
//        print("Error fetching random users: \(error.localizedDescription)")
//    }
//}
//
//        tableView.reloadData()
//    }
