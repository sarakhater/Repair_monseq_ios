//
//  ImageSliderCollectionViewCell.swift
//  Almonaseq
//
//  Created by unitlabs on 3/16/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit
import FSPagerView

class ImageSliderCollectionViewCell: UICollectionViewCell  ,FSPagerViewDataSource,FSPagerViewDelegate {
    
    var data : [ImageSlider] = [];
    var identifier = "ImagesCollectionViewCell";
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!{
    didSet {
        self.pageControl.numberOfPages = self.data.count;
        self.pageControl.layer.cornerRadius = 10;
//        self.pageControl.subviews.forEach {
//              $0.transform =  CGAffineTransform(scaleX: 1.5, y: 1.5)
//             }

        }
        
    }
    
   
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        self.pageControl.numberOfPages = self.data.count;

        return data.count;
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
             let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", at: index) as! ImagesCollectionViewCell
        let imgUrl = URL(string: data[index].image);
        
        cell.cellImageView!.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "colored_logo"));
        if(Utils.getcurrentLanguage() == "ar"){
            cell.titleLabel.text = data[index].title_ar;

        }else {
            cell.titleLabel.text = data[index].title_en;

        }
        //cell.cellImageView?.contentMode = .scaleAspectFit;
       // cell.cellImageView?.clipsToBounds = true;
               return cell;
    }
    //HWSwiftyViewPagerDelegate {
    func pagerDidSelecedPage(selectedPage: Int) {
        print(selectedPage);
    }
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    fileprivate var typeIndex = 0 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.pagerView.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .crossFading, .zoomOut, .depth:
                self.pagerView.itemSize = FSPagerView.automaticSize
                self.pagerView.decelerationDistance = 1
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.75)
                self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .ferrisWheel, .invertedFerrisWheel:
                self.pagerView.itemSize = CGSize(width: 180, height: 140)
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .coverFlow:
                self.pagerView.itemSize = CGSize(width: 220, height: 170)
                self.pagerView.decelerationDistance = FSPagerView.automaticDistance
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
                self.pagerView.decelerationDistance = 1
            }
        }
    }
    
    
   
    
    
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex;
        
         }
         
         func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
            self.pageControl.currentPage = pagerView.currentIndex;
            


         }
    
   
    @IBOutlet weak var pagerView: FSPagerView!{
    didSet {
        self.pagerView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier);
        //self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: identifier);
        self.pagerView.transformer = .init(type: .linear);
        self.pagerView.automaticSlidingInterval = 5;
        self.pagerView.layer.shadowOpacity = 0.0;
        self.pagerView.layer.cornerRadius = 15;
        self.pagerView.layer.shadowColor = UIColor.clear.cgColor;
        pagerView.layer.shadowOffset = .zero
        pagerView.layer.masksToBounds = true
        self.pagerView.layer.shadowRadius = 15;

        bigView.layer.cornerRadius = 15;
        bigView.layer.masksToBounds = true
        self.typeIndex = 0
        
        
        }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pagerView.dataSource = self
        self.pagerView.delegate = self;
      
    }
    
    func configureCell(images: [ImageSlider]){
        self.data = images;
    
        self.pagerView.reloadData();
    }
    
    
   
    
}
