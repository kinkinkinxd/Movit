import UIKit


class CollectionViewHeaderReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var cellTitle: UILabel!
    
    func setup(_ title: String) {
            cellTitle.text = title
        }
    }

