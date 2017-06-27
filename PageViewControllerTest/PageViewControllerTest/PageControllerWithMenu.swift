//
//  PageControllerWithMenuBar.swift
//  YouTubeHomeFeed
//
//  Created by Alan Zhang on 6/24/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import UIKit
class PageControllerWithMenuBar: UIViewController, MenuSelectionDelegate {
    //
    // View Structure
    // Navigation Bar
    //  PageControllerWithMenuBar
    //     MenuBar
    //     UIPageViewController
    //

    var sections:[String]?
    var selectedSection : Int = 0
    let settingsLauncher = SettingsLauncher()
    var viewHeight : CGFloat = 0.0
    
    var currentPage: Int = 0
    var pages : [UIViewController]?

    let menuBar:MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    let pageViewController:UIPageViewController = {
        let optionsDict = [UIPageViewControllerOptionInterPageSpacingKey : 20]
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: optionsDict)
        return pageVC
    }()
    
    class func createPageControllerWithMenuBar(pages: [UIViewController]) -> PageControllerWithMenuBar{
        // From storyboard
        //        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "PageControllerWithMenuBar") as! PageControllerWithMenuBar
        let vc = PageControllerWithMenuBar()
        vc.pages = pages
        return vc
    }
    class func createWithTestPageControllers() ->PageControllerWithMenuBar {
        var testpages = [UIViewController]()
        let viewColors = [ UIColor.blue, UIColor.brown, UIColor.red, UIColor.gray]
        for i in 0..<4 {
//            let url : String = "View " + i.description
            let page = UIViewController()
            page.view.tag = i
            page.view.backgroundColor = viewColors[i]
            testpages.append(page)
        }
        return createPageControllerWithMenuBar(pages: testpages)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 230/255, green: 32/255, blue: 32/255, alpha: 1)
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Home"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        let size = titleLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        navigationItem.titleView = titleLabel
        
        sections = ["Home", "Beaty", "News", "Settings"]
        setupNavBarButtons()
        setupViewConstraints()
        
        self.pageViewController.setViewControllers([pages![0]], direction: .forward, animated: false, completion: nil)
        self.pageViewController.dataSource = self as UIPageViewControllerDataSource
        self.pageViewController.delegate = self as UIPageViewControllerDelegate
    }
    func setupNavBarButtons(){
        let searchImage = UIImage(named: "subscriptions")?.withRenderingMode(.alwaysOriginal)
        let menuImage = UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal)
        let searchBarButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let menuBarButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [menuBarButton, searchBarButton]
        // Hide navigation bar when swip
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: #selector(handleNavBarHidden(swipe:)))
        
//        self.edgesForExtendedLayout = []
//        self.extendedLayoutIncludesOpaqueBars = false
//        self.automaticallyAdjustsScrollViewInsets = false //
    }
    override var prefersStatusBarHidden: Bool {
        // Note: specify View-Controller based status bar to YES in info.plist
        return self.navigationController?.isNavigationBarHidden ?? false
    }
    func handleNavBarHidden(swipe: UIPanGestureRecognizer){
    }
    
    func handleMore(){
        settingsLauncher.showSettings()
    }
    func handleSearch(){
        
    }
    
    private func setupViewConstraints(){
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        // Following redView is to hide the gap between navigationBar and menuBar
//        let redView = UIView()
//        redView.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 32/255, alpha: 1)
//        view.addSubview(redView)
//        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
//        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
//        redView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        
        // Following is to make the menuBar always below statusBar (otherwise, there will be some overlap)
        //
//        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar) // Constraint menuBar to outter window
//        //view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar) // Constraint to superview
//        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        menuBar.delegate = self
        
        // PageViewController
        self.addChildViewController(self.pageViewController)
        self.pageViewController.view.frame = self.view.frame
        view.insertSubview(self.pageViewController.view, belowSubview: menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.pageViewController.view)
        view.addConstraintsWithFormat(format: "V:|[v0(50)][v1]|", views: menuBar, self.pageViewController.view)
        
    }
    // MARK: MenuSelectionDelegate
    //
    func menuItemSelected(menuIdx: Int)
    {
        self.selectedSection = menuIdx
        gotoPage(pageIndex: menuIdx)
    }
    // MARK: PageViewController
    func gotoPage(pageIndex: Int){
        guard self.pages != nil else {
            return
        }
        guard pageIndex>=0, pageIndex < pages!.count else{
            return
        }
        let direction :UIPageViewControllerNavigationDirection = currentPage > pageIndex ? .reverse : .forward
        currentPage = pageIndex
        self.pageViewController.setViewControllers([pages![pageIndex]], direction: direction, animated: true, completion: nil)
    }
}
extension PageControllerWithMenuBar : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else{
            return
        }
        // 1 
//        currentPage = pages!.index(of: pageViewController.viewControllers![0])!
        // 2
        currentPage = pageViewController.viewControllers![0].view.tag
        menuBar.selectMenuItem(menuIndex: currentPage)
    }
}

extension PageControllerWithMenuBar : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pages = self.pages else{
            return nil
        }
        guard let curIndex = pages.index(of: viewController) else {
            return nil
        }
        let prevIndex = curIndex - 1
        guard prevIndex >= 0 else{
            return nil
        }
        return pages[prevIndex]
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pages = self.pages else{
            return nil
        }
        guard let curIndex = pages.index(of: viewController) else {
            return nil
        }
        let nextIndex = curIndex + 1
        guard nextIndex < pages.count else{
            return nil
        }
        return pages[nextIndex]
    }
    
    //MARK: UIPageControl  -- built-in
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        //return 0; // To hide page control
        return pages?.count ?? 0
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
}
