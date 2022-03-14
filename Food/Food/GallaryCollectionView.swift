//
//  GallaryCollectionView.swift
//  Food
//
//  Created by Андрей Гаврилов on 12.03.2022.
//

import UIKit

class GallaryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    var cells = [Food]()
    let names = ["Yummy", "Yum-yum", "Delicious", "Tasty", "Hot!", "Look's good", "Beautiful", "Good thing", "Yum", "Lovely"]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .white
        delegate = self
        dataSource = self
        register(GallaryCollectionViewCell.self, forCellWithReuseIdentifier: GallaryCollectionViewCell.reuseId)
        layout.minimumLineSpacing = 10
        contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
//    func set(cells: [Food]) {
//        self.cells = cells
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
//        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GallaryCollectionViewCell.reuseId, for: indexPath) as! GallaryCollectionViewCell
//        cell.mainImageView.downloadedFrom(link: cells[indexPath.row].image)
        cell.nameLabel.text = names.randomElement()
        cell.smallDescriptionLabel.text = names.randomElement()
        cell.costLabel.text = "$\(Int.random(in: 10..<20))"
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 85)/2, height: frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) { //, initialSpringVelocity: 10
            cell.alpha = 1
            cell.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImageView {
   
   func downloadedFrom(link:String) {
    guard let url = URL(string: link) else { return }
    URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
      guard let data = data , error == nil, let image = UIImage(data: data) else { return }
      DispatchQueue.main.async { () -> Void in
        self.image = image
      }
    }).resume()
  }
  
}
