//
//  SavedCollectionViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 22.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class SavedCollectionViewController: UICollectionViewController, MFMailComposeViewControllerDelegate {
    
    //===================================//
    // MARK: - Глобальные переменные для ColorCollectionViewController
    //===================================//
    
    var menuVC: UIViewController!
    var countArray: Results<(SavePhoto)>!
    
    //===================================//
    // MARK: - IBAction на нашей Scene ViewController
    //===================================//
    
    @IBAction func closeViewButtonPressed(sender: AnyObject) {
        showMenuVC(menuVC)        
    }
    //===================================//
    // MARK: - Методы загружаемые перед или после обновления ColorCollectionViewController
    //===================================//
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        menuVC = storyboard?.instantiateViewControllerWithIdentifier("menuViewController")  // Инициализация menuVC
    }
    
    //-----------------------------------// Метод viewWillAppear срабатывает при изменении интерфейса
    override func viewWillAppear(animated: Bool) {
        
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewWillAppear(animated)
        
        //-----------------------------------// Настройка navigationBar
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.hidden = false
        
        navigationBar?.barTintColor = UIColor(red: 48/255, green: 135/255, blue: 139/255, alpha: 1)
        
        navigationBar?.tintColor = UIColor.whiteColor()
        
        navigationBar?.topItem?.title = "Галерея"
        
        navigationBar?.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Thin", size: 34)! ]
    }

    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для отправки письма заказа
    func configuredMailComposeViewController(color: String, season: String, Data: NSData) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["polynin1623@gmail.com"])
        mailComposerVC.setSubject("Заказ")
        mailComposerVC.setMessageBody("color_\(color), season_\(season)", isHTML: false)
        mailComposerVC.addAttachmentData(Data, mimeType: "image/jped", fileName: "image")
        
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
    
    //-----------------------------------// Метод для перезаписи списка и перезагрузки collectionView
    func updateView() {
        
        countArray = try! Realm().objects(SavePhoto)
        collectionView?.reloadData()
        
    }
    
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

        countArray = try! Realm().objects(SavePhoto)
        if let count = countArray {
        return count.count
        }
            return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! SavedCollectionViewCell
       
        let realm = try! Realm()
        let photoArray = realm.objects(SavePhoto).sorted("name")
        
        cell.imageCell.image = UIImage(data: photoArray[indexPath.row].photo)
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
 
        let alert = UIAlertController(title: "Действия", message: "Выберете, что сделать с выбранным конвертом", preferredStyle: .Alert)
        
        //------------------ AlertAction for AlertController
        let cancelAction = UIAlertAction(title: "Отмена", style: .Cancel) { (action: UIAlertAction) -> Void in }
        //------------------ AlertAction for AlertController
        let sendAction = UIAlertAction(title: "Заказать", style: .Default) { (action: UIAlertAction) -> Void in
            
            let realm = try! Realm()
            let photoArray = realm.objects(SavePhoto)[indexPath.row]
            let sendText = photoArray.color
            let sendPhoto = photoArray.photo
            let sendSeason = photoArray.season
            
            let mailComposeVC = self.configuredMailComposeViewController(sendText,season: sendSeason, Data: sendPhoto)
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeVC, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            
        }
        //------------------ AlertAction for AlertController
        let deleteAction = UIAlertAction(title: "Удалить", style: .Default) { (action: UIAlertAction) -> Void in
        
            let realm = try! Realm()
            let photoArray = realm.objects(SavePhoto)[indexPath.row]
            //------------------ Удаление через Realm
            try! realm.write { realm.delete(photoArray) }
            
            self.updateView() // Метод для перезаписи списка и перезагрузки collectionView
        }
        
        alert.addAction(sendAction) // AlertAction добавляем в AlertController
        alert.addAction(deleteAction) // AlertAction добавляем в AlertController
        alert.addAction(cancelAction) // AlertAction добавляем в AlertController
        
        self.presentViewController(alert, animated: true, completion: nil) // добавляем AlertController на View Controller
        
    }
}

//MARK: - CollectionView Flow Layout
extension SavedCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 3) - (spacing)
        let itemHeight = (view.bounds.size.height / 3) - (spacing)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
