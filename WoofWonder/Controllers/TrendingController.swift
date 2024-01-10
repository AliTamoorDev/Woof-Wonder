//
//  ViewController.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import UIKit

class TrendingController: UIViewController {
    
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var refresher:UIRefreshControl!
    private var vm = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trendingCollectionView.register(UINib(nibName: "DogImageCell2", bundle: nil), forCellWithReuseIdentifier: "DogImageCell2")
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(refreshTrendingData(_:)), for: .valueChanged)
        trendingCollectionView.refreshControl = refresher
        fetchImages()
    }
    
    @objc private func refreshTrendingData(_ sender: Any) {
        fetchImages()
    }
    
    func fetchImages() {
        for _ in 0..<4 {
            vm.fetchRandomImages()
        }
        vm.observeApiCompletion {
            print("All API calls completed. Total images: \(self.vm.breeds.count)")
            self.trendingCollectionView.refreshControl!.endRefreshing()
            self.trendingCollectionView.reloadData()
        }
    }
}

extension TrendingController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.breeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCell2", for: indexPath) as! DogImageCell2
        let data = vm.breeds[indexPath.item]
        
        DispatchQueue.main.async {
            if let img = data.image {
                cell.dogImageView.image = img
                cell.dogImageView.contentMode = .scaleToFill
                cell.dogImageView.layer.cornerRadius = 10
                cell.speciesName.text = data.name
            } else {
                cell.dogImageView.image = UIImage(named: "notFound")
                cell.dogImageView.contentMode = .scaleToFill
                cell.dogImageView.layer.cornerRadius = 10
                cell.speciesName.text = "Not Found"
            }
            cell.setNeedsLayout()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10 // Adjust the spacing as needed
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // Adjust the spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust the spacing between items in the same row
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let img = vm.breeds[indexPath.item].image {
            let imageDataArray = ViewModel.favouriteSpecies.map { $0.image?.pngData() }
            let newImageData = img.pngData()
            
            if !imageDataArray.contains(where: { $0 == newImageData }) {
                DispatchQueue.main.async {
                    ViewModel.favouriteSpecies.append(SpecieData(name: self.vm.breeds[indexPath.item].name, image: img))
                    self.view.showToast(message: "Add to Favourites!")
                }
            } else {
                DispatchQueue.main.async {
                    self.view.showToast(message: "Already Added!")
                }
            }
        }
    }
}
