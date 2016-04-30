//
//  ViewController.swift
//  Vikki Kids
//
//  Created by Polynin Pavel on 10.04.16.
//  Copyright © 2016 Polynin Pavel. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage
import Kanna

// Класс SaveListRealmForVC для объектов хранимых в памяти
class SaveListRealmForVC: Object {
    
    dynamic var season = "Summer" // Сезон
    dynamic var hoodForm = "Round" // Форма капюшона
    dynamic var earsForm = "None" // Форма ушей
    dynamic var mainColor = "0" // Основной цвет
    dynamic var color = "0" // Подкладка
    dynamic var buttonsColor = "0" // Пуговицы
    dynamic var picture = "0" // Принт
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// Класс SavePhoto для сохранения конвертов
class SavePhoto: Object {
    dynamic var photo: NSData = NSData()
    dynamic var name = -1
    dynamic var season = "Summer" // Сезон
    dynamic var hoodForm = "Round" // Форма капюшона
    dynamic var earsForm = "None" // Форма ушей
    dynamic var mainColor = "0" // Основной цвет
    dynamic var color = "0" // Подкладка
    dynamic var buttonsColor = "0" // Пуговицы
    dynamic var picture = "0" // Принт
}

class ViewController: UIViewController, MainColorCollectionViewControllerDelegate, ColorCollectionViewControllerDelegate, PrintCollectionViewControllerDelegate, ButtonsCollectionViewControllerDelegate {
    
    //===================================//
    // MARK: - Глобальные переменные для ViewController
    //===================================//
    var arrayURL = [(name: String, photoURLString: String)]() // Переменная для парсинга адресов изображения
    static let sharedManager = ViewController() // Переменная для передачи данных в другие классы
    var nameArray = 0 // Переменная для присвоения имен изображениям типа 0,1,2,3...
    
    var request: Request? // Переменная для запроса изображений из сети
    var imageMainColorURL: (name: String, photoURLString: String)! // Изображение из сети
    
    var menuVC: UIViewController! // Переменная для перехода на другой ViewController
    var lastVersionKit: SaveListRealmForVC! // Переменная для сохранения последней сборки конструктора
    var savePhoto: SavePhoto!
    
    var repiatAnimationMainMenuButton = true // Для выбора направления анимации при нажатии mainMenu
    var saveAnimationMainMenuButton = true // Переменная для первоначального положения mainMenu
    
    var counterEarsForm = 0 // Счетчик для выбора типа ушей
    var counterHood = 0 // Счетчик для выбора типа шапки
    
    var season = "Summer" // Сезон
    var hoodForm = "Round" // Форма капюшона
    var earsForm = "None" // Форма ушей
    var mainColor = "0" // Основной цвет
    var color = "0" // Подкладка
    var buttonsColor = "0" // Пуговицы
    var picture = "0" // Принт
    
    var earsImageName = "Summer_Ears_0_None" // Тип ушей и цвет подкладки
    var mainColorImageName = "Main_Color_0" // Основной цвет
    var fonImageName = "Fon_Round_Bear" // Тип ушей и тип капюшона
    var buttonImageName = "Buttons_0" // Цвет пуговиц
    var pictureName = "Print_0" // Тип принта
    
    //===================================//
    // MARK: - IBOutlet связывающие Scene и ViewController
    //===================================//
    
    @IBOutlet weak var earsImage: UIImageView!
    @IBOutlet weak var mainColorImage: UIImageView!
    @IBOutlet weak var mainColorImage2: UIImageView!
    @IBOutlet weak var fonImage: UIImageView!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var printImage: UIImageView!
    @IBOutlet weak var flash: UIImageView!
    @IBOutlet weak var seasonChoiceImage: UIImageView!
    
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var seasonView: UIView!
    @IBOutlet weak var hoodView: UIView!
    @IBOutlet weak var earsView: UIView!
    @IBOutlet weak var mainColorView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var printView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var mainMenu: UIButton!
    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var hoodButton: UIButton!
    @IBOutlet weak var earsButton: UIButton!
    @IBOutlet weak var mainColorButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var buttonsButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIBarButtonItem!
    
    //===================================//
    // MARK: - IBAction на нашей Scene ViewController
    //===================================//
    
    //-----------------------------------// Метод animationMainMenuButton для анимирования кнопок меню
    @IBAction func animationMainMenuButton(sender: AnyObject) {
        
        //----------------- Цикл выбора направления анамации развернуть/свернуть
        if repiatAnimationMainMenuButton {
            animationMainMenuUp()
        } else {
            animationMainMenuDown()
        }
        repiatAnimationMainMenuButton = !repiatAnimationMainMenuButton
    }
    
