//
//  PageController.swift
//  YouTubeHomeFeed
//
//  Created by Alan Zhang on 6/24/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import UIKit
class PageController: UIPageViewController {
    
    let viewColors = [ UIColor.blue, UIColor.brown, UIColor.red, UIColor.gray]
    var currentPage: Int = 0
    var pageViewControllers = [UIViewController]()
    

    class func createPageController() -> PageController {
        // From storyboard
//        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PageController") as! PageController
        
        let optionsDict = [UIPageViewControllerOptionInterPageSpacingKey : 20]
        let vc = PageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: optionsDict)
        
        return vc
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataSource = self
        
        // Load page ViewControllers from storyboards or programmatically
        for i in 0..<4 {
            let url : String = "View " + i.description
            let vc = UIViewController()
            vc.view.backgroundColor = viewColors[i]
            pageViewControllers.append(vc)
        }
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        setViewControllers([pageViewControllers[0]], direction: .forward, animated: false, completion: nil)
        
//        setupNavigationBar() -- if this view is in direct control of  NavigationController
    }
    func setupNavigationBar(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 230/255, green: 32/255, blue: 32/255, alpha: 1)
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Home"
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        let size = titleLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        navigationItem.titleView = titleLabel
    }
}

extension PageController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let curIndex = pageViewControllers.index(of: viewController) else {
            return nil
        }
        let prevIndex = curIndex - 1
        guard prevIndex >= 0 else{
            return nil
        }
        return pageViewControllers[prevIndex]

    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let curIndex = pageViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = curIndex + 1
        guard nextIndex < pageViewControllers.count else{
            return nil
        }
        return pageViewControllers[nextIndex]
    }
    
    //MARK: UIPageControl  -- built-in
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        //return 0; // To hide page control
        return pageViewControllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
}
