//
//  KBPostBookViewController.swift
//  KooB
//
//  Created by Andrea Borghi on 9/25/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import MobileCoreServices

class KBPostBookViewController: UIViewController, UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, CLLocationManagerDelegate,UINavigationControllerDelegate, SelectBookLocationMapViewControllerDelegate {
    func userDidSelectLocation(location: CLLocationCoordinate2D, currentView: UIViewController, radius: Double) {
        
    }
    
    @IBOutlet weak var BookName: UITextField!
    @IBOutlet weak var Author: UITextField!
    @IBOutlet weak var Condition: UITextField!
    @IBOutlet weak var Subject: UITextField!
    @IBOutlet weak var Price: UITextField!
    
    
    
    var Subjects = ["Accounting","Administration of Justice","Anthropology","Arts","Astronomy","Automotive Technology","Biology","Business","Cantonese","Career Life Planning","Chemistry","Child Development","Computer Aided Design","Computer Information System","Counseling","Dance","Economics","Education","Engeineering","ESL","English","Enviromental Science","Film and Television","French","Geography","Geology","German","Guidance","Health Technology","Health","Hindi","History","Human Development","Humanities","Intercultural Studies","International Studies","Italian","Japanese","Journalism","Korean","Language Arts","Learning Assistance","Librarty","Linguistics","Mandarin","Manufacturing","Mathematics","Meterology","Music","Nursing","Nutrition","Paralegal","Persian","Philosophy","Photography","Physical Education","Physics","Political Science","Pyschology","Reading","Real Estate","Russian","Sign Language","Skills","Social Science","Sociology","Spanish","Speech","Theater Arts","Vietnamese","Women Studies","Misc" ]
    
    var bookToPost:KoobBook!
    var ConditionPicker=UIPickerView()
    var SubjectPicker=UIPickerView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        CreatePickerViews();
        
    }
    
    
    func CreatePickerViews(){
        /*
        ConditionPicker.frame=CGRectMake(0, 480, 320, 400)
        ConditionPicker.delegate=self
        self.view.addSubview(ConditionPicker)
        self.Condition.inputView = ConditionPicker;
        */
        SubjectPicker.frame=CGRectMake(0, 480, 320, 400)
        //SubjectPicker.center = self.view.center
        SubjectPicker.delegate=self
        self.view.addSubview(SubjectPicker)
        self.Subject.inputView = self.SubjectPicker;
        
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return Subjects.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String
    {
        return Subjects[row]
    }
    
    
    @IBAction func PostBook(sender: AnyObject) {
        
        //var title:String = BookName.text;
        //var author:String = Author.text;
        //var price:String = Price.text;
        //bookToPost = KoobBook(title: title, author: author, price: price);
        
        if (bookToPost == nil){
            var title:String = BookName.text;
            var author:String = Author.text;
            var price:String = Price.text;
            bookToPost = KoobBook(title: title, author: author, price: price);
            println("First init");
            
        }
        
        bookToPost.bookTitle = BookName.text;
        bookToPost.author = Author.text;
        bookToPost.price = Price.text;
        
        let imageData = UIImagePNGRepresentation(Picture.image)
        let imageFile = PFFile(name:"image.png", data:imageData)

        bookToPost.picture = imageFile;
        
        
        pushBook(bookToPost);
        
    }
    
    func pushBook(book: KoobBook){
        var pushBook = PFObject(className: "Books_DataBase");
        pushBook.setObject(book.bookTitle, forKey: "BookName");
        pushBook.setObject(book.author, forKey: "Author");
        
        //let imageData = UIImagePNGRepresentation(book.picture?.image)
        //let imageFile = PFFile(name:"image.png", data:imageData)
        
        pushBook["image"] = book.picture
        
        
        pushBook.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object created with id: \(pushBook.objectId)")
                
                var alert = UIAlertController(title: "Success your book has been posted", message: " ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                NSLog("%@", error)
            }
        }
        
        
    }
    
    //Image -------------------------------------------------------
    
    
    @IBAction func UploadPicture(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Upload Image", message: "Where would you like to get picture from ?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let option0 = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCamera())})
        let option1 = UIAlertAction(title: "Open Camera Roll", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in (self.presentCameraRoll())})
        let option3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {(actionSheet: UIAlertAction!) in ()})
        /*
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {alertAction in
        println("Cancel")
        actionSheet.dismissViewControllerAnimated(true, completion: true)//dismissModalViewControllerAnimated(true);
        }))
        
        */
        
        
        actionSheet.addAction(option0)
        actionSheet.addAction(option1)
        actionSheet.addAction(option3)
        
        
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet weak var Picture: PFImageView!
    var cameraUI:UIImagePickerController = UIImagePickerController()
    
    
    func presentCamera()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func presentCameraRoll()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraUI.mediaTypes = NSArray(object: kUTTypeImage)
        cameraUI.allowsEditing = true
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        //    var mediaType:NSString = info.objectForKey(UIImagePickerControllerEditedImage) as NSString
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        Picture.image = imageToSave
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savedImage()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Done")
        alert.show()
    }
    
    
    
    // -------------------------------------------------------
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
}