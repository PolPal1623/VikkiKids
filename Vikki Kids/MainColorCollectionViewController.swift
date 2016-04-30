//
//  MainColorCollectionViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 18.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kanna
import RealmSwift

// Класс SaveJPG для объектов хранимых в памяти
class SaveJPG: Object {
    
    dynamic var lastJPG = " " //Последний выбранный адрес
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


//===================================//
// MARK: - Протоколы
//===================================//

protocol MainColorCollectionViewControllerDelegate: class {    
    func FuncSelectorMainColor( MainColorType: String)
}

class MainColorCollectionViewController: UICollectionViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для MainColorCollectionViewController
    //===================================//
    
    var lastJPG: SaveJPG! // Переменная для сохранения последнего JPG
    
    weak var delegate: MainColorCollectionViewControllerDelegate? // Переменная для отправки данных для подписавшихся под протокол
    var selectorMainColor = "0" // Переменная для выбора параметра для MainColorCollectionViewController
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления MainColorCollectionViewController
    //===================================//
    
    //-----------------------------------// Метод viewDidLoad срабатывает при загрузке View Scene
    override func viewDidLoad() {
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewDidLoad()
    }
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для получения изображения для конкретной ячейки
    func glacierScenicAtIndex(indexPath: NSIndexPath) -> (name: String, photoURLString: String) {
        let photos = PhotosDataManager.sharedManager.allPhotos()
        
        return photos[indexPath.row]
    }
    
    //===================================//
    // MARK: - Методы для работы и настройки CollectionViewDataSource
    //===================================//
    
    //-----------------------------------// Метод возвращает кол-во секций CollectionView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //-----------------------------------// Метод возвращает кол-во ячеек в секции CollectionView
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosDataManager.sharedManager.allPhotos().count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MainColorCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        selectorMainColor = PhotosDataManager.sharedManager.allPhotos()[indexPath.row].name
        delegate?.FuncSelectorMainColor(selectorMainColor) // Отправка данных о переменной selectorMainColor в ViewController
        
        //запись в память последнего адреса JPG
        let realm = try! Realm()
        lastJPG = SaveJPG()  // Константа типа SaveJPG для записи в память
        lastJPG.id = 0
        lastJPG.lastJPG = PhotosDataManager.sharedManager.allPhotos()[indexPath.row].photoURLString
        //------------------ Сохранение через Realm
        try! realm.write {
            realm.add(lastJPG, update: true)
        }
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)
    }    
}

//MARK: - CollectionView Flow Layout
extension MainColorCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 3) - (spacing)
        let itemHeight = (view.bounds.size.width / 3) - (spacing)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
