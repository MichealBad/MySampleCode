//
//  RMImagePickerController.swift
//  Musicgram
//
//  Created by Michealbad on 16/8/31.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCell"

class RMImagePickerController: UICollectionViewController, UIGestureRecognizerDelegate,ToolHandleDelegate {
    
    var AssetGridThumbnailSize: CGSize!
    
    var imageManager: PHCachingImageManager!
    var previousPreheatRect: CGRect!
    var assetsFetchResult: PHFetchResult!
    
    var toolsView: ToolsView!
    
    var beganDragging = false
    var previousTranslationY: CGFloat = 0
    let topY: CGFloat = 40
    let buttomY: CGFloat = 361
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        self.imageManager = PHCachingImageManager()
        self.assetsFetchResult = self.fetchAllPhotos()
        self.resetCachedAssets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale = UIScreen.mainScreen().scale
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
        
        // Register cell classes
        self.collectionView!.registerClass(photoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.configViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateCachedAssets()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateCachedAssets()
    }
    
    
    //MARK: - CollectionDataSources
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.assetsFetchResult.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! photoCell
        
        let asset = self.assetsFetchResult[indexPath.item] as! PHAsset
        cell.representedAssetIdentifier = asset.localIdentifier
        
        self.imageManager.requestImageForAsset(asset,
                                               targetSize: AssetGridThumbnailSize,
                                               contentMode: .AspectFill,
                                               options: nil,
                                               resultHandler: {
                                                image, info in
                                                if cell.representedAssetIdentifier == asset.localIdentifier {
                                                    cell.setImage(image!)
                                                }
        })
        
        return cell
    }
    
    //MARK: - CollectionView Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = self.assetsFetchResult[indexPath.item] as! PHAsset
        self.setDetailImageWithAsset(asset)
        self.relayoutSubviewsToOrigin(indexPath)
    }
    
    func configViews() {
        let width = self.view.bounds.width
        //add tools view
        self.toolsView = ToolsView(frame: CGRectMake(0, 0, width, 41+width))
        self.toolsView.delegate = self
        self.toolsView.setTitle("相机胶卷")
        self.view.addSubview(toolsView)
        //add show up
        self.setDetailImageWithAsset(self.assetsFetchResult[0] as! PHAsset)
        //add gesture
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        //more design
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.contentInset = UIEdgeInsetsMake(width+41, 0, 0, 0)
        self.collectionView?.scrollIndicatorInsets = self.collectionView!.contentInset
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    func fetchAllPhotos() -> PHFetchResult {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssetsWithOptions(fetchOptions)
        
        return allPhotos
    }
    
    func setDetailImageWithAsset(asset: PHAsset) {
        self.imageManager.requestImageForAsset(asset,
                                               targetSize: PHImageManagerMaximumSize,
                                               contentMode: .Default,
                                               options: nil, resultHandler: {
                                                image, info in
                                                self.toolsView.setImage(image!)
        })
    }
    
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
        self.previousPreheatRect = CGRectZero
    }
    
    func updateCachedAssets() {
        let isVisable = self.isViewLoaded() && self.view.window != nil
        if !isVisable {
            return
        }
        
        var preheatRect = self.collectionView?.bounds
        preheatRect = CGRectInset(preheatRect!, 0, -0.5 * CGRectGetHeight(preheatRect!))
        
        
        let delta = abs(CGRectGetMidY(preheatRect!) - CGRectGetMidY(self.previousPreheatRect))
        if delta > CGRectGetHeight(self.collectionView!.bounds) / 3.0 {
            
            var addedIndexPaths = [NSIndexPath]()
            var removedIndexPaths = [NSIndexPath]()
            
            self.computeDifferenceBetweenRect(self.previousPreheatRect, newRect: preheatRect!, removedHandler: {
                removeRect in
                let indexPaths = self.collectionView?.indexPathsForElementsInRect(removeRect)
                removedIndexPaths.appendContentsOf(indexPaths!)
                }, addedHandler: {
                    addedRect in
                    let indexPaths = self.collectionView?.indexPathsForElementsInRect(addedRect)
                    addedIndexPaths.appendContentsOf(indexPaths!)
            })
            
            let assetsToStartCaching = self.assetsAtIndexPaths(addedIndexPaths)
            let assetsToStopCaching = self.assetsAtIndexPaths(removedIndexPaths)
            
            self.imageManager.startCachingImagesForAssets(assetsToStartCaching,
                                                          targetSize: AssetGridThumbnailSize,
                                                          contentMode: .AspectFill,
                                                          options: nil)
            self.imageManager.stopCachingImagesForAssets(assetsToStopCaching,
                                                         targetSize: AssetGridThumbnailSize,
                                                         contentMode: .AspectFill,
                                                         options: nil)
            
            self.previousPreheatRect = preheatRect
        }
    }
    
    func assetsAtIndexPaths(indexPaths: [NSIndexPath]) -> [PHAsset] {
        var assets = [PHAsset]()
        
        for indexPath in indexPaths {
            let asset = self.assetsFetchResult[indexPath.item]
            assets.append(asset as! PHAsset)
        }
        
        return assets
    }
    
    func computeDifferenceBetweenRect(oldRect: CGRect, newRect: CGRect, removedHandler: (removedRect: CGRect) -> Void, addedHandler: (addedRect: CGRect) -> Void) {
        if CGRectIntersectsRect(oldRect, newRect) {
            let oldMaxY = CGRectGetMaxY(oldRect)
            let oldMinY = CGRectGetMinY(oldRect)
            let newMaxY = CGRectGetMaxY(newRect)
            let newMinY = CGRectGetMinY(newRect)
            
            if (newMaxY > oldMaxY) {
                let rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
                addedHandler(addedRect: rectToAdd);
            }
            
            if (oldMinY > newMinY) {
                let rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
                addedHandler(addedRect: rectToAdd);
            }
            
            if (newMaxY < oldMaxY) {
                let rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
                removedHandler(removedRect: rectToRemove);
            }
            
            if (oldMinY < newMinY) {
                let rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
                removedHandler(removedRect: rectToRemove);
            }
            
        } else {
            addedHandler(addedRect: newRect)
            removedHandler(removedRect: oldRect)
        }
    }
    
    func cancelBtnDidClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func continueBtnDidClick() {
        
    }
    
}

