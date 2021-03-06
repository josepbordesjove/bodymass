//
//  ViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 5/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit
import Firebase

class MainViewController: UIViewController {
  
  private var interactor: MainInteractorType
  private var dataPoints: [ManagedDataPoint] = []
  
  private var vm: VM? {
    didSet {
      mainSummary.reloadViewContent(height: vm?.height, weight: vm?.weight)
    }
  }
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.bounces = true
    scrollView.alwaysBounceHorizontal = false
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: scrollView.bounds.height)
    scrollView.isScrollEnabled = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    return scrollView
  }()
  
  lazy var header = Header(title: interactor.getTitle())
  lazy var mainSummary = MainSummary()
  lazy var history = History(historyDataPoints: dataPoints, gender: vm?.gender)
  lazy var reloadButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "update"), size: 49)
  lazy var trashButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "trash"), size: 35)
  lazy var shareButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "share"), size: 35)
  
  init(interactor: MainInteractorType) {
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Analytics.logEvent("main_view_controller_appeared", parameters: nil)
    
    setupView()
    setupConstraints()
    setupScrollViewConstraints()
    setupButtonTargets()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    reloadDataPoint()
    fetchAllDatapoints()
  }
  
  func setupButtonTargets() {
    reloadButton.addTarget(self, action: #selector(presentAddDataViewController), for: .touchUpInside)
    shareButton.addTarget(self, action: #selector(presentSettingsViewController), for: .touchUpInside)
    trashButton.addTarget(self, action: #selector(changeCurrentScreen), for: .touchUpInside)
  }
  
  func setupView() {
    view.insetsLayoutMarginsFromSafeArea = true
    
    view.backgroundColor = .lightGrey
    [mainSummary, history].forEach { scrollView.addSubview($0) }
    [header, scrollView, reloadButton, trashButton, shareButton ].forEach{ view.addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: view.topAnchor),
      header.leftAnchor.constraint(equalTo: view.leftAnchor),
      header.rightAnchor.constraint(equalTo: view.rightAnchor),
      header.heightAnchor.constraint(equalToConstant: 60 + UIScreen.main.bounds.height * 0.095),
      
      scrollView.topAnchor.constraint(equalTo: header.bottomAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: reloadButton.topAnchor),
      
      reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
      reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      trashButton.rightAnchor.constraint(equalTo: reloadButton.leftAnchor, constant: -60),
      trashButton.centerYAnchor.constraint(equalTo: reloadButton.centerYAnchor),
      
      shareButton.leftAnchor.constraint(equalTo: reloadButton.rightAnchor, constant: 60),
      shareButton.centerYAnchor.constraint(equalTo: reloadButton.centerYAnchor),
      ])
  }
  
  func setupScrollViewConstraints() {
    NSLayoutConstraint.activate([
      mainSummary.topAnchor.constraint(equalTo: header.bottomAnchor),
      mainSummary.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      mainSummary.widthAnchor.constraint(equalTo: view.widthAnchor),
      mainSummary.bottomAnchor.constraint(equalTo: reloadButton.topAnchor, constant: -20),
      
      history.leftAnchor.constraint(equalTo: mainSummary.rightAnchor),
      history.topAnchor.constraint(equalTo: scrollView.topAnchor),
      history.bottomAnchor.constraint(equalTo: mainSummary.bottomAnchor),
      history.widthAnchor.constraint(equalTo: view.widthAnchor),
      ])
  }
  
  //  MARK: Helper methods
  
  func fetchAllDatapoints() {
    interactor.fetchAllDataPoints { (managedDataPoints) in
      if let managedDataPoints = managedDataPoints {
        self.history.historyDataPoints = managedDataPoints.map { History.VM(id: $0.id, weight: $0.weight, height: $0.height, gender: self.vm?.gender, date: $0.creationDate) }
      }
    }
  }
  
  @objc func changeCurrentScreen() {
    let newPoint = scrollView.contentOffset.x > 0 ? mainSummary.frame.minX : history.frame.minX
    let newImage = scrollView.contentOffset.x > 0 ? #imageLiteral(resourceName: "trash") : #imageLiteral(resourceName: "back")
    
    if scrollView.contentOffset.x > 0 {
      Analytics.logEvent("did_check_history", parameters: nil)
    }
      
    trashButton.setImage(newImage, for: .normal)
    scrollView.setContentOffset(CGPoint(x: newPoint, y: 0), animated: true)
  }
  
  func getScreenshot() -> UIImage? {
    guard let keyWindow = UIApplication.shared.keyWindow else { return nil }
    UIGraphicsBeginImageContextWithOptions(keyWindow.layer.frame.size, false, UIScreen.main.scale)
    
    guard let graphicsCurrentContext = UIGraphicsGetCurrentContext() else { return nil }
    keyWindow.layer.render(in: graphicsCurrentContext)
    
    return UIGraphicsGetImageFromCurrentImageContext()
  }
  
  func reloadDataPoint() {
    interactor.getBmiComparison { difference in
      self.mainSummary.setEmojiFor(difference: difference)
    }
    
    interactor.fetchLastDataPoint { vm, _ in
     self.vm = vm
    }
    
    if let gender = interactor.fetchUserGender() {
      self.vm?.gender = gender
    }
  }
  
  // MARK: - Presentation methods
  
  @objc func presentAddDataViewController() {
    let addDataViewController = self.interactor.addDataViewController(observer: self, weight: vm?.weight, height: vm?.height, gender: vm?.gender)
    addDataViewController.transitioningDelegate = self
    
    present(addDataViewController, animated: true)
  }
  
  @objc func presentSettingsViewController() {
    guard let height = vm?.height else { return }
    guard let weight = vm?.weight else { return }
    
    let settingsViewController = SettingsViewController(height: height, weight: weight, shareImageView: mainSummary.asImage(), observer: self)
    self.present(settingsViewController, animated: true, completion: nil)
  }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return MainVCToAddDataVCTransition()
  }
}

extension MainViewController: DataPointObserver {
  func didCreateDataPoint() {
    self.reloadDataPoint()
    self.fetchAllDatapoints()
  }
}

extension MainViewController: UserNameObserver {
  func didChangeUserName() {
    header.pageTitle.text = interactor.getTitle()
  }
}

extension MainViewController {
  struct VM {
    let id: String
    var weight: Double
    var height: Double
    var gender: Gender
  }
}
