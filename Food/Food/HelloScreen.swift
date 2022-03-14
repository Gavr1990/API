//
//  ViewController.swift
//  Food
//
//  Created by Андрей Гаврилов on 11.03.2022.
//

import UIKit
import SwiftUI

struct Food: Decodable {
    var image: String!

    init(json: [String: Any]) {
        image = json["image"] as? String ?? ""
    }
    
    init(jsonString: String) {
        image = jsonString
    }
}



class HelloScreen: UIViewController {

    private var images: [UIImage?]!
    private var firstBackgroundImage: UIImageView!
    private var secondBackgroundImage: UIImageView!
    private var secondView: UIView!
    private var mainButton: UIButton!
    private var mainLabel: UILabel!
    
    private var menuImage: UIImageView!
    private var buyImage: UIImageView!
    private var foodLabel: UILabel!
    private var deliveryLabel: UILabel!

//    private var myTimer: Timer!
    
    private var firstImage: UIImage!
    private var secondImage: UIImage!
    private var thirdImage: UIImage!
    private var fourthImage: UIImage!
    
    private var foods = [Food]()
    private var links = [String]()

    private var gallaryCollectionView = GallaryCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let response = response {
//                print(response)
//            }
//            guard let data = data else { return }
//            print(data)
////            let dataAsString = String(data: data, encoding: .utf8)
//            do {
//                guard let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any] else { return }
//                print(json)
//                self.foods = Food(json: json)
//            } catch {
//                print(error)
//            }
//        }.resume()
        
        setupView()
        downloadUrls() { json in
            print(json)
            for link in json {
                self.links.append(link as! String)
                self.foods.append(Food(jsonString: link as! String))
            }
            self.gallaryCollectionView.set(cells: self.foods)
        }
    }

    private func setupView() {
        
        images = [UIImage]()
        images.append(UIImage(named: "IMG_8864.jpg") ?? nil)

        /*
         I commented out the code here because the plan was to make a smooth moving background and changing photos there
         */
//        images.append(UIImage(named: "IMG_8863.jpg") ?? nil)
//        images.append(UIImage(named: "IMG_8865.jpg") ?? nil)
//        images.append(UIImage(named: "IMG_8866.jpg") ?? nil)
        
//        timer = Timer.scheduledTimer(timeInterval: 16.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)

//        secondBackgroundImage = UIImageView(image: images[1])
//        secondBackgroundImage.alpha = 0
//        secondBackgroundImage.frame = CGRect(x: -800, y: -800, width: images[1]!.size.width, height: images[1]!.size.height)
//        view.addSubview(secondBackgroundImage)

        firstBackgroundImage = UIImageView(image: images[0])
        firstBackgroundImage.alpha = 1
        firstBackgroundImage.frame = CGRect(x: -400, y: -300, width: images[0]!.size.width, height: images[0]!.size.height)
        view.addSubview(firstBackgroundImage)

                
        secondView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        secondView.backgroundColor = .black
        secondView.isOpaque = false
            secondView.alpha = 0
        view.addSubview(secondView)
        
        mainLabel = UILabel()
        mainLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        mainLabel.text = "Want to see what students dream about?"
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        secondView.addSubview(mainLabel)

        mainButton = UIButton()
        mainButton.setTitle("Let's figure out", for: .normal)
        mainButton.alpha = 0
        
        /*
         I'm not a designer and so I couldn't decide on the best way to make this button look. With or without a small border
         */
        
//        mainButton.layer.borderWidth = 1
//        mainButton.layer.borderColor = .init(red: 200, green: 200, blue: 200, alpha: 1)
        
        mainButton.layer.cornerRadius = 5
        mainButton.setTitleColor(.gray, for: .highlighted)
        mainButton.setTitleColor(.white, for: .normal)
        mainButton.backgroundColor = .darkGray
        mainButton.addTarget(self, action: #selector(mainButtonAction), for: .touchUpInside)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.clipsToBounds = true
        secondView.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: self.view.topAnchor),
            secondView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            secondView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            mainButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            mainButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 50),
            mainButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width/3.5),
            mainButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIScreen.main.bounds.width/3.5),
            
        ])
        UIView.animate(withDuration: 3, delay: 1, options: .curveEaseInOut) {
            self.secondView.alpha = 0.75
        }
        completion: { _ in
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                self.mainButton.alpha = 1
            }}
        
        gallaryCollectionView.alpha = 0
        
        foodLabel = UILabel()
        foodLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        foodLabel.text = "Homefood"
        foodLabel.alpha = 0
        foodLabel.textAlignment = .left
        foodLabel.textColor = .black
        foodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        deliveryLabel = UILabel()
        deliveryLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        deliveryLabel.text = "Delivery"
        deliveryLabel.alpha = 0
        deliveryLabel.textAlignment = .left
        deliveryLabel.textColor = .black
        deliveryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buyImage = UIImageView(image: .init(named: "basket.png"))
        buyImage.alpha = 0
        buyImage.translatesAutoresizingMaskIntoConstraints = false
        
        menuImage = UIImageView(image: .init(named: "menu.png"))
        menuImage.alpha = 0
        menuImage.translatesAutoresizingMaskIntoConstraints = false
    }
        
    override func viewDidLayoutSubviews() {
        /*
         Here were supposed to be the constraints, but because I decided to do everything in one window, they were moved
         */
    }
    
    @objc func mainButtonAction() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            self.mainLabel.center.x -= 50
            self.mainButton.center.x -= 50
            self.mainLabel.alpha = 0
            self.mainButton.alpha = 0
        }
        completion: { _ in
            NSLayoutConstraint.deactivate([
                self.secondView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.secondView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.secondView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.secondView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                
                self.mainLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.mainLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

                self.mainButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.mainButton.topAnchor.constraint(equalTo: self.mainLabel.bottomAnchor, constant: 50),
                self.mainButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width/3.5),
                self.mainButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIScreen.main.bounds.width/3.5),
                
            ])
            self.mainLabel = nil
            self.mainButton = nil
            self.firstBackgroundImage = nil
            self.images = nil
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseInOut]) {
                self.secondView.backgroundColor = .init(red: 140, green: 140, blue: 140, alpha: 1)
                self.secondView.alpha = 1
            } completion: { _ in
                self.secondView.addSubview(self.menuImage)
                self.secondView.addSubview(self.foodLabel)
                self.secondView.addSubview(self.deliveryLabel)
                self.secondView.addSubview(self.buyImage)
                self.secondView.addSubview(self.gallaryCollectionView)
                
                self.gallaryCollectionView.alpha = 1
                self.deliveryLabel.alpha = 1
                self.foodLabel.alpha = 1
                self.menuImage.alpha = 1
                self.buyImage.alpha = 1
                
                self.gallaryCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.gallaryCollectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                self.gallaryCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                self.gallaryCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                self.gallaryCollectionView.heightAnchor.constraint(equalToConstant: 350).isActive = true
                
                self.menuImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
                self.menuImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35).isActive = true
                self.menuImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
                self.menuImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
                    
                self.buyImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive = true
                self.buyImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35).isActive = true
                self.buyImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
                self.buyImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
                   
                self.foodLabel.topAnchor.constraint(equalTo: self.buyImage.bottomAnchor, constant: 10).isActive = true
                self.foodLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                
                self.deliveryLabel.topAnchor.constraint(equalTo: self.foodLabel.bottomAnchor, constant: 10).isActive = true
                self.deliveryLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                    
            }
        }
    }
    
    func downloadUrls(completion: @escaping ([Any]) -> Void) {
        guard let url = URL(string: "https://foodish-api.herokuapp.com/api/") else { return }
        let urls: [URL] = .init(repeating: url, count: 16)
        
        var subjectCollection: [Any] = []
        let urlDownloadQueue = DispatchQueue(label: "com.urlDownloader.urlqueue")
        let urlDownloadGroup = DispatchGroup()
        
        urls.forEach { (url) in
            urlDownloadGroup.enter()
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let response = response {
                    print(response)
                }
                guard let data = data else { return }
//                print(data)
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: String] else {
                            urlDownloadQueue.async {
                                urlDownloadGroup.leave()
                            }
                            return
                    }
//                    print(json)
                    urlDownloadQueue.async {
                        subjectCollection.append(json["image"]!)
                        urlDownloadGroup.leave()
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }

        urlDownloadGroup.notify(queue: DispatchQueue.global()) {
            completion(subjectCollection)
        }
    }
