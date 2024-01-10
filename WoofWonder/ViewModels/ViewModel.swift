//
//  ViewModel.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import Foundation
import UIKit

class ViewModel {

    var breeds: [SpecieData] = []
    let apiGroup = DispatchGroup()
    static var favouriteSpecies: [SpecieData] = []

    func fetchRandomImages() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
            return
        }
        breeds = []
        apiGroup.enter()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                self.apiGroup.leave()
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DogApiResponse.self, from: data)
                self.loadImage(url: result.message) { img in
                    defer {
                        self.apiGroup.leave()
                    }
                    let breed = self.getNameFromURL(url: result.message) 
                    self.breeds.append(SpecieData(name: breed, image: img))
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
        
    }
    
    func getNameFromURL(url: String) -> String{
        let imageUrl = url
        var breed = ""
        if let startIndex = imageUrl.range(of: "breeds/")?.upperBound,
           let endIndex = imageUrl.range(of: "/", range: startIndex..<imageUrl.endIndex)?.lowerBound {
            breed = String(imageUrl[startIndex..<endIndex])
        }
        return breed
    }
    
    func observeApiCompletion(completion: @escaping () -> Void) {
        apiGroup.notify(queue: .main) {
            // All API calls have completed
            completion()
        }
    }
    
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> ()) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
    
    // MARK: - Searching a Dog Species
    func searchForDog(breed: String, completion: @escaping (String,UIImage?)->Void ) {
        
        guard let url = URL(string: "https://dog.ceo/api/breed/\(breed.lowercased())/images/random") else {
            completion("",nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion("",nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DogApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self.loadImage(url: result.message) { img in
                        completion(self.getNameFromURL(url: result.message),img)
                    }
                }
            } catch {
                completion("",nil)
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
