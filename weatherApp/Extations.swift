//
//  Extations.swift
//  weatherApp
//
//  Created by Pavel Mednikov on 24/01/2023.
//

import Foundation

extension String{
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
