//
//  AddImageViewController.swift
//  ImageEditor
//
//  Created by proptiger on 07/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

import UIKit
import imglyKit
import AVFoundation
import MobileCoreServices
import Photos

class AddImageViewController: UIViewController {
    
    
    enum TagForButtonInView:Int{
        case Rotate=100
        case Crop=200
        case Done=300
        case List=400
        case Delete=500
    }
    
    
    enum ActionOnImage{
        case Crop
        case Rotate
    }


    @IBOutlet weak var centreImage: UIImageView!
    let addImage = UIImage(named: "s")
    let defaultCentreImage = UIImage(named: "")
    var imageList:[UIImage]=[]
    var indexOfCentreImage:Int?
    
    @IBOutlet weak var imageCollectionview: UICollectionView!
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: "AddImageViewController", bundle: nil)
      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "AddImageViewController", bundle: nil)
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centreImage.image = defaultCentreImage
        imageCollectionview.dataSource = self
        imageCollectionview.delegate = self
        imageCollectionview.allowsMultipleSelection = true
        imageCollectionview.registerNib(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickedOnButtonInView(sender: AnyObject) {
        
        switch TagForButtonInView(rawValue:sender.tag)!{
        case .Done:
            self.presetAlertForPhotoSelction()
            return
        case .Crop:
            self.presentImageEditorOfType(.Crop)
           return
        case .Rotate:
            self.presentImageEditorOfType(.Rotate)
            return
        case .List:
            return
        case .Delete:
            self.deleteCentreImage()
            return
        }
        
        
    }
    
    
    func deleteCentreImage(){
        if  let indexToDelete = indexOfCentreImage {
            self.imageList.removeAtIndex(indexToDelete)
            self.imageCollectionview.reloadData()
            if imageList.count > 0{
                self.centreImage.image = imageList[0];
                self.indexOfCentreImage = 0
            }
            else{
                self.indexOfCentreImage = nil
                self.centreImage.image = defaultCentreImage;
            }
            
        }
        
    }
    
    func presentImageEditorOfType(action: ActionOnImage) {
        var imageEditViewController:IMGLYSubEditorViewController?
        switch action{
        case .Crop:
           imageEditViewController = IMGLYInstanceFactory.viewControllerForButtonType(IMGLYMainMenuButtonType.Crop, withFixedFilterStack: IMGLYFixedFilterStack())
        case .Rotate:
            imageEditViewController = IMGLYInstanceFactory.viewControllerForButtonType(IMGLYMainMenuButtonType.Orientation, withFixedFilterStack: IMGLYFixedFilterStack())
            
        }
       imageEditViewController?.lowResolutionImage = self.centreImage.image
        imageEditViewController?.previewImageView.image = self.centreImage.image
        imageEditViewController?.completionHandler = subEditorDidComplete
        
        
        let doneButton = UIButton(frame: CGRectMake(10,0,100,40))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        imageEditViewController!.view.addSubview(doneButton)
        doneButton.addTarget(imageEditViewController, action: Selector("tappedDone:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let screenWidth  = self.view.frame.size.width
        let cancelButton = UIButton(frame:CGRectMake(screenWidth-100,0,100,40))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        imageEditViewController!.view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: Selector("dismissVC"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        showViewController(imageEditViewController!, sender: self)
        //self.presentViewController(cameraViewController!, animated: true, completion: nil)
        
        
    }
    
    
    func addImageToImageList(image:UIImage){
        imageList.append(image)
        self.indexOfCentreImage = imageList.count - 1
        imageCollectionview.reloadData()
        self.centreImage.image = image
        
    }
    
    
    func subEditorDidComplete(image: UIImage?, fixedFilterStack: IMGLYFixedFilterStack) {
        if let image = image{
        self.addImageToImageList(image)
        
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
             self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
           // self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
        }
    }
    
    func dismissVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showCameraRoll(type:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = type
        //imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [String(kUTTypeImage)]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func presetAlertForPhotoSelction(){
        let actionSheet = UIAlertController(title: "Choose Photo", message: "Please choose the photo style", preferredStyle: .ActionSheet)
        let photoAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (photoAction) -> Void in
            self.showCameraRoll(.PhotoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.showCameraRoll(.Camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
        }
        
        actionSheet.addAction(photoAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)


        
    }

}


extension AddImageViewController:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageList.count+1;
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath:indexPath) as! ImageCollectionViewCell
        if indexPath.row == 0{
         cell.imageView.image = addImage
        }
        else{
        cell.imageView.image = self.imageList[indexPath.row-1];
        }
        return cell;
        
    }
    
}



extension AddImageViewController:UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            self.presetAlertForPhotoSelction()
        }
        else{
            self.centreImage.image = imageList[indexPath.row-1]
            self.indexOfCentreImage = indexPath.row - 1
            
        }
    }
    
}


extension AddImageViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        self.addImageToImageList(image)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
}
