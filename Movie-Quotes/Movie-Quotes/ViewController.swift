//
//  ViewController.swift
//  Movie-Quotes
//
//  Created by administrator on 1/10/22.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


struct Character: Codable {
    let localized_name : String
    let img : String
}

class ViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate {
    
    
    var characters = [Character]()
    
//table
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let url = URL(string : "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) {  (data, response, error ) in
            
                    if (error == nil) {
                
                    do {
 
                        self.characters = try JSONDecoder().decode([Character].self, from: data!)
                    
                    } catch {
                        print("error")
                       
                    }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                    
                    }.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 10
        
        cell.nameLbl.text = characters[indexPath.row].localized_name.capitalized
        cell.imageView.contentMode = .scaleAspectFill
        let defaulteLink = "https://api.opendota.com"
        let link = defaulteLink + characters[indexPath.row].img
        cell.imageView.downloaded(from: link)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "story") as! DetailsViewController
        detailVC.modalPresentationStyle = .popover
        detailVC.names = characters[indexPath.item].localized_name
        
        detailVC.imgurl = characters[indexPath.item].img
        self.present(detailVC, animated: true , completion: nil)
        
    }
   
    
}


