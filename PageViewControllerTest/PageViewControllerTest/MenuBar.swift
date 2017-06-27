//
//  MenuBar.swift
//  YouTubeHomeFeed
//
//  Created by Vamshi Krishna on 07/05/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit

protocol MenuSelectionDelegate {
    func menuItemSelected(menuIdx : Int)
}
class MenuBar:UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var delegate : MenuSelectionDelegate?
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.returnRGBColor(r: 230, g: 32, b: 32, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let reuseIdentifier = "Cell"
    let imageNames = ["home", "trending", "subscriptions", "account"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
       
        // Following code to set initial selection
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
        setupHorizontalBar()
       
    }
    var barLeftAnchorConstraint : NSLayoutConstraint?
    func setupHorizontalBar()
    {
        let barView = UIView()
        barView.backgroundColor = UIColor.white
        barView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(barView)
        // Old school frame way
        //barView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        
        
        // New way
        barLeftAnchorConstraint = barView.leftAnchor.constraint(equalTo: self.leftAnchor)
        barLeftAnchorConstraint?.isActive = true
        barView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        barView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
//        barView.rightAnchor.constraint(equalTo: self.rightAnchor)
        barView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    func selectMenuItem(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        let x = CGFloat( indexPath.item) * frame.width / 4
        barLeftAnchorConstraint?.constant = x;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat( indexPath.item) * frame.width / 4
        barLeftAnchorConstraint?.constant = x;
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
//            self.layoutIfNeeded()
//        }, completion: nil)
        delegate?.menuItemSelected(menuIdx: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
        collectionView.selectItem(at: IndexPath(item:0, section:0), animated: false, scrollPosition:[])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell:BaseCell{
    
    var imageView:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.white : UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
