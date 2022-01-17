//
//  ViewController.swift
//  MVVM_STUDY1
//
//  Created by abc on 2022/01/14.
//

import UIKit

class ViewController: UIViewController {
  
  let birthday = Date(timeIntervalSinceNow: (-2 * 86400 * 366))
  let image = UIImage(named: "stuart")!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    let stuart = Pet(name: "Stuart", birthday: birthday, rarity: .veryRare, image: image)
    let viewModel = PetViewModel(pet: stuart)
    
    let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let petView = PetView(frame: frame)
    petView.translatesAutoresizingMaskIntoConstraints = false
    
    viewModel.configure(petView)
    
    view.addSubview(petView)
    petView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    petView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    petView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
    petView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
  }


}

