import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let dateManager = DateManager()
    let cellMargin: CGFloat = 0.3
    var selectedDate = NSDate()
    var today = NSDate()
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    let yearMonthLabelHeight: CGFloat = 60
    
    //ヘッダー
    @IBOutlet weak var header: UIView!
    //前月ボタン
    @IBOutlet weak var prevBtn: UIButton!
    //次月ボタン
    @IBOutlet weak var nextBtn: UIButton!
    //YYYY年M月
    @IBOutlet weak var yearMonthLabel: UILabel!
    //カレンダー
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        
        //カレンダー背景色
        calenderCollectionView.backgroundColor = UIColor.lightGray()
        //ヘッダー背景色
        header.backgroundColor = UIColor.lightGreen()
        //YYYY年M月表示
        yearMonthLabel.text = dateManager.yearMonthLabel(today)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //セルが表示されるときに呼ばれる　1個のセルを描画する毎に呼び出される
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        //セル背景色
        cell.backgroundColor = UIColor.whiteColor()
        
        //文字色　土曜日を青・日曜日を赤・それ以外はグレー
        if (indexPath.row % 7 == 0) {
            
            cell.dayLabel.textColor = UIColor.lightRed()
            
        } else if (indexPath.row % 7 == 6) {
            
            cell.dayLabel.textColor = UIColor.lightBlue()
            
        } else {
            
            cell.dayLabel.textColor = UIColor.blackColor()
        }
        
        //曜日・日付文字
        if (indexPath.section == 0) {
            cell.dayLabel.text = weekArray[indexPath.row]
            
            //曜日をタップしたときの背景色(セルと同じ色)
            cell.selectedBackgroundView = dateManager.cellSelectedBackgroundView(UIColor.whiteColor())
            
            //曜日枠線
            dateManager.border(cell, borderWidth: 1.0, borderColor: UIColor.whiteColor().CGColor)
            
        } else {
            cell.dayLabel.text = dateManager.conversionDateFormat(indexPath)
            
            //indexPathをyyyy-MM-ddへ変換
            let yyyyMMddIndexPath = dateManager.nsIndexPathformatYYYYMMDD(indexPath)
            
            //今日の年月日をyyyy-MM-ddへ変換
            let yyyyMMddToday = dateManager.formatYYYYMMDD(today)
            
            //表示月をMMへ変換
            let mmSelectedDate = dateManager.formatMM(selectedDate)
            
            //indexPathをMMへ変換
            let mmIndexPath = dateManager.nsIndexPathformatMM(indexPath)
            
            
            if (yyyyMMddIndexPath == yyyyMMddToday) {
                
                //今日の枠線
                dateManager.border(cell, borderWidth: 2.0, borderColor: UIColor.greenColor().CGColor)
                
            } else {
                
                //今日以外の枠線
                dateManager.border(cell, borderWidth: 1.0, borderColor: UIColor.whiteColor().CGColor)
            }
            
            //前月・次月日付背景色を設定
            if (((mmSelectedDate - 1) == mmIndexPath) ||
                ((mmSelectedDate + 1) == mmIndexPath) ||
                (mmSelectedDate == 12 && mmIndexPath == 1) ||
                (mmSelectedDate == 1 && mmIndexPath == 12)) {
                

                if (yyyyMMddIndexPath == yyyyMMddToday) {
                    
                    //枠線をクリア
                    dateManager.border(cell, borderWidth: 1.0, borderColor: UIColor.whiteColor().CGColor)
                }
                
                cell.backgroundColor = UIColor.WhiteGray()
            }
            
            //日付をタップしたときの背景色
            cell.selectedBackgroundView = dateManager.cellSelectedBackgroundView(UIColor.lightGrayColor())
            
        }
        
        return cell
    }
    
    //セクション０：曜日　セクション１：日付
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // 表示するセルの数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            // 曜日表示は７つ
            return 7
        } else {
            // 日付表示は月によって変わる
            dateManager.daysAcquisition()
            dateManager.dateForCellAtIndexPath()
            return dateManager.numberOfItems
        }
    }
    
    //１つのセルサイズ
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let width: CGFloat = floor(collectionView.frame.size.width / 7)
        let widthRest = collectionView.frame.size.width - (width * 7)
        var height: CGFloat!
        let section0Height: CGFloat = width * 0.5
        
        if indexPath.section == 0 {
            
            height = section0Height
            
        } else {
            
            //縦幅計算で出た余白を今月の最終行にプラスする
            if (CGFloat(indexPath.row / 7 + 1) == dateManager.dayOfMonthLineNumber()) {
                
                height = dateManager.oneHeightSizePlus(collectionView.frame.size.height, section0Height: section0Height)
            }
            
            height = dateManager.oneHeightSize(collectionView.frame.size.height, section0Height: section0Height)
            
        }
        
        //横幅設定
        //土曜日の筋に余った横幅を足す
        if (indexPath.row == 6) || (indexPath.row == 12) ||
            (indexPath.row == 18) || (indexPath.row == 24) ||
            (indexPath.row == 30) || (indexPath.row == 36) {
            
            return CGSizeMake(width + widthRest, height)
            
        } else {
            
            return CGSizeMake(width, height)
        }
    }
    
    //セルの左右マージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    //セルの上下マージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    //セクションのマージン
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0);
        } else {
            return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        }
    }
    
    //前月タップ
    @IBAction func tappedPrevBtn(sender: AnyObject) {
        selectedDate = dateManager.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        yearMonthLabel.text = dateManager.yearMonthLabel(selectedDate)
    }
    
    //次月タップ
    @IBAction func tappedNextBtn(sender: AnyObject) {
        selectedDate = dateManager.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        yearMonthLabel.text = dateManager.yearMonthLabel(selectedDate)
    }
    
    //バックグラウンドになったとき
    func enterBackground(notification: NSNotification){
        selectedDate = dateManager.thisMonth(today)
        calenderCollectionView.reloadData()
        yearMonthLabel.text = dateManager.yearMonthLabel(selectedDate)
    }
    
    //フォアグラウンドになったとき
    func enterForeground(notification: NSNotification){
        
    }
    
    //画面が表示される直前に実行される
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.enterBackground(_:)), name:"applicationDidEnterBackground", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.enterForeground(_:)), name:"applicationWillEnterForeground", object: nil)
    }
    
    //別の画面に遷移する直前に実行される
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "applicationDidEnterBackground", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "applicationWillEnterForeground", object: nil)
    }
    
}













