//
//  YCPageContainerViewController.swift
//  SportsTablet
//
//  Created by Alan Zhang on 9/25/17.
//  Copyright © 2017 YinzCam, Inc. All rights reserved.
//

import Foundation

protocol YCPageVCInfoDelegate {
    func pageViewController(forPage: YCPageVCInfo) -> UIViewController
//    func pageWillTransition(forPage: YCPageVCInfo, toPage: YCPageVCInfo)
//    func pageDidFinish(forPage: YCPageVCInfo, fromPage: YCPageVCInfo)
}

class YCPageContainerViewController : YCViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, YCScrollMenuBarDelegate
{
    private var currentIndex : Int = 0
    
    var pages : [YCPageVCInfo]? {
        didSet{
            if self.viewIfLoaded != nil {
                self.pageViewController?.setViewControllers([self.pages![0].viewController!], direction: .forward, animated: false, completion: nil)
                self.pageSelectorView?.menuData = self.pages
                self.pageSelectorView?.menuNames = self.pages!.map( {$0.Title!} )
            }
        }
    }
    init(pages: [YCPageVCInfo]?) {
        super.init(nibName: nil, bundle: nil)
        self.pages = pages
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.createTestPages()
//        fatalError("init(coder:) has not been implemented")
    }
    lazy var pageSelectorView: YCScrollMenuBar? = {
        let menubar = YCScrollMenuBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        menubar.delegate = self
        menubar.menuBackgroundColor = UIColor.init(red: 11.0/255, green: 28.0/255, blue: 23.0/255, alpha: 1.0)
        menubar.selectedColor = UIColor.white
        menubar.unselectedColor = UIColor.init(white: 1.0, alpha: 0.6)
        if let pages = self.pages {
            menubar.menuNames = self.pages!.map( {$0.Title!} )
            menubar.menuData = self.pages
        }
        return menubar
    }()
    lazy var pageViewController : UIPageViewController? = {
        let optionsDict = [UIPageViewControllerOptionInterPageSpacingKey : 20]
        let pvc  = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: optionsDict)
        pvc.dataSource = self
        pvc.delegate = self
        pvc.view.isUserInteractionEnabled = true
        if let firstVC = self.pages?[0].viewController {
            pvc.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
        return pvc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewContraints()
        let logoViewCenter = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 160, height: 44))
        logoViewCenter.image = UIImage.init(named: "titlebar_logo")
        self.titlebarViewCenter = logoViewCenter;
        
        let logoImage =  UIImage.init(named: "live_pass_t-logo")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem.init(image: logoImage, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = button
        
        self.setupNavigationItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for gesture in self.pageViewController!.gestureRecognizers {
            print(gesture)
        }
    }
    func setupViewContraints()
    {
        view.addSubview(self.pageSelectorView!)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":self.pageSelectorView!]))
        
        // PageViewController
        self.addChildViewController(self.pageViewController!)
        self.pageViewController?.view.frame = self.view.frame
        view.insertSubview(self.pageViewController!.view, belowSubview: self.pageSelectorView!)
        self.pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":self.pageViewController!.view]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":self.pageSelectorView!, "v1":self.pageViewController!.view]))
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let curIndex = pageIndex(ofViewController: viewController) else{
            return nil
        }
        let prevIndex = curIndex - 1
        guard prevIndex >= 0 else {
            return nil
        }
        return pages?[prevIndex].viewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let curIndex = pageIndex(ofViewController: viewController) else{
            return nil
        }
        let nextIndex = curIndex + 1
        guard let pages = self.pages, nextIndex < pages.count else {
            return nil
        }
        return self.pages?[nextIndex].viewController
        
    }
    func gotoPage(pageIndex: Int){
        guard self.pages != nil else {
            return
        }
        guard pageIndex>=0, pageIndex < self.pages!.count else{
            return
        }
        let direction :UIPageViewControllerNavigationDirection = currentIndex > pageIndex ? .reverse : .forward
        currentIndex = pageIndex
        self.pageViewController?.setViewControllers([pages![pageIndex].viewController!], direction: direction, animated: true, completion: nil)
    }
    func pageIndex(ofViewController: UIViewController) -> Int?
    {
        guard let count = self.pages?.count else{
            return nil
        }
        for var i in (0 ..< count) {
            if self.pages?[i].viewController == ofViewController {
                return i
            }
        }
        return nil
    }
    
    // MARK: YCScrollMenuBarDelegate
    func menuItemSelected(menuIdx: Int, menuData: Any?) {
        guard let pages = self.pages, menuIdx >= 0, menuIdx < pages.count else{
            return
        }
        self.gotoPage(pageIndex: menuIdx)
    }
    
    // MARK: Followings are for UIPageControl -- built-in
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        // following to show page control
        //        if let count = pages?.count {
        //            return count
        //        }
        return 0 // to hide page control
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else{
            return
        }
        self.currentIndex = pageIndex(ofViewController: pageViewController.viewControllers![0] )!
        self.pageSelectorView?.selectMenuItem(menuIndex: self.currentIndex)
//        self.setupNavigationItem()
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // TODO: notify page
    }
    
    #if DEBUG
    func createTestPages() -> [YCPageVCInfo]?
    {
        var testPages = [YCPageVCInfo]()
        let colors = [UIColor.blue, UIColor.brown, UIColor.white, UIColor.gray]
        for var i in 0 ..< 5 {
            let vc = UIViewController()
            vc.view.backgroundColor = colors[i%4]
            var page = YCPageVCInfo(title: "Page\(i)", value: "page\(i)", viewController: vc, delegate: nil)
            testPages.append(page)
        }
        self.pages =  testPages
        return testPages
    }
    #endif
}

class YCPageVCInfo : NSObject
{
    var Title : String? // conforming to YCSelectorView value structure ["Title":"", "Value":""]
    var Value : String?
    var delegate : YCPageVCInfoDelegate?
    
    lazy var viewController : UIViewController? = {
        if self.pageViewController != nil {
            return self.pageViewController
        }
        if let vc = self.delegate?.pageViewController(forPage: self) {
            self.pageViewController = vc
            return vc
        }
        let storyboard = UIStoryboard.init(name: self.pageViewControllerStoryboard!, bundle: nil)
        self.pageViewController = storyboard.instantiateViewController(withIdentifier: self.pageViewControllerIdentifier!)
        return self.pageViewController
    }()
    
    private var pageViewControllerStoryboard : String?
    private var pageViewControllerIdentifier: String?
    private var pageViewController : UIViewController?
    
    init(title: String, value: String, viewController : UIViewController, delegate: YCPageVCInfoDelegate? ) {
        super.init()
        self.Title = title
        self.Value = value
        self.pageViewController = viewController
        self.delegate = delegate
    }
    init(title: String, value: String, pageViewControllerStoryboard : String, pageViewControllerIdentifier: String, delegate: YCPageVCInfoDelegate? ) {
        super.init()
        self.Title = title
        self.Value = value
        self.pageViewControllerStoryboard = pageViewControllerStoryboard
        self.pageViewControllerIdentifier = pageViewControllerIdentifier
        self.delegate = delegate
    }
}
