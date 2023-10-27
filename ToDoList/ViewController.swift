//
//  ViewController.swift
//  ToDoList
//
//  Created by MacBook27 on 25/10/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var models = [ToDoListItem]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreData To Do List"
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ToDoListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ToDoListTableViewCell.identifier)
        
        CoreDataOperations.shared.delegate = self
        CoreDataOperations.shared.getAllItems()
    }
    
    func tableViewReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            CoreDataOperations.shared.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    @objc private func onUpdateAt(item: ToDoListItem) {
        let alert = UIAlertController(title: "Update Data", message: "Enter new data", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "\(item.name ?? "")"
        }
        
        alert.addAction(UIAlertAction(title: "Update", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            CoreDataOperations.shared.updateItem(item: item, newName: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.identifier, for: indexPath) as! ToDoListTableViewCell
        cell.configure(item: model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (contextualAction, view, boolValue) in
            let item = self.models[indexPath.row]
            CoreDataOperations.shared.deleteItem(item: item)
            
            //deleting from local array
            let index = indexPath.row
            self.models.remove(at: index)
        }
        
        let update = UIContextualAction(style: .normal, title: "update") { (contextualAction, view, boolValue) in
            self.onUpdateAt(item: self.models[indexPath.row])
        }
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ViewController: CoreDataOperationsDelegate {
    func reloadData(id: UUID) {
        self.tableViewReload()
    }
    
    func passData(data: [ToDoListItem]) {
        self.tableViewReload()
        self.models = data
    }
}
