//
//  SearchController.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import UIKit

class SearchController: UIViewController {
    
    @IBOutlet weak var txtFieldContainer: UIView!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var successLbl: UILabel!
    
    @IBOutlet weak var instructionsLbl: UILabel!
     
    private var searchedImg: SpecieData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTxtField.delegate = self
        txtFieldContainer.layer.cornerRadius = 10
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let img = self.searchedImg?.image else { return }
        
        let imageDataArray = ViewModel.favouriteSpecies.map { $0.image?.pngData() }
        let newImageData = img.pngData()
        
        if !imageDataArray.contains(where: { $0 == newImageData }) {
            DispatchQueue.main.async {
                ViewModel.favouriteSpecies.append(SpecieData(name: self.searchedImg?.name ?? "", image: img))
                self.view.showToast(message: "Add to Favourites!")
            }
        } else {
            DispatchQueue.main.async {
                self.view.showToast(message: "Already Added!")
            }
        }
    }
}
extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        debugPrint("Enter Pressed!")
        ViewModel().searchForDog(breed: textField.text ?? "") { name, img  in
            if let img = img {
                DispatchQueue.main.async {
                    self.imageView.image = img
                    self.successLbl.text = "Here is your cute \(textField.text ?? "")!"
                    self.instructionsLbl.isHidden = true
                    self.searchedImg = SpecieData(name: name, image: img)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "notFound")
                    self.successLbl.text = "Can't find \(textField.text ?? "")"
                    self.instructionsLbl.isHidden = false
                }
            }
        }
        return true
    }
}
