//
//  File.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 23.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift

class PhotosDataManager {
    
    //===================================//
    // MARK: - Глобальные переменные для MainColorCollectionViewController
    //===================================//
    
    static let sharedManager = PhotosDataManager() // Переменная для передачи данных в другие классы
    private var photos = [(name: "0", photoURLString: "https://static.wixstatic.com/media/025640_6d801ca00cbb4399b8f89ef3334ce2d8.jpg/v1/fill/w_600,h_600,al_c,q_80,usm_0.66_1.00_0.01/025640_6d801ca00cbb4399b8f89ef3334ce2d8.jpg")] // Запасной блок для старта приложения или отсутствия интернета
    var URLPhotos = ViewController.sharedManager.arrayURL
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    func startPhotosArray(count: Int, photoURLString: String) -> [(name: String, photoURLString: String)] {
        //print(a)
        var array = [(name: String, photoURLString: String)]()
        for index in 0...count {
            array.append((name: String(index), photoURLString: photoURLString))
        }
        return array
    }
    
    // Параметры для кэширования
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )

    //MARK: - Read Data
    
    //-----------------------------------// Метод для передачи адресов и имен изображений в другие классы
    func allPhotos() -> [(name: String, photoURLString: String)] {
        if URLPhotos.count != 0 {
            return URLPhotos
        } else {
            let realm = try! Realm()
            if let URLString = realm.objects(SaveJPG).last?.lastJPG {
                photos[0].photoURLString = URLString
            }
        return photos
        }
    }
    
    //MARK: - Image Downloading
    func getNetworkImage(urlString: String, completion: (UIImage -> Void)) -> (Request) {
        return Alamofire.request(.GET, urlString).responseImage { (response) -> Void in
            guard let image = response.result.value else { return }
            completion(image)
            self.cacheImage(image, urlString: urlString)
        }
    }
    
    //MARK: = Image Caching
    func cacheImage(image: Image, urlString: String) {
        photoCache.addImage(image, withIdentifier: urlString)
    }
    
    func cachedImage(urlString: String) -> Image? {
        return photoCache.imageWithIdentifier(urlString)
    }
}
