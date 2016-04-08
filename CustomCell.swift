import UIKit

/* 日付を表示 */
class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
