//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by MacBook27 on 26/10/23.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell {
    
    static let identifier = "ToDoListTableViewCell"
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: ToDoListItem) {
        itemLabel.text = item.name
    }
}
