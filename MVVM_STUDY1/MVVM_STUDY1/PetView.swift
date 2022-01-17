//
//  PetView.swift
//  MVVM_STUDY1
//
//  Created by abc on 2022/01/14.
//

import Foundation
import UIKit

final class PetView: UIView {
  lazy var imageView: UIImageView = {
    let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    imageview.contentMode = .scaleAspectFit
    imageview.translatesAutoresizingMaskIntoConstraints = false
    return imageview
  }()
  
  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.textAlignment = .center
    return nameLabel
  }()
  
  lazy var ageLabel: UILabel = {
    let ageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    ageLabel.translatesAutoresizingMaskIntoConstraints = false
    ageLabel.textAlignment = .center
    return ageLabel
  }()
  
  lazy var adoptionFeeLabel: UILabel = {
    let adoptionFeeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    adoptionFeeLabel.translatesAutoresizingMaskIntoConstraints = false
    adoptionFeeLabel.textAlignment = .center
    return adoptionFeeLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(imageView)
    addSubview(nameLabel)
    addSubview(ageLabel)
    addSubview(adoptionFeeLabel)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//MARK: - UI

extension PetView {
  private func setupUI() {
    //imageview
    imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
    
    //nameLabel
    nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
    nameLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    //ageLabel
    ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
    ageLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    ageLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    //adoptionFeeLabel
    adoptionFeeLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 16).isActive = true
    adoptionFeeLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    adoptionFeeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
  }
}
