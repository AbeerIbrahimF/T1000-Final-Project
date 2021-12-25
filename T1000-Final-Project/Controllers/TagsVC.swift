//
//  TagsVC.swift
//  T1000-Final-Project
//
//  Created by Abeer Alfaifi on 12/25/21.
//

import UIKit

class TagsVC: UIViewController {
  
    
    // MARK: OUTLETS
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    var tags: [String] = []
    
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        PostAPI.getAllTags { tags in
            self.tags = tags
            self.tagsCollectionView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    // MARK: ACTIONS

}

extension TagsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        
        let currentTag = tags[indexPath.row]
        cell.tagLabel.text = currentTag
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTag = tags[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        vc.tag = selectedTag
        present(vc, animated: true)
    }
    
    
}
