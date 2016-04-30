//
//  MainColorCollectionViewCell.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 18.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import Alamofire

class MainColorCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageCell: UIImageView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var request: Request? // Переменная для запроса изображений из сети
    var glacierScenic: (name: String, photoURLString: String)! // Изображение из сети
    
    //-----------------------------------// Метод запуска загрузки выбранного изображения
    func configure(glacierScenic: (name: String, photoURLString: String)) {
        self.glacierScenic = glacierScenic
        reset() // Сброс предыдущего запроса
        loadImage() // Загрузка изображения из кеша или если его нет загрузка из интернета
    }
    
    //-----------------------------------// Сброс предыдущего запроса
    func reset() {
        imageCell.image = nil
        request?.cancel()
    }
    
    //-----------------------------------// Загрузка изображения из кеша или если его нет загрузка из интернета
    func loadImage() {
        if let image = PhotosDataManager.sharedManager.cachedImage(glacierScenic.photoURLString) {
            populateCell(image)
            return
        }
        downloadImage() // Загрузка изображения из интернета по запросу
    }
    
    //-----------------------------------// Загрузка изображения из интернета по запросу
    func downloadImage() {
        loadingIndicator.startAnimating()
        let urlString = glacierScenic.photoURLString
        request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
            self.populateCell(image) // Присвоение полученного изображения
        }
    }
    
    //-----------------------------------// Присвоение полученного изображения
    func populateCell(image: UIImage) {
        loadingIndicator.stopAnimating()
        imageCell.image = image
    }    
}