extension RMImagePickerController {
    
    func didPan(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case UIGestureRecognizerState.Began:
            beganDragging = false
            previousTranslationY = 0
            let locationY = sender.locationInView(self.toolsView).y
            if shouldStartTranslating(locationY) {
                beganDragging = true
            }
            break
        case UIGestureRecognizerState.Changed:
            let locationY = sender.locationInView(self.toolsView).y
            if shouldStartTranslating(locationY) {
                beganDragging = true
            }
            let translationY = sender.translationInView(self.view).y
            if beganDragging {
                
                let d = translationY - previousTranslationY
                self.toolsView.frame.origin.y += d
                self.collectionView?.contentInset.top += d
                //self.collectionView?.scrollIndicatorInsets = self.collectionView!.contentInset
                
                if self.toolsView.frame.origin.y >= 5 {
                    self.toolsView.frame.origin.y = 0
                    self.collectionView?.contentInset.top = buttomY
                }
                
            }
            previousTranslationY = translationY
            break
        case .Ended: fallthrough
        case .Cancelled: fallthrough
        case UIGestureRecognizerState.Failed:
            let toolY = self.toolsView.frame.origin.y + self.toolsView.frame.size.height
            let finalY: CGFloat = abs(toolY - topY) > abs(toolY - buttomY) ? buttomY : topY
            
            UIView.animateWithDuration(0.13) {
                self.toolsView.frame.origin.y = finalY - self.toolsView.frame.size.height
                self.collectionView?.contentInset = UIEdgeInsetsMake(finalY, 0, 0, 0)
                self.collectionView?.scrollIndicatorInsets = self.collectionView!.contentInset
            }
            
            break
        default:
            break
        }
        
    }
    
    func shouldStartTranslating(locationY: CGFloat) -> Bool {
        return locationY >= 320 && locationY <= 365
    }
    
    func relayoutSubviewsToOrigin(indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.13) {
            self.toolsView.frame.origin.y = 0
            self.collectionView?.contentInset.top = self.buttomY
            self.collectionView?.scrollIndicatorInsets = self.collectionView!.contentInset
            self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
    
}


//MARK: - UIGestureRecognizerDelegate
extension RMImagePickerController {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //print("juing...")
        let shouldWe = gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer
        return shouldWe
    }
    
}


class photoCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView()
        self.imageView.contentMode = .ScaleToFill
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage) {
        self.imageView.frame = self.bounds
        self.imageView.image = image
    }
    
}









