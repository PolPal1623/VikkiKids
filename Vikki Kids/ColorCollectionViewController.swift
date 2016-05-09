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
    var season = " "
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
        //------------------ Условие выбора сезона
        if season == " " {
            alertForSeason() // Метод для создания сообщения при первом включении приложения и не выборе сезона
        }
    }
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для создания сообщения при первом включении приложения и не выборе сезона
    func alertForSeason() {
        let alert = UIAlertController(title: "Предупреждение", message: "Для начала создания своего конверта нужно определится с сезоном.", preferredStyle: .Alert)
        //------------------ AlertAction for AlertController
        let actionOk = UIAlertAction(title: "Ok", style: .Cancel) { (action: UIAlertAction) -> Void in
        self.navigationController?.popViewControllerAnimated(true) // Возвращение на предыдущий экран
        }
        alert.addAction(actionOk) // AlertAction добавляем в AlertController
        self.presentViewController(alert, animated: true, completion: nil) // добавляем AlertController на View Controller
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
   
        if season == "Summer" {
             return arrayColorSummer.count
        } else if season == "Winter"{
            return arrayColorWinter.count
        } else if season == "DemiSeason"{
            return arrayColorWinter.count
        } else {
            return 0
        }
    }
    
    //-----------------------------------// Метод для создания ячеек
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
    
    //-----------------------------------// Метод срабатывает при выборе ячейки
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