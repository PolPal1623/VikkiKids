//
//  AppTextViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 20.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit

class AppTextViewController: UIViewController {
    
    //===================================//
    // MARK: - Глобальные переменные для ViewController
    //===================================//
    
    var menuVC: UIViewController!
    
    //===================================//
    // MARK: - IBOutlet связывающие Scene и ViewController
    //===================================//
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //===================================//
    // MARK: - IBAction на нашей Scene ViewController
    //===================================//
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        showMenuVC(menuVC)
    }
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для вызова перехода на другой экран поверх этого
    func showMenuVC (VC: UIViewController) {
        
        addChildViewController(VC)
        view.addSubview(VC.view)
        VC.view.frame = view.bounds
    }
    
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления View Controller
    //===================================//
    
    //-----------------------------------// Метод viewDidLoad срабатывает при загрузке View Scene
    override func viewDidLoad() {
        
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewDidLoad()
        
        menuVC = storyboard?.instantiateViewControllerWithIdentifier("menuViewController")  // Инициализация menuVC
        
        //-----------------------------------// Настройка navigationBar
        navigationBar?.barTintColor = UIColor(red: 48/255, green: 135/255, blue: 139/255, alpha: 1)
        navigationBar?.tintColor = UIColor.whiteColor()
        navigationBar?.topItem?.title = " "
        navigationBar?.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Thin", size: 34)! ]
    }    
}
