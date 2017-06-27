//
//  SettingsLauncher.swift
//  YouTubeHomeFeed
//
//  Created by Alan Zhang on 6/9/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import  UIKit
class MenuData: NSObject {
    var name : String
    var imageName : String
    
    init(name: String, imageName : String){
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let fadeCoverView = UIView()
    let cellHeight : CGFloat = 50
    let settingItemCellId = "settings"
    
    let settingsMenuData : [MenuData]? = {
        var setting = [MenuData(name: "Menu 1", imageName: "icon_save"),
                       MenuData(name: "Menu 2", imageName: "icon_add"),
                       MenuData(name: "Menu 3", imageName: "icon_audio"),
                       MenuData(name: "Menu 4", imageName: "icon_home")]
        return setting
    }()
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    
    override init() {
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: self.settingItemCellId)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false -- not necessary
        fadeCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismss)))
        
    }
    
    func showSettings(){
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(fadeCoverView)
            window.addSubview(collectionView)
            
            fadeCoverView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            fadeCoverView.frame = window.frame
            fadeCoverView.alpha = 0
            let collectionViewHeight : CGFloat = cellHeight * CGFloat(settingsMenuData?.count ?? 0)
            collectionView.frame = CGRect(x: 0.0, y: window.frame.height, width: window.frame.width, height: collectionViewHeight)
            let y = window.frame.height - collectionViewHeight
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.fadeCoverView.alpha = 1
                self.collectionView.frame = CGRect(x: 0.0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
        
    }
    func handleDismss(){
        UIView.animate(withDuration: 0.5) {
            self.fadeCoverView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0.0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = settingsMenuData?.count ?? 0
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingItemCellId, for: indexPath) as! MenuItemCell
        cell.menu = settingsMenuData?[indexPath.item]
        return cell
    }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settingsMenuData?[indexPath.item]
        
    }
}

class MenuItemCell: UICollectionViewCell {
    
    var menu : MenuData? {
        didSet {
            titleLabel.text = menu?.name
            if let imageName = menu?.imageName {
                imageView.image = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            }
        }
    }
    
    let imageView : UIImageView = {
        let imagevw = UIImageView()
        // Following rendering mode is important for ImageView TintColor to work
//        imagevw.image = UIImage(named: "Bookmark")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imagevw.contentMode = .scaleAspectFill
        imagevw.tintColor = UIColor.darkGray
        return imagevw
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.black
        return label
    }()
    
    override var isHighlighted: Bool{
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            titleLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
            // In order for following tintColor to work, the image must use .alwaysTemplate rendering mode.
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not implemented yet")
    }
    
    
    func setupViews(){
        addSubview(titleLabel)
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: imageView, titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
