import UIKit

extension NSDate {
    func monthAgoDate() -> NSDate {
        let addValue = -1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func monthLaterDate() -> NSDate {
        let addValue: Int = 1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
}

class DateManager: UIViewController {
    
    var currentMonthOfDates: [AnyObject] = []
    var selectedDate = NSDate()
    let daysPerWeek = 7
    var numberOfItems: Int!
    
    //1ヶ月の日数
    func daysAcquisition() -> Int {
        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth())

        //1ヶ月の週の数
        let numberOfWeeks = rangeOfWeeks.length
        
        //週の数×列の数
        numberOfItems = numberOfWeeks * daysPerWeek
        
        return numberOfItems
    }
    
    //月の初日
    func firstDateOfMonth() -> NSDate {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day],fromDate: selectedDate)

        components.day = 1

        let firstDateMonth = NSCalendar.currentCalendar().dateFromComponents(components)!
        
        return firstDateMonth
    }
    
    func dateForCellAtIndexPath() {
        //月の初日が週の何日目かを計算する
        let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDateOfMonth())
        
        for(var i = 0; i < numberOfItems; i++) {
            
            //月の初日とindexPath.item番目のセルに表示する日の差
            let dateComponents = NSDateComponents()
            
            dateComponents.day = i - (ordinalityOfFirstDay - 1)

            //表示する月の初日から上記で計算した差を引いた日付を取得
            let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: firstDateOfMonth(), options: NSCalendarOptions(rawValue: 0))!

            currentMonthOfDates.append(date)
        }
    }
    
    //日付表示
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row] as! NSDate)
    }
    
    //今日の枠線表示の比較用年月日
    func nsIndexPathformatYYYYMMDD(indexPath: NSIndexPath) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row] as! NSDate)
    }
    
    //今月以外の日付背景をグレーにするための比較用月
    func nsIndexPathformatMM(indexPath: NSIndexPath) -> Int {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        return Int(formatter.stringFromDate(currentMonthOfDates[indexPath.row] as! NSDate))!
    }
    
    //前月の表示
    func prevMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    
    //次月の表示
    func nextMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
    
    //今月の表示
    func thisMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date
        return selectedDate
    }
    
    //YYYY年M月
    func yearMonthLabel(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }
    
    //yyyyMMdd変換
    func formatYYYYMMDD(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let yyyyMMdd = formatter.stringFromDate(date)
        return yyyyMMdd
    }
    
    //MM変換
    func formatMM(date: NSDate) -> Int {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let mm = formatter.stringFromDate(date)
        return Int(mm)!
    }
    
    //枠線
    func border(cell: AnyObject, borderWidth: CGFloat, borderColor: CGColor){
        cell.layer.borderWidth = borderWidth
        cell.layer.borderColor = borderColor
    }
    
    //セル背景色
    func cellSelectedBackgroundView(color: UIColor) -> UIView {
        let cellSelectedBackgroundView = UIView()
        cellSelectedBackgroundView.backgroundColor = color
        return cellSelectedBackgroundView
    }
    
    //月の行数
    func dayOfMonthLineNumber() -> CGFloat {
        let dayNumber = CGFloat(daysAcquisition())
        let dayOfMonthLineNumber = dayNumber / 7
        return dayOfMonthLineNumber
    }
    
    //カレンダー縦サイズ
    func carenderSize(collectionViewHeight: CGFloat, section0Height: CGFloat) -> CGFloat{
        let carenderSize = floor(collectionViewHeight - section0Height)
        return carenderSize
    }
    
    //セル縦幅
    func oneHeightSize(collectionViewHeight: CGFloat, section0Height: CGFloat) -> CGFloat {
        let oneHeightSize = floor(carenderSize(collectionViewHeight,section0Height: section0Height) / dayOfMonthLineNumber())
        return oneHeightSize
    }
    
    //セル縦幅の余白をプラス
    func oneHeightSizePlus(collectionViewHeight: CGFloat, section0Height: CGFloat) -> CGFloat {
        let oneHeightSizeMargin = carenderSize(collectionViewHeight,section0Height: section0Height) % dayOfMonthLineNumber()
        let oneHeightSizePlus = oneHeightSize(collectionViewHeight,section0Height: section0Height) + oneHeightSizeMargin
        return oneHeightSizePlus
        
    }
}




























