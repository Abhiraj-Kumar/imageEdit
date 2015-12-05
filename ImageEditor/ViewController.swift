//
//  ViewController.swift
//  ImageEditor
//
//  Created by proptiger on 05/12/15.
//  Copyright © 2015 Self. All rights reserved.
//

import UIKit
import imglyKit


class ViewController: UIViewController {
    var completedImage:UIImage?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

  
    @IBAction func clickedButton(sender: UIButton) {
                let cameraViewController =        IMGLYInstanceFactory.viewControllerForButtonType(IMGLYMainMenuButtonType.Crop, withFixedFilterStack: IMGLYFixedFilterStack())
                cameraViewController?.lowResolutionImage = UIImage(named: "b2.png")
                cameraViewController?.previewImageView.image = UIImage(named: "b2.png")
           cameraViewController?.completionHandler = subEditorDidComplete
        
        
       let doneButton = UIButton(frame: CGRectMake(10,0,100,40))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        cameraViewController!.view.addSubview(doneButton)
        doneButton.addTarget(cameraViewController, action: Selector("tappedDone:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let screenWidth  = self.view.frame.size.width
        let cancelButton = UIButton(frame:CGRectMake(screenWidth-100,0,100,40))
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cameraViewController!.view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: Selector("dismissVC"), forControlEvents: UIControlEvents.TouchUpInside)

        
        
        showViewController(cameraViewController!, sender: self)
        //self.presentViewController(cameraViewController!, animated: true, completion: nil)


    }
    
    
    private func subEditorDidComplete(image: UIImage?, fixedFilterStack: IMGLYFixedFilterStack) {
        completedImage = image
        UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
    
       
    }

    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
        }
    }
    
    func dismissVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

