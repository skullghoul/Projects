//
//  ViewController.swift
//  RandomizationApp
//
//  Created by Zander Ewell on 2/24/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var names = [Name]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print(names.count)
        return names.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRow", for: indexPath) as! NameTableViewCell
        
        let name = names[indexPath.row]
        
        cell.nameLabel.text = name.name
        
        return cell
    }
    
    
    @IBAction func saveUser(_ sender: Any) {
        loadName()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        randomSelection()
    }
    
    
    @IBAction func reset(_ sender: Any) {
        reset()
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let key = presses.first?.key else { return }

        switch key.keyCode {
        case .keyboardReturnOrEnter:
            loadName()
        default:
            super.pressesBegan(presses, with: event)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func randomSelection() {
        var chosen = names.randomElement()?.name
        nameLabel.text = chosen
        let alert = UIAlertController(title: chosen, message: "Random User Selected", preferredStyle: .alert)
        
        let actionOkay = UIAlertAction(title: "Done", style: .default)
        
        alert.addAction(actionOkay)
        present(alert, animated: true)
    }
    
    func reset() {
        names.removeAll()
        tableView.reloadData()
        nameLabel.text = ""
    }
    
    func loadName() {
        if !textField.text!.isEmpty {
            let saveNamed = Name(name: textField.text!)
            names.insert(saveNamed, at: 0)
            print(saveNamed.name)
            textField.text = ""
            tableView.reloadData()
        } else {

        }
        
    }
    
    
}
