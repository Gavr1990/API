//
//  ViewController.swift
//  Food
//
//  Created by Андрей Гаврилов on 11.03.2022.
//

import UIKit
import SwiftUI

class HelloScreen: UIViewController {

    private var images: [UIImage?]!
    private var secondView: UIView!
    private var mainButton: UIButton!
    private var mainLabel: UILabel!
    
    private var menuImage: UIImageView!
    private var buyImage: UIImageView!
    private var foodLabel: UILabel!
    private var deliveryLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        
        images = [UIImage]()
        images.append(UIImage(named: "IMG_8864.jpg") ?? nil)
                
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
        
    }
        
    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func mainButtonAction() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            self.mainLabel.center.x -= 50
            self.mainButton.center.x -= 50
            self.mainLabel.alpha = 0
            self.mainButton.alpha = 0
        }
    }
    
}
