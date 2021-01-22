//
//  ViewController.swift
//  core-data-app
//
//  Created by Boris on 22.01.2021.
//

import UIKit

class MainViewController: UIViewController {
  // MARK: - Private properties
  private let cellID = "cellID"
  
  private lazy var tableView: UITableView = UITableView()
  
  private lazy var button: UIButton = {
    let button = UIButton(type: .custom)
    button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    button.clipsToBounds = true
    button.layer.cornerRadius = 8
    button.layer.zPosition = 1
    button.setTitle("Add photo", for: .normal)
    button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
    return button
  }()
  
  private var photos: [Photo] = []
  
  private var dataManager: DataManagerProtocol!

  init(dataManager: DataManagerProtocol) {
    super.init(nibName: nil, bundle: nil)
    
    self.dataManager = dataManager
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    configureButton()
    
    fetchData()
  }
  
  // MARK: - Private methods
  private func configureTableView() {
    view.addSubview(tableView)
    
    tableView.frame = view.bounds
    tableView.rowHeight = 150
    tableView.dataSource = self
    tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: cellID)
    tableView.tableFooterView = UIView()
  }
  
  private func configureButton() {
    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
      button.heightAnchor.constraint(equalToConstant: 60),
      button.widthAnchor.constraint(equalToConstant: 120)
    ])
  }
  
  @objc
  private func addPhoto() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    present(picker, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    photos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    let photo = photos[indexPath.row]
    
    guard let photoCell = cell as? PhotoTableViewCell else {
      return cell
    }
    
    photoCell.photoImageView.image = UIImage(data: photo.image!)
    return photoCell
  }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deletePhoto(forRowAt: indexPath)
    }
  }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let userPickedImage = info[.editedImage] as? UIImage else { return }
    
    if let imageData = userPickedImage.pngData() {
      addNewPhoto(imageData: imageData)
    }
    
    picker.dismiss(animated: true)
  }
}

// MARK: - Manipulate with data
extension MainViewController {
  private func fetchData() {
    photos = dataManager.fetchPhotos()
    tableView.reloadData()
  }
  
  private func addNewPhoto(imageData: Data) {
    let photo = dataManager.savePhoto(data: imageData)
    photos.append(photo)
    
    let cellIndex = IndexPath(row: photos.count - 1, section: 0)
    tableView.insertRows(at: [cellIndex], with: .automatic)
  }
  
  private func deletePhoto(forRowAt indexPath: IndexPath) {
    photos.remove(at: indexPath.row)
    dataManager.deletePhoto(indexPath: indexPath)
    tableView.deleteRows(at: [indexPath], with: .fade)
  }
}

