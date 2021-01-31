//
//  SpotViewController.swift
//  Map
//
//  Created by Alexander Romanenko on 15.10.2020.
//  Copyright © 2020 Alexander Romanenko. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imageCell: [UIImage] = []
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func popToMap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
      
        
        for item in spots {
            if item.title == label.text{
            item.pictures = imageCell
            }
            
        }
    
    }
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        label.text = self.title
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    @IBAction func addSpot(_ sender: Any) {
        let alert2 = UIAlertController(title: "Picture", message: nil, preferredStyle: .alert)
        let alert2action = UIAlertAction(title: "addImage", style: .default, handler: { (UIAlertAction) in
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true)
        })
        alert2.addAction(alert2action)
        present(alert2,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageCell.append(image)
            
        }
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
        }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        func getPictures() -> Int  {
            for pictures in spots.users {
            imageCell = pictures.pictures
        }
            return imageCell.count
        }
 */
        return imageCell.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as! IndexPath) as! SpotCellCollectionViewCell
       //cell.myLabel.text = spotCell[indexPath.row]
       cell.imageView.image = imageCell[indexPath.row]
        return cell
    }
}



