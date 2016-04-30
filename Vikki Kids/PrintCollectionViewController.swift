//
//  PrintCollectionViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 18.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit

//===================================//
// MARK: - Протоколы
//===================================//

protocol PrintCollectionViewControllerDelegate: class {
    func FuncSelectorPrint( PrintType: String)
}

class PrintCollectionViewController: UICollectionViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для PrintCollectionViewController
    //===================================//
    
    weak var delegate: PrintCollectionViewControllerDelegate? // Переменная для отправки данных для подписавшихся под протокол
    var selectorPrint = "0" // Переменная для выбора параметра для PrintCollectionViewController
    let arrayPrint = [0, 1, 2]
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления ColorCollectionViewController
    //===================================//
    
    //-----------------------------------// Метод viewDidLoad срабатывает при загрузке View Scene
    override func viewDidLoad() {
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewDidLoad()
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
        return arrayPrint.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PrintCollectionViewCell        
        cell.imageCell.image = UIImage(named: "Print_\(arrayPrint[indexPath.row])")
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectorPrint = String(arrayPrint[indexPath.row])
        delegate?.FuncSelectorPrint(selectorPrint) // Отправка данных о переменной selectorPrint в ViewController
        
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)
    }
}

extension PrintCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 3) - (spacing)
        let itemHeight = (view.bounds.size.width / 3) - (spacing)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
