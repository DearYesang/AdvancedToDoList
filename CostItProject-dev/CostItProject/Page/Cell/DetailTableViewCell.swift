//
//  DetailTableViewController.swift
//  CostItProject
//
//  Created by 정기현 on 2023/08/16.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet var comments: UILabel!
    @IBOutlet var commentId: UILabel!
    @IBOutlet var commentImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
