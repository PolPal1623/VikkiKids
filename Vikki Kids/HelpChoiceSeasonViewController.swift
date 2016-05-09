//
//  HelpChoiceSeasonViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 22.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit

class HelpChoiceSeasonViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //===================================//
    // MARK: - Глобальные переменные для ColorCollectionViewController
    //===================================//
    
    var arrayWeek = [String]() // Массив для недель в году для PickerView
    var numberWeek: Int! // Выбранная неделя
    var weekToday: Int! // неделя сегодня
    var weekBabyBorn: Int! // неделя рождения ребенка
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    
    //===================================//
    // MARK: - IBOutlet связывающие Scene и ViewController
    //===================================//
    
    @IBOutlet weak var PickerViewWeek: UIPickerView!
    @IBOutlet weak var labelForSeason: UILabel!
    
    //===================================//
    // MARK: - IBAction на нашей Scene ViewController
    //===================================//
    
     //-----------------------------------// Метод для выбора сезона
    @IBAction func buttonPressed(sender: AnyObject) {
        let week = calendar.component(.WeekOfYear, fromDate: date)
        weekToday = week
        weekBabyBorn = (40 - numberWeek) + weekToday
        if weekBabyBorn > 52 {
            weekBabyBorn = weekBabyBorn - 52
        }
        switch (weekBabyBorn) {
        case 0...10:
            labelForSeason.text = "Вам подойдет ЗИМНИЙ вариант"
        case 11...20:
            labelForSeason.text = "Вам подойдет ВЕСЕННИЙ вариант"
        case 21...30:
            labelForSeason.text = "Вам подойдет ЛЕТНИЙ вариант"
        case 31...40:
            labelForSeason.text = "Вам подойдет ОСЕННИЙ вариант"
        case 41...52:
            labelForSeason.text = "Вам подойдет ЗИМНИЙ вариант"
        default:
            break
        }
    }
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления View Controller
    //===================================//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerViewWeek.delegate = self // Подпись под протокол
        PickerViewWeek.dataSource = self // Подпись под протокол
        numberWeek = 0 // Неделя по умолчанию
        createArray() // Метод для создания массива от 1 до 40
        
    }
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для создания массива от 1 до 40
    func createArray() {
        for index in 1...40 {
            arrayWeek.append("\(index) Неделя")
        }
    }
    
    //===================================//
    // MARK: - Настройка PickerView
    //===================================//
    
    //-----------------------------------// Метод для выбора кол-ва PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
     return 1
    }

    //-----------------------------------// Метод для выбора числа компонентов в PickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     return arrayWeek.count
    }
    
    //-----------------------------------// Метод для наполнения PickerView
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayWeek[row]
    }
    
    //-----------------------------------// Метод для действий при выборе ячейки в PickerView
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberWeek = row + 1
    }
    
    //------------------ Внешний вид PickerView
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        let titleData = arrayWeek[row]
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Thin", size: 38.0)!,NSForegroundColorAttributeName:UIColor.whiteColor() ])
        
        pickerLabel.attributedText = myTitle
        
        pickerLabel.textAlignment = .Center
        
        return pickerLabel
    }
    
}
