//
//  DogResponse.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import Foundation
import UIKit

struct DogApiResponse: Codable {
    let status: String
    let message: String
}

struct SpecieData {
    let name: String
    let image: UIImage?
}
