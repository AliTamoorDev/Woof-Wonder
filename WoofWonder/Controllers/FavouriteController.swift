//
//  FavouriteController.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import UIKit

class FavouriteController: UIViewController {
    
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    
    private var vm = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouritesCollectionView.register(UINib(nibName: "DogImageCell2", bundle: nil), forCellWithReuseIdentifier: "DogImageCell2")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favouritesCollectionView.reloadData()
    }
}

extension FavouriteController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.favouriteSpecies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCell2", for: indexPath) as! DogImageCell2
        
        DispatchQueue.main.async {
            cell.dogImageView.image = ViewModel.favouriteSpecies[indexPath.item].image
            cell.speciesName.text = ViewModel.favouriteSpecies[indexPath.item].name
            cell.dogImageView.contentMode = .scaleToFill
            cell.dogImageView.layer.cornerRadius = 10
            cell.setNeedsLayout()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10 // Adjust the spacing as needed
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust the spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust the spacing between items in the same row
    }
}
