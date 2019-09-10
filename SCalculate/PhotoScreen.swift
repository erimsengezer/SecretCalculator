//
//  PhotoScreen.swift
//  SCalculate
//
//  Created by Erim Şengezer on 27.08.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit
import CoreData

class PhotoScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedPhoto : Data?
    var selectedPhotoId : UUID?
    
    var photos = [Data]()
    var idArray = [UUID]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add_a_photo_white_36x36.png"), style: .plain, target: self, action: #selector(addTapped))
        
        getData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("deleteData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("addData"), object: nil)
    }
    
    @objc func getData() {
        photos.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let image = result.value(forKey: "photo") as? Data {
                    self.photos.append(image)
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.collectionView.reloadData()
            }
        }catch {
            print("error")
        }
    }
    
    @objc func addTapped() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @objc func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let data = image!.jpegData(compressionQuality: 0.5)
        photos.append(data!)
        
        picker.dismiss(animated: true) {
            print("dismissed")
            print(self.photos)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photos", into: context)
        
        newPhoto.setValue(UUID(), forKey: "id")
        
        newPhoto.setValue(data, forKey: "photo")
        
        do{
            try context.save()
            print("Saved !")
        }catch{
            print("Error")
        }
        
        self.collectionView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name("addData"), object: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        cell.imageView.image = UIImage(data: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = photos[indexPath.item]
        selectedPhotoId = idArray[indexPath.row]
        performSegue(withIdentifier: "goToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let destinationVC = segue.destination as! DetailPage
            destinationVC.chosenPhoto = selectedPhoto
            destinationVC.chosenPhotoId = selectedPhotoId
        }
    }
}
