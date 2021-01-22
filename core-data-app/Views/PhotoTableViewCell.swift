//
//  PhotoTableViewCell.swift
//  core-data-app
//
//  Created by Boris on 22.01.2021.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
  let photoImageView: UIImageView = {
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    addSubview(photoImageView)
    
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
      photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
  }
  
}
