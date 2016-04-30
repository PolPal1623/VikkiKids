//
//  ButtonsCollectionViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 18.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit

//===================================//
// MARK: - Протоколы
//===================================//

protocol ButtonsCollectionViewControllerDelegate: class {
    func FuncSelectorButtons(ButtonsType: String)
}

class ButtonsCollectionViewController: UICollectionViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для ButtonsCollectionViewController
    //===================================//
    
    weak var delegate: ButtonsCollectionViewControllerDelegate? // Переменная для отправки данных для подписавшихся под протокол
    var selectorButtons = 0 // Переменная для выбора параметра для ButtonsCollectionViewController
    let arrayButtons = [0, 1, 2, 3,4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления ButtonsCollectionViewController
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
        return arrayButtons.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ButtonsCollectionViewCell
        cell.imageCell.image = UIImage(named: "Buttons_\(arrayButtons[indexPath.row])")
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectorButtons = arrayButtons[indexPath.row]
        delegate?.FuncSelectorButtons(String(selectorButtons)) // Отправка данных о переменной selectorButtons в ViewController
        
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)        
    }
}

extension ButtonsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 3) - (spacing)
        let itemHeight = (view.bounds.size.width / 3) - (spacing)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
