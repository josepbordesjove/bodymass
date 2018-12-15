//
//  PickerViewCotroller.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit
import Firebase

class PickerViewController: UIAlertController {
  
  let units: [Units]
  private let interactor: PickerInteractorType
  weak var delegate: PickerViewControllerDelegate?
  
  init(units: [Units], interactor: PickerInteractorType) {
    self.units = units
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
    
    Analytics.logEvent("picker_controller_appeared", parameters: nil)
    
    title = "Select a unit from the list"
    message = "You can change the units used for the calculations for one of the list below"

    var actions: [UIAlertAction] = units.compactMap { return UIAlertAction(title: $0.description(), style: .default) { self.selectUnits(unit: $0.title) } }
    actions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    actions.forEach { addAction($0) }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func selectUnits(unit: String?) {
    guard let unitsStringed = unit else { return }
    guard let units = Units.fromStringLongNameToUnits(unitsStringed) else { return }
    let isHeightUnit = Units.heightUnitsAvailable.contains(units)
    
    interactor.saveSelectedUnits(units)
    delegate?.unitsChanged(ofType: isHeightUnit ? .height : .weight)
  }
}
