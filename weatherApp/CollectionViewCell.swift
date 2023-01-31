//
//  CollectionViewCell.swift
//  weatherApp
//
//  Created by Pavel Mednikov on 16/01/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identefier = "CollectionViewCell"
     
      let label: UILabel = {
         let label = UILabel()
          
          label.font = .systemFont(ofSize: 30, weight: .ultraLight)
          label.textAlignment = .center
          label.adjustsFontSizeToFitWidth = true
          label.sizeToFit()
         label.contentMode = .scaleAspectFill
         return label
         
     }()
    
  
     
  
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         contentView.addSubview(label)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
        label.frame = contentView.bounds
     }
     
    public func configure(city: Any){
        
        
        label.text = city as? String 
     }
 }


