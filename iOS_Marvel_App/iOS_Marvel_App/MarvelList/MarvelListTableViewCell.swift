//
//  MarvelListTableViewCell.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 28/10/23.
//

import UIKit

class MarvelListTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.layer.cornerRadius = CGFloat(12)
        self.selectionStyle = .none
    }
    
    func configureData(data: MarvelCharacterUIModel?) {
        titleLabel.text = data?.name
        descriptionLabel.text = data?.description
        if let url = data?.thumbnail {
            characterImageView.loadImageFromUrl(url: url)
        }
    }
}
