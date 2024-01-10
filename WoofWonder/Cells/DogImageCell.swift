//
//  DogImageCell.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import UIKit

class DogImageCell: UICollectionViewCell {
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var speciesName: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        dogImageView.image = nil
        dogImageView.layer.cornerRadius = 0
        speciesName.text = ""
    }
}
