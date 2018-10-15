//
//  PickerViewCotroller.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class PickerViewController: UIAlertController {
  
  let units: [Units]
  private let interactor: PickerInteractorType
  weak var delegate: PickerViewControllerDelegate?
  
  init(units: [Units], interactor: PickerInteractorType) {
    self.units = units
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
    
    title = "Select a unit from the list"
    message = "You can change the units used for the calculations for one of the following ones"

    var actions: [UIAlertAction] = units.compactMap { return UIAlertAction(title: $0.description(), style: .default) { self.selectUnits(unit: $0.title) } }
    actions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    actions.forEach { addAction($0) }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func selectUnits(unit: String?) {
    guard let unitsStringed = unit else { return }
    guard let units = Units.fromStringDescriptionToUnits(unitsStringed) else { return }
    
    interactor.saveSelectedUnits(units)
    delegate?.unitsChanged()
  }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.units.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.units[row].rawValue
  }
  
}