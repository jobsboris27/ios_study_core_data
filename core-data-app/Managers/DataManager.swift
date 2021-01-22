//
//  DataManager.swift
//  core-data-app
//
//  Created by Boris on 22.01.2021.
//

import Foundation
import UIKit
import CoreData

protocol DataManagerProtocol {
  func savePhoto(data: Data) -> Photo
  func fetchPhotos() -> [Photo]
  func deletePhoto(indexPath: IndexPath)
}

struct DataManager: DataManagerProtocol {
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  static let shared = DataManager()
  
  func savePhoto(data: Data) -> Photo {
    let imageInstance = Photo(context: context)
    imageInstance.image = data
    saveContext()
    return imageInstance
  }
  
  func fetchPhotos() -> [Photo] {
    var fetchingPhotos = [Photo]()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")

    do {
      fetchingPhotos = try context.fetch(fetchRequest) as! [Photo]
    } catch {
      print("Error while fetching the photos")
    }
    return fetchingPhotos
  }
  
  func deletePhoto(indexPath: IndexPath) {
    let photos = fetchPhotos()
    context.delete(photos[indexPath.row])
    saveContext()
  }
  
  private func saveContext() {
    do {
      try context.save()
      print("Photo was updated")
    } catch {
      print(error.localizedDescription)
    }
  }
}
