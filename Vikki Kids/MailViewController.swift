//
//  MailViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 15.05.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {

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
        showMenuVC(menuVC) // Метод для вызова перехода на другой экран поверх этого
    }
    
    //-----------------------------------// Метод для отправки письма VikkiKids
    @IBAction func buttonVikkiKidsPressed(sender: AnyObject) {
        
    }

    //-----------------------------------// Метод для отправки письма Разработчику
    @IBAction func buttonDeveloperPressed(sender: AnyObject) {
        
        let mailComposeVC = self.configuredMailComposeViewController("Polynin1623@gmail.com")
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для отправки письма заказа
    func configuredMailComposeViewController(mail: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([mail])
        mailComposerVC.setSubject("Вопрос")
        
        return mailComposerVC
    }
    
    //-----------------------------------// Метод для обработки ошибки отправки письма
    func showSendMailErrorAlert( ) {
        let alert = UIAlertController(title: "Письмо не отправлено", message: "Проверьте свое соединение с интернетом или настроики работы почты на вашем устройстве", preferredStyle: .Alert)
        //------------------ AlertAction for AlertController
        let action = UIAlertAction(title: "Ok", style: .Cancel) { (action: UIAlertAction) -> Void in }
        alert.addAction(action) // AlertAction добавляем в AlertController
        self.presentViewController(alert, animated: true, completion: nil) // добавляем AlertController на View Controller
    }
    
    //-----------------------------------// Метод для обработки выбора действия при отправке письма
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            alert("Отменено", message: "Не ждите звонка")
        case MFMailComposeResultSent.rawValue:
            alert("Отправлено", message: "Ждите звонка")
        default:
            break
        }
        
    }
    
    //-----------------------------------// Метод для создания простого сообщения
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //------------------ AlertAction for AlertController
        let action = UIAlertAction(title: "Ok", style: .Cancel) { (action: UIAlertAction) -> Void in }
        alert.addAction(action) // AlertAction добавляем в AlertController
        self.presentViewController(alert, animated: true, completion: nil) // добавляем AlertController на View Controller
    }
    
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
