//
//  MenuViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 19.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для ViewController
    //===================================//
    
    //===================================//
    // MARK: - IBOutlet связывающие Scene и ViewController
    //===================================//
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageFon: UIImageView!
    
    //===================================//
    // MARK: - IBAction на нашей Scene ViewController
    //===================================//
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления View Controller
    //===================================//
    
    //-----------------------------------// Метод viewDidLoad срабатывает при загрузке View Scene
    override func viewDidLoad() {
        
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewDidLoad()
        
        //-----------------------------------// Настройка navigationBar
        navigationBar?.barTintColor = UIColor(red: 48/255, green: 135/255, blue: 139/255, alpha: 1)
        navigationBar?.tintColor = UIColor.whiteColor()
        navigationBar?.topItem?.title = "Основное меню"
        navigationBar?.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Thin", size: 34)! ]
        
        //-----------------------------------// Настройк blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageFon.bounds
        imageFon.addSubview(blurEffectView)        
    }    
}
