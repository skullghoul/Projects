//
//  DisplayUserTableViewController.swift
//  RandomPersonApi
//
//  Created by Zander Ewell on 2/28/23.
//
import UIKit



class DisplayUserTableViewController: UITableViewController {
    
    
    var stepperInfo: Int = 1
    
    var inclusionParameters = [String]()
    
    var users = [Response]()
    var settingsVC: SettingsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData()
        overrideUserInterfaceStyle = .dark
    }
    
    func settingsDidChange(switchStates: [Bool]) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomUser", for: indexPath) as! RandomUserTableViewCell
        
        
        
        let randomUser = users[indexPath.row]
        
        if let random = randomUser.results[0].gender, !random.isEmpty {
            cell.genderLabel.text = randomUser.results[0].gender
            cell.identifierGender.text = "Gender:"
        }
        
        
        if let random = randomUser.results[0].email, !random.isEmpty {
            cell.emailLabel.text = randomUser.results[0].email
            cell.identifierEmail.text = "Email:"
        }
        
        if let random = randomUser.results[0].login?.password, !random.isEmpty {
            cell.loginLabel.text = randomUser.results[0].login?.password
            cell.identifierLogin.text = "Login:"
        }
        
        if let _  = randomUser.results[0].registered?.age {
            cell.registeredLabel.text = String((randomUser.results[0].registered?.age)!)
            cell.identifierRegistered.text = "Registered"
        } else {
            
        }
        
        
        
        if let random = randomUser.results[0].dob?.date, !random.isEmpty {
            cell.dOBLabel.text = randomUser.results[0].dob?.date
            
            cell.identifierDOB.text = "DOB:"
        }
        
        if let random = randomUser.results[0].phone, !random.isEmpty {
            cell.phoneLabel.text = randomUser.results[0].phone
            
            cell.identifierPhone.text = "Phone:"
        }
        
        if let random = randomUser.results[0].cell, !random.isEmpty {
            cell.cellLabel.text = randomUser.results[0].cell
            
            cell.identifierCell.text = "Cell:"
        }
        
        if let random = randomUser.results[0].id?.value, !random.isEmpty {
            cell.iDLabel.text = randomUser.results[0].id?.value
            
            cell.identifierID.text = "ID:"
        } else {
            print("ID no work")
        }
        
        if let random = randomUser.results[0].nat, !random.isEmpty {
            cell.NatLabel.text = randomUser.results[0].nat
            
            cell.identifierNat.text = "Nat"
        }
        
        if let imageUrl = URL(string: randomUser.results[0].picture.large) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                } else if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.userImageView.image = image
                    }
                }
            }.resume()
        }
        
        
        cell.nameLabel.text = "\(randomUser.results[0].name.first) \(randomUser.results[0].name.last)"
        
        guard let city = (randomUser.results[0].location?.city),
              let state = randomUser.results[0].location?.state,
              let country = randomUser.results[0].location?.country else { return cell}
        
        if !city.isEmpty {
            cell.locationLabel.text = "\(city) \(state) \(country)"
            cell.identifierLocation.text = "Location:"
        }
        
        
        

        
        // Configure the cell...
        return cell
    }
    
    
    
    func userData() {
        Task {
            do {
                let randomAPIController = RandomAPI.RandomAPIController()
                for _ in 1...stepperInfo {
                    print(1...stepperInfo)
                    let randomUser = try await randomAPIController.fetchRandomUser(userAmount: stepperInfo, inclusionParameters)
                    users.append(randomUser)
                }
                
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

