//
//  UIView.swift
//  WoofWonder
//
//  Created by Ali Tamoor on 18/12/2023.
//

import Foundation
import UIKit

extension UIView {
    func showToast(message: String, duration: TimeInterval = 1.0) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: ((self.frame.size.height) - 200), width: self.frame.size.width - 32, height: 44))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        self.addSubview(toastLabel)

        UIView.animate(withDuration: 1.5, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