//
    /*
     This code is my attempt to animate the background image
     */
    
//    @objc func refresh() {
//        firstBackgroundImage = UIImageView(image: images[0])
//        secondBackgroundImage = UIImageView(image: images[1])
//        firstBackgroundImage.frame = CGRect(x: -400, y: -400, width: images[0]!.size.width, height: images[0]!.size.height)
//        secondBackgroundImage.frame = CGRect(x: -800, y: -800, width: images[1]!.size.width, height: images[1]!.size.height)
//        UIView.animate(withDuration: 8, delay: 0, options: [.curveEaseInOut]) {
//            self.firstBackgroundImage.center.x -= 100
//            self.firstBackgroundImage.center.y -= 100
//            self.secondBackgroundImage.center.x += 100
//            self.secondBackgroundImage.center.y += 100
//        }
//        UIView.animate(withDuration: 1, delay: 4, options: [.curveEaseInOut]) {
//            self.firstBackgroundImage.alpha = 0
//            self.secondBackgroundImage.alpha = 1
//        } completion: { _ in
//            self.firstBackgroundImage = UIImageView(image: self.images[2])
//            self.firstBackgroundImage.frame = CGRect(x: -400, y: -400, width: self.images[2]!.size.width, height: self.images[2]!.size.height)
//        }
//        UIView.animate(withDuration: 1, delay: 4, options: [.curveEaseInOut]) {
//            self.firstBackgroundImage.alpha = 1
//            self.secondBackgroundImage.alpha = 0
//        } completion: { _ in
//            self.secondBackgroundImage = UIImageView(image: self.images[3])
//            self.secondBackgroundImage.frame = CGRect(x: -800, y: -800, width: self.images[3]!.size.width, height: self.images[3]!.size.height)
//            }
//        UIView.animate(withDuration: 1, delay: 4, options: [.curveEaseInOut]) {
//            self.firstBackgroundImage.alpha = 0
//            self.secondBackgroundImage.alpha = 1
//        } completion: { _ in
//            self.firstBackgroundImage = UIImageView(image: self.images[0])
//            self.firstBackgroundImage.frame = CGRect(x: -400, y: -400, width: self.images[0]!.size.width, height: self.images[0]!.size.height)
//            }
//        UIView.animate(withDuration: 1, delay: 4, options: [.curveEaseInOut]) {
//            self.firstBackgroundImage.alpha = 1
//            self.secondBackgroundImage.alpha = 0
//        } completion: { _ in
//            self.secondBackgroundImage = UIImageView(image: self.images[1])
//            }
//
//        UIView.animate(withDuration: 8, delay: 8, options: [.curveEaseInOut]) {
//            self.firstBackgroundImage.center.x -= 100
//            self.firstBackgroundImage.center.y -= 100
//            self.secondBackgroundImage.center.x += 100
//            self.secondBackgroundImage.center.y += 100
//        }
//    }

}
