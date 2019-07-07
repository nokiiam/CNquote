//
//  QuoteTableViewCell.swift
//  CNquote
//
//  Created by Adrien Hellec on 07/07/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit
import Cosmos

class QuoteTableViewCell: UITableViewCell {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var starsCosmosView: CosmosView!
}
