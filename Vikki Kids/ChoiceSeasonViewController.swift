//
//  ChoiceSeasonViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 22.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import RealmSwift

class ChoiceSeasonViewController: UIViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для ColorCollectionViewController
    //===================================//
    
    var lastVersionKit: SaveListRealmForVC! // Переменная для сохранения последней сборки конструктора
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для смены сезона
    func choiceSeason(season: String) {
        let realm = try! Realm()
        // Проверка на наличие данных в памяти
        if let lastVersion = realm.objects(SaveListRealmForVC).last {
            let hoodForm = lastVersion.hoodForm // Форма капюшона
            let earsForm = lastVersion.earsForm // Форма ушей
            let mainColor = lastVersion.mainColor
            let color = "0" // Подкладка
            let buttonsColor = lastVersion.buttonsColor // Пуговицы
            let picture = lastVersion.picture // Принт
            
            lastVersionKit = SaveListRealmForVC() // Константа типа SaveListRealmForVC для записи в память
            lastVersionKit.id = 0
            lastVersionKit.season = season
            lastVersionKit.hoodForm = hoodForm
            lastVersionKit.earsForm = earsForm
            lastVersionKit.mainColor = mainColor
            lastVersionKit.color = color
            lastVersionKit.buttonsColor = buttonsColor
            lastVersionKit.picture = picture
            //------------------ Сохранение через Realm
            try! realm.write {
                realm.add(lastVersionKit, update: true)
            }
        }
    }
    
    //===================================//
    // MARK: - IBAction на нашей Scene ViewController
    //===================================//
    
    //-----------------------------------// Метод для выбора сезона
    @IBAction func summerButton(sender: AnyObject) {

        choiceSeason("Summer") // Метод для смены сезона
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)
    }
   
    //-----------------------------------// Метод для выбора сезона
    @IBAction func demiSeasonButton(sender: AnyObject) {

        choiceSeason("DemiSeason") // Метод для смены сезона
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)
    }
    
    //-----------------------------------// Метод для выбора сезона
    @IBAction func winterButton(sender: AnyObject) {
        
        choiceSeason("Winter") // Метод для смены сезона
        //----------------- Вернутся на главный экран
        navigationController?.popViewControllerAnimated(true)
    }
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления View Controller
    //===================================//

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
