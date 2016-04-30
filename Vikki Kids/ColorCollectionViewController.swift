//
//  ColorCollectionViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 18.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import RealmSwift

//===================================//
// MARK: - Протоколы
//===================================//

protocol ColorCollectionViewControllerDelegate: class {    
    func FuncSelectorColor( ColorType: String)
}

class ColorCollectionViewController: UICollectionViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для ColorCollectionViewController
    //===================================//
    
    weak var delegate: ColorCollectionViewControllerDelegate? // Переменная для отправки данных для подписавшихся под протокол
    var selectorColor = 0 // Переменная для выбора параметра для ColorCollectionViewController
    var season = "Summer"
    let arrayColorSummer = [0, 1, 2, 3,4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    let arrayColorWinter = [0, 1, 2, 3,4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления ColorCollectionViewController
    //===================================//
    
    //-----------------------------------// Метод viewDidLoad срабатывает при загрузке View Scene
    override func viewDidLoad() {        
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewDidLoad()
        
        //------------------ Выбор подкладки по сезону
        let realm = try! Realm()
        if let season = realm.objects(SaveListRealmForVC).last?.season {
         self.season = season   
        }
    }
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //===================================//
    // MARK: - Методы для работы и настройки CollectionViewDataSource
    //===================================//
    
    //-----------------------------------// Метод возвращает кол-во секций CollectionView
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //-----------------------------------// Метод возвращает кол-во ячеек в секции CollectionView
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if season == "Summer" {
             return arrayColorSummer.count
        } else {
            return arrayColorWinter.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ColorCollectionViewCell
        //------------------ Выбор в зависимомти от сезона
        if season == "Summer" {
            cell.imageCell.image = UIImage(named: "Summer_\(arrayColorSummer[indexPath.row])")
        } else {
            cell.imageCell.image = UIImage(named: "Winter_\(arrayColorWinter[indexPath.row])")
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //------------------ Выбор в зависимомти от сезона
        if season == "Summer" {
            selectorColor = arrayColorSummer[indexPath.row]
        } else {
            selectorColor = arrayColorWinter[indexPath.row]
        }
        
        delegate?.FuncSelectorColor(String(selectorColor)) // Отправка данных о переменной selectorColor в ViewController
        
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)
        
    }    
}

//MARK: - CollectionView Flow Layout
extension ColorCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 3) - (spacing)
        let itemHeight = (view.bounds.size.width / 3) - (spacing)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}