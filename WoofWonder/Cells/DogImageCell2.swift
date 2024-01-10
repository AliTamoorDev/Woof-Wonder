//
//  DogImageCell2.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 19/12/2023.
//

import UIKit

class DogImageCell2: UICollectionViewCell {
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var speciesName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dogImageView.image = nil
        dogImageView.layer.cornerRadius = 0
        speciesName.text = ""
    }
}
