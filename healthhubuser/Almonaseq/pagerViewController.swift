//
//  pagerViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 3/13/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit

class pagerViewController: UIPageViewController {
    
    var lang : String = "";
    var pageControl = UIPageControl();
    var parentIndex = 0;
    let notificationCenter = NotificationCenter.default

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.dataViewController(index: 0),
                self.dataViewController(index: 1),
                self.dataViewController(index: 2)]
    }()

    private func dataViewController(index: Int) -> UIViewController {
        var mainStory = UIStoryboard(name: "Main", bundle: nil);
        var controller = mainStory.instantiateViewController(withIdentifier: "FirstPagerViewController") as! FirstPagerViewController;
        controller.currentIndex = index;
        //parentIndex = index;
        controller.lang = lang;
        return controller;
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        configurePageControl();
         
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 150,width: UIScreen.main.bounds.width,height: 100))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = parentIndex;
        self.pageControl.alpha = 0.9
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = Constants.MainColor;
        self.pageControl.currentPageIndicatorTintColor = Constants.SencondColor
        self.view.addSubview(pageControl)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        dataSource = self;
        notificationCenter.addObserver(self,
                                       selector: #selector(pageViewController(_:viewControllerAfter:)),
                                       name: .refreshPagerControl,
                                       object: nil)
     
        if let firstViewController = orderedViewControllers.first {
               setViewControllers([firstViewController],
                                  direction: .forward,
                   animated: true,
                   completion: nil);
           }
            }
    
}
            
// MARK: UIPageViewControllerDataSource
extension pagerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                   return nil
               }
               
               let previousIndex = viewControllerIndex - 1
               
               guard previousIndex >= 0 else {
                   return nil
               }
               
               guard orderedViewControllers.count > previousIndex else {
                   return nil
               }
               
        self.pageControl.currentPage = previousIndex;
               return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
     
        guard let viewControllerIndex = orderedViewControllers.index(of:viewController) else {
                   return nil
               }
               
               let nextIndex = viewControllerIndex + 1
               let orderedViewControllersCount = orderedViewControllers.count

               guard orderedViewControllersCount != nextIndex else {
                   return nil
               }
               
               guard orderedViewControllersCount > nextIndex else {
                   return nil
               }
               self.pageControl.currentPage = nextIndex;

               return orderedViewControllers[nextIndex]
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of : firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
            
}
