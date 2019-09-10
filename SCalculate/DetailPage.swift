//
//  DetailPage.swift
//  SCalculate
//
//  Created by Erim Şengezer on 3.09.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import CoreData

class DetailPage: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var chosenPhoto : Data?
    var chosenPhotoId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "deleteIcon.png"), style: .plain, target: self, action: #selector(addTapped))
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(image))
        imageView.addGestureRecognizer(imageTapRecognizer)
        
        
        let stringUUID = chosenPhotoId!.uuidString
        print(stringUUID)
        imageView.image = UIImage(data: chosenPhoto!)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func image() {
        let imageInfo      = GSImageInfo(image: imageView.image!, imageMode: .aspectFit, imageHD: nil)
        let transitionInfo = GSTransitionInfo(fromView: imageView)
        let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    
    @objc func addTapped() {
        print("Delete icon tapped")
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
        let yesButton = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (yesButton) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
            
            
            let idString = self.chosenPhotoId!.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if (result.value(forKey: "id") as? UUID) != nil {
                            context.delete(result)
                        }
                    }
                }
                
            }catch {
                print("error")
            }
            
            
            print("Yes")
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("deleteData"), object: nil)
        }
        let noButton = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(yesButton)
        alert.addAction(noButton)
        
        self.present(alert, animated: true, completion: nil)
    }

}
