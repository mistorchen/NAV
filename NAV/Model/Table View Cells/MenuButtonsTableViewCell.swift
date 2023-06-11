//
//  MenuButtonsTableViewCell.swift
//  NAV
//
//  Created by Alex Chen on 6/6/23.
//

import UIKit

class MenuButtonsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var menuCollectionView: UICollectionView!
    
    var menuButtons: [MenuButton] = []
    var segueIdentifier = ""
    
    static let identifier = "MenuButtonsTableViewCell"

    static func nib() ->UINib{
        return UINib(nibName: MenuButtonsTableViewCell.identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        menuCollectionView.register(MenuButtonCollectionViewCell.nib(), forCellWithReuseIdentifier: MenuButtonCollectionViewCell.identifier)
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MenuButtonsTableViewCell{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuButtonCollectionViewCell.identifier, for: indexPath) as! MenuButtonCollectionViewCell
        
        
        cell.button.setTitle(menuButtons[indexPath.row].title, for: .normal)
        segueIdentifier = menuButtons[indexPath.row].segueIdentifier
        cell.menuButton.addTarget(self, action: "performSegue", for: .touchUpInside)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuButtons.count
    }
    
    
    @objc func performSegue(){
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
}
