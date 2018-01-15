//
//  GitFeedCell.swift
//  Rx-Playgrounds
//
//  Created by Birapuram Kumar Reddy on 1/15/18.
//  Copyright © 2018 KRiOSApps. All rights reserved.
//

import UIKit

class GitFeedCell: UITableViewCell {

    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var actorImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(metaData:MetaDataModel){
        actorName.text = metaData.actorName
        eventType.text = metaData.eventType
    }
}
