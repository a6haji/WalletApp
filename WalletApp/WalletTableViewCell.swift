//
//  WalletTableViewCell.swift
//  WalletApp
//
//  Created by Aly Haji on 2017-03-26.
//  Copyright © 2017 Aly Haji. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var Card: UIView!
    
    @IBOutlet weak var AccountName: UILabel!
    @IBOutlet weak var BalanceAmount: UILabel!
    
    @IBOutlet weak var EffectiveDates: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.Card.layer.cornerRadius = 10
        self.Card.layer.masksToBounds = true
        self.Card.layer.backgroundColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
