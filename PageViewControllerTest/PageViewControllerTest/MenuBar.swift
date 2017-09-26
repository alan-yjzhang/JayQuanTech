//
//  MenuBar.swift
//  PageViewControllerTest
//
//  Created by Alan Zhang on 9/26/17.
//  Copyright © 2017 AlanZhang. All rights reserved.
//

import UIKit

protocol MenuSelectionDelegate {
    func menuItemSelected(menuIdx : Int)
}
class MenuBar:UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var delegate : MenuSelectionDelegate?
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.returnRGBColor(r: 230, g: 32, b: 32, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let reuseIdentifier = "Cell"
    let menuImageNames = ["home", "trending", "subscriptions", "account", "home", "trending", "subscriptions"]
    let visibleMenuCount : CGFloat = 4
    var currentSelectedItem = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        collectionView.register(MenuImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(MenuTitleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
       
//        setupHorizontalBar()
       
    }
    override func layoutSubviews() {
        collectionView.frame = self.frame
        super.layoutSubviews()
        
        let indexPath = IndexPath(item: currentSelectedItem, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    func selectMenuItem(menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuImageNames.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedItem = indexPath.item
//        delegate?.menuItemSelected(menuIdx: indexPath.item)
        print("*** user select", indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        #if false
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MenuImageCell
        cell.imageView.image = UIImage(named: menuImageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
        #else
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MenuTitleCell
            cell.titleLabel.text = menuImageNames[indexPath.item]
        #endif
        
        cell.menuTitle = menuImageNames[indexPath.item]
        if indexPath.item == currentSelectedItem {
            cell.isSelected = true
            cell.isHighlighted = true
        }else{
            cell.isSelected = false
            cell.isHighlighted = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: frame.width/visibleMenuCount, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuTitleCell:BaseCell{
    var menuTitle : String?
    var titleLabel: UILabel = {
        let iv = UILabel()
        iv.textAlignment = .center
        return iv
    }()
    var barView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.isHidden = true
        return v
    }()
    override var isHighlighted: Bool{
        didSet{
            titleLabel.textColor = isHighlighted ? UIColor.white : UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
            barView.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool{
        didSet{
            titleLabel.textColor = isSelected ? UIColor.white : UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
            barView.isHidden = !isSelected
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(titleLabel)
        addSubview(barView)
        titleLabel.text = menuTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        barView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(32)]", views: titleLabel)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:|[v0]|", views: barView)
        addConstraintsWithFormat(format: "V:[v0(4)]|", views: barView)
    }
}
class MenuImageCell:BaseCell{
    var menuTitle : String?
    var imageView:UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    var barView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.isHidden = true
        return v
    }()
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
            barView.isHidden = !isHighlighted
            print(menuTitle, "highlighted", isHighlighted)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.white : UIColor.returnRGBColor(r: 91, g: 14, b: 13, alpha: 1)
            barView.isHidden = !isSelected
            print(menuTitle, "selected", isSelected)
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(imageView)
        addSubview(barView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        barView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:|[v0]|", views: barView)
        addConstraintsWithFormat(format: "V:[v0(4)]|", views: barView)
    }
}