    //-----------------------------------// Метод для выбора типа ушей
    @IBAction func earsButtonPressed(sender: AnyObject) {
        
        counterEarsForm += 1
        
        switch counterEarsForm {
        case 0: earsForm = "None"
        case 1: earsForm = "Bear"
        case 2: earsForm = "Mikki"
        case 3: earsForm = "Cat"
        case 4: earsForm = "Owl"
        case 5: earsForm = "Rabbit"; counterEarsForm = -1
        default : earsForm = "None"
        }
        
        saveChangeKit() // Метод сохраняет все изменения в память
        
        viewWillAppear(false)
        
    }
    
    //-----------------------------------// Метод для выбора типа шапки
    @IBAction func hoodButtonPressed(sender: AnyObject) {
        
        counterHood += 1
        
        switch counterHood {
        case 0: hoodForm = "Round"
        case 1: hoodForm = "Sharp"
        case 2: hoodForm = "Zipper"; counterHood = -1
        default : hoodForm = "Round"
        }

        
        saveChangeKit() // Метод сохраняет все изменения в память
        
        viewWillAppear(false)
    }
    
    //-----------------------------------// Метод для выбора основной ткани
    @IBAction func mainColorButtonPressed(sender: AnyObject) {
        parsingMainColorURL()
        PhotosDataManager.sharedManager.testPhotos = arrayURL
        //print(arrayURL)
    }
    
    //-----------------------------------// Метод для выбора цвета подкладки
    @IBAction func colorButtonPressed(sender: AnyObject) {
        
        
    }
    
    //-----------------------------------// Метод для выбора типа принта
    @IBAction func printButtonPressed(sender: AnyObject) {
        
    }
    
    //-----------------------------------// Метод для выбора типа пуговиц
    @IBAction func buttonsButtonPressed(sender: AnyObject) {
        
    }
    
    //-----------------------------------// Метод для выбора основного меню
    @IBAction func mainMenuButtonPressed(sender: AnyObject) {
        
        //------------------ Показать меню поверх этого
        showMenuVC(menuVC)
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hidden = true
        
    }
    
    //-----------------------------------// Метод для создания скриншота
    @IBAction func cameraButtonPressed(sender: AnyObject) {
        
        //-----------------------------------//Действия перед снимком
        let heightAnimationsButtons = earsView.frame.size.height + earsView.frame.size.height // Расстояние на которое опускаются кнопки
        let navigationBar = self.navigationController?.navigationBar
        
        let timeAnimation = 0.5 // Время анимации
        
        //----------------- Анимация скрытия Buttons
        UIView.animateWithDuration(timeAnimation, delay: 0, options: .CurveEaseInOut, animations: {
            self.mainMenuView.center.x += heightAnimationsButtons
            self.seasonView.center.x +=  heightAnimationsButtons
            self.earsView.center.x += heightAnimationsButtons
            self.hoodView.center.x += heightAnimationsButtons
            self.mainColorView.center.x += heightAnimationsButtons
            self.colorView.center.x += heightAnimationsButtons
            self.printView.center.x += heightAnimationsButtons
            self.buttonsView.center.x += heightAnimationsButtons
            self.cameraView.center.y += heightAnimationsButtons
            navigationBar?.center.y -= heightAnimationsButtons
        }) { (finished) -> Void in
            if finished {
                //-----------------------------------//Вспышка
                UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: {
                    self.flash.backgroundColor = UIColor.whiteColor()
                    }, completion: nil)
                
                UIView.animateWithDuration(0.1, delay: 0.1, options: .CurveEaseOut, animations: {
                    self.flash.backgroundColor = UIColor.clearColor()
                    }, completion: nil)
            }
        }
        //-----------------------------------//Снимок
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //-----------------------------------//Сохранение снимка
        let imageNSDate = UIImagePNGRepresentation(image)
        let realm = try! Realm()
        savePhoto = SavePhoto()
        if let lastPhoto = realm.objects(SavePhoto).last {
        savePhoto.name = lastPhoto.name + 1
        } else {
        savePhoto.name = 0
        }
        savePhoto.photo = imageNSDate!
        savePhoto.hoodForm = hoodForm
        savePhoto.earsForm = earsForm
        savePhoto.mainColor = mainColor
        savePhoto.color = color
        savePhoto.buttonsColor = buttonsColor
        savePhoto.picture = picture
        savePhoto.season = season
        
        //------------------ Сохранение через Realm
        try! realm.write {
            realm.add(savePhoto)
        }
        
        //-----------------------------------//Действия после снимка
        //----------------- Анимация возврата Buttons
        UIView.animateWithDuration(timeAnimation, delay: 1, options: .CurveEaseInOut, animations: {
            self.mainMenuView.center.x -= heightAnimationsButtons
            self.seasonView.center.x -=  heightAnimationsButtons
            self.earsView.center.x -= heightAnimationsButtons
            self.hoodView.center.x -= heightAnimationsButtons
            self.mainColorView.center.x -= heightAnimationsButtons
            self.colorView.center.x -= heightAnimationsButtons
            self.printView.center.x -= heightAnimationsButtons
            self.buttonsView.center.x -= heightAnimationsButtons
            self.cameraView.center.y -= heightAnimationsButtons
            navigationBar?.center.y += heightAnimationsButtons
            }, completion: nil)
        
        alert("Ваш конверт сохранён", message: "Для заказа данного коверта перейдите в раздел Галерея и выберете его ")
    }
    
    //===================================//
    // MARK: - Системные методы
    //===================================//
    
    //===================================//
    // MARK: - Кастомные методы
    //===================================//
    
    //-----------------------------------// Метод для создания простого сообщения
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //------------------ AlertAction for AlertController
        let action = UIAlertAction(title: "Ok", style: .Cancel) { (action: UIAlertAction) -> Void in }
        alert.addAction(action) // AlertAction добавляем в AlertController
        self.presentViewController(alert, animated: true, completion: nil) // добавляем AlertController на View Controller
    }
    
        //-----------------------------------// Метод для создания словаря из ссылок на изображение ткани
    func parsingMainColorURL () -> [(name: String, photoURLString: String)] {
            let myURLAdress = "https://www.nps.gov/media/photo/gallery.htm?id=F274C1CA-155D-451F-67F12CC510281EFF" // Адрес для парсинга
            let myURL = NSURL(string: myURLAdress) // Создание URL ссылки
    
        //----------------- Запрос и вывод всех ссылок со словами large.jpg
            let URLTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!) {
                myData, response, error in
    
                guard error == nil else { return }
    
                let myHTMLString = String(data: myData!, encoding: NSUTF8StringEncoding)
                if let doc = Kanna.HTML(html: myHTMLString!, encoding: NSUTF8StringEncoding) {
                    // Search for nodes by XPath
                    for link in doc.xpath("//a | //link") {
                        if (link["href"]) != nil {
                        if link["href"]?.rangeOfString("large.jpg") != nil {
                            let name = String(self.nameArray)
                            self.nameArray += 1
                            let urlString = "https://www.nps.gov" + link["href"]!
                            let namePlusUrlString = (name: name, photoURLString: urlString)
                            self.arrayURL.append(namePlusUrlString)
                            }
                        }
                    }
                }
            }
        URLTask.resume()
        return arrayURL
        }
    
    //-----------------------------------// Метод запуска загрузки выбранного изображения
    func configure( ) {
        //------------------ Если фотопоток еще не загрузился то использовать блок под условием
        if PhotosDataManager.sharedManager.allPhotos().count == 1 {
         self.imageMainColorURL = PhotosDataManager.sharedManager.allPhotos()[0]
        } else {
        self.imageMainColorURL = PhotosDataManager.sharedManager.allPhotos()[Int(mainColor)!]
        }
        reset() // Сброс предыдущего запроса
        loadImage() // Загрузка изображения из кеша или если его нет загрузка из интернета
    }
    
    //-----------------------------------// Сброс предыдущего запроса
    func reset() {
        request?.cancel() // Отмена запроса
    }
    
    //-----------------------------------// Загрузка изображения из кеша или если его нет загрузка из интернета
    func loadImage() {
        if let image = PhotosDataManager.sharedManager.cachedImage(imageMainColorURL.photoURLString) {
            populate(image) // Присвоение полученного изображения
            return
        }
        downloadImage() // Загрузка изображения из интернета по запросу
    }
    
    //-----------------------------------// Загрузка изображения из интернета по запросу
    func downloadImage() {
        let urlString = imageMainColorURL.photoURLString
        request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
            self.populate(image)
        }
    }
    
    //-----------------------------------// Присвоение полученного изображения
    func populate(image: UIImage) {
        mainColorImage.image = image
        mainColorImage2.image = image
    }
    
    //-----------------------------------// Метод сохраняет все изменения в память
    func saveChangeKit() {
        
        lastVersionKit = SaveListRealmForVC() // Константа типа SaveListRealmForVC для записи в память
        lastVersionKit.id = 0
        lastVersionKit.hoodForm = hoodForm
        lastVersionKit.earsForm = earsForm
        lastVersionKit.mainColor = mainColor
        lastVersionKit.color = color
        lastVersionKit.buttonsColor = buttonsColor
        lastVersionKit.picture = picture
        lastVersionKit.season = season
        
        
        let realm = try! Realm()
        //------------------ Сохранение через Realm
        try! realm.write {
            realm.add(lastVersionKit, update: true)
        }
    }
    
    //-----------------------------------// Метод распределяет параметры для конверта по названиям изображений из памяти
    func nameImage() {
        
        lastVersionKit = SaveListRealmForVC() // Константа типа SaveListRealmForVC для записи в память
        let realm = try! Realm() // Инициализация realm
        
        // Проверка на наличие данных в памяти
        if let lastVersion = realm.objects(SaveListRealmForVC).last {
            hoodForm = lastVersion.hoodForm // Форма капюшона
            earsForm = lastVersion.earsForm // Форма ушей
            mainColor = lastVersion.mainColor
            color = lastVersion.color // Подкладка
            buttonsColor = lastVersion.buttonsColor // Пуговицы
            picture = lastVersion.picture // Принт
            season = lastVersion.season
        }
        
        //----------------- Сборка параметров в тип изображений
        if season == "DemiSeason" {
            earsImageName = "Winter_Ears_\(color)_\(earsForm)" // Тип ушей и цвет подкладки
        } else {
            earsImageName = "\(season)_Ears_\(color)_\(earsForm)" // Тип ушей и цвет подкладки
        }
        mainColorImageName = "Main_Color_\(mainColor)" // Основной цвет
        if earsForm == "Rabbit"  {
            fonImageName = "Fon_\(hoodForm)_Rabbit" // Тип ушей и тип капюшона
        } else {
            fonImageName = "Fon_\(hoodForm)_Bear" // Тип ушей и тип капюшона
        }
        buttonImageName = "Buttons_\(buttonsColor)" // Цвет пуговиц
        pictureName = "Print_\(picture)" // Тип принта
        
        //----------------- Итоговое присвоение изображений для получения конверта
        earsImage.image = UIImage(named: earsImageName)
        fonImage.image = UIImage(named: fonImageName)
        buttonImage.image = UIImage(named: buttonImageName)
        printImage.image = UIImage(named: pictureName)
        if let season = realm.objects(SaveListRealmForVC).last?.season {
         seasonChoiceImage.image = UIImage(named: "season_\(season)")
        }
        
    }
    
    //-----------------------------------// Метод убирает основное меню
    func animationMainMenuUp() {
        
        let heightAnimationsButtons = earsView.frame.size.height + earsView.frame.size.height // Расстояние на которое опускаются кнопки
        
        let timeAnimation = 1.0 // Время анимации
        let degree45 = -CGFloat(M_PI/4) // Константа для поворота MainMenuButton
        let usingSpringWithDamping: CGFloat = 0.5 // Сила колебания анимации в конце
        let initialSpringVelocity: CGFloat = 0.5 // Начальная скорость сила колебания
        
        //----------------- Анимация поворота MainMenuButton
        UIView.animateWithDuration(timeAnimation, delay: 0, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: .CurveEaseInOut, animations: {
            self.mainMenuView.transform = CGAffineTransformMakeRotation(degree45)
            }, completion: nil)
        
        //----------------- Анимация выезда Buttons
        UIView.animateWithDuration(timeAnimation/2, delay: 0, options: .CurveEaseInOut, animations: {
            self.earsView.center.x += heightAnimationsButtons
            self.seasonView.center.x +=  heightAnimationsButtons
            self.hoodView.center.x += heightAnimationsButtons
            self.mainColorView.center.x += heightAnimationsButtons
            self.colorView.center.x += heightAnimationsButtons
            self.printView.center.x += heightAnimationsButtons
            self.buttonsView.center.x += heightAnimationsButtons
            }, completion: nil)
    }
    
    //-----------------------------------// Метод показывает основное меню
    func animationMainMenuDown() {
        
        let heightAnimationsButtons = earsView.frame.size.height + earsView.frame.size.height // Расстояние на которое опускаются кнопки
        let timeAnimation = 1.0 // Время анимации
        let usingSpringWithDamping: CGFloat = 0.5 // Сила колебания анимации в конце
        let initialSpringVelocity: CGFloat = 0.5 // Начальная скорость силы колебания
        
        //----------------- Анимация
        UIView.animateWithDuration(timeAnimation, delay: 0, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.mainMenuView.transform = CGAffineTransformMakeRotation(0)
            self.seasonView.center.x -=  heightAnimationsButtons
            }, completion: nil)
        
        UIView.animateWithDuration(timeAnimation, delay: 0.1, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.earsView.center.x -= heightAnimationsButtons
            }, completion: nil)
        
        UIView.animateWithDuration(timeAnimation, delay: 0.2, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.hoodView.center.x -= heightAnimationsButtons
            }, completion: nil)
        
        UIView.animateWithDuration(timeAnimation, delay: 0.3, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.mainColorView.center.x -= heightAnimationsButtons
            }, completion: nil)
        
        UIView.animateWithDuration(timeAnimation, delay: 0.4, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.colorView.center.x -= heightAnimationsButtons
            }, completion: nil)
        
        UIView.animateWithDuration(timeAnimation, delay: 0.5, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.printView.center.x -= heightAnimationsButtons
            }, completion: nil)
        
        UIView.animateWithDuration(timeAnimation, delay: 0.6, usingSpringWithDamping: usingSpringWithDamping*0.7, initialSpringVelocity: initialSpringVelocity*0.7, options: .CurveEaseInOut, animations: {
            self.buttonsView.center.x -= heightAnimationsButtons
            }, completion: nil)
    }
    
    //-----------------------------------// Метод для изменения параметра mainColor из MainColorCollectionViewController
    func FuncSelectorMainColor(MainColorType: String) {
        mainColor = MainColorType
        saveChangeKit() // Метод сохраняет все изменения в память
        
    }
    
    //-----------------------------------// Метод для изменения параметра color из ColorCollectionViewController
    func FuncSelectorColor(ColorType: String) {
        color = ColorType
        saveChangeKit() // Метод сохраняет все изменения в память
    }
    
    //-----------------------------------// Метод для изменения параметра picture из PrintCollectionViewController
    func FuncSelectorPrint(PrintType: String) {
        picture = PrintType
        saveChangeKit() // Метод сохраняет все изменения в память
    }
    
    //-----------------------------------// Метод для изменения параметра buttonsColor из ButtonsCollectionViewController
    func FuncSelectorButtons(ButtonsType: String) {
        buttonsColor = ButtonsType
        saveChangeKit() // Метод сохраняет все изменения в память
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
        
        parsingMainColorURL()
       
        menuVC = storyboard?.instantiateViewControllerWithIdentifier("menuViewController") // Инициализация menuVC
    }
    
    //-----------------------------------// Метод viewWillAppear срабатывает при изменении интерфейса
    override func viewWillAppear(animated: Bool) {
        
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewWillAppear(animated)
        
        nameImage() // Метод распределяет параметры для конверта по названиям изображений
        
        configure()
        
        //-----------------------------------// Настройка navigationBar
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.hidden = false
        
        navigationBar?.barTintColor = UIColor(red: 48/255, green: 135/255, blue: 139/255, alpha: 1)
        
        navigationBar?.tintColor = UIColor.whiteColor()
        
        navigationBar?.topItem?.title = "Мой конверт"
        
        navigationBar?.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Thin", size: 34)! ]
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //------------------ Перенос всех свойств класса этому экземпляру
        super.viewDidAppear(animated)
        
    }
    
    //===================================//
    // MARK: - Navigation
    //===================================//
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //-----------------------------------//  Условие для создания связи с MainColorCollectionViewController
        if segue.identifier == "MainColorSegue" {
            
            let destinationVC = segue.destinationViewController as! MainColorCollectionViewController
            destinationVC.delegate = self
        }
        
        if segue.identifier == "ColorSegue" {
            
            let destinationVC = segue.destinationViewController as! ColorCollectionViewController
            destinationVC.delegate = self
        }
        
        if segue.identifier == "PrintSegue" {
            
            let destinationVC = segue.destinationViewController as! PrintCollectionViewController
            destinationVC.delegate = self
        }
        
        if segue.identifier == "ButtonsSegue" {
            
            let destinationVC = segue.destinationViewController as! ButtonsCollectionViewController
            destinationVC.delegate = self            
        }        
    }
}









