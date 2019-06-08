//
//  MonthlyCalenderView.swift
//

import UIKit

protocol MonthlyCalenderViewDelegate {
	func monthlyCalenderViewTaped(cell: MonthlyCalenderView, date: Date)
	func monthlyCalenderViewLongPress(cell: MonthlyCalenderView, date: Date)
}

//=============================================
//曜日表示ビュークラス
//=============================================
class WeekBarView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let weekBarHeight: CGFloat = self.frame.size.height
		let cellWidth = self.frame.size.width / 7
		for i in 0 ..< 7 {
			let cell = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: self.bounds.size.height))
			cell.textAlignment = .center
			cell.font = UIFont(name: "uzura_font", size: 17.0)
			self.addSubview(cell)
			cell.center = CGPoint(x: cellWidth * CGFloat(i) + (cellWidth / 2), y: weekBarHeight / 2)
			if i == 0 {cell.text = "Sun";cell.textColor = UIColor.red}
			if i == 1 {cell.text = "Mon"}
			if i == 2 {cell.text = "Tue"}
			if i == 3 {cell.text = "Wed"}
			if i == 4 {cell.text = "Thu"}
			if i == 5 {cell.text = "Fri"}
			if i == 6 {cell.text = "Sat";cell.textColor = UIColor.blue}
			cell.backgroundColor = UIColor.clear
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


//=============================================
//月間カレンダー
//=============================================
class MonthlyCalenderView: UIView, WeekCellViewDelegate {
	
	var delegate: MonthlyCalenderViewDelegate?
	
	let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
	var weekCells: [WeekCellView] = []
	var cellWidth: CGFloat = 0
	var cellHeight: CGFloat = 0
	let weekDayCount: Int = 7
	var today: Date = Date()
	var days: Int = 0
	var weeks: Int = 5
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(year: Int, month: Int) {
		
		for v in self.subviews {
			v.removeFromSuperview()
		}
		
		let baseDate = MonthlyCalenderView.intToDate(year, month: month, day: 1, hour: 0, minute: 0, second: 0)
		//月の日数
		let rangeDay = calender.range(of: .day, in: .month, for: baseDate)
		self.days = rangeDay.length
		//月の週数
		let rangeWeek = calender.range(of: .weekOfMonth, in: .month, for: baseDate)
		self.weeks = rangeWeek.length
		//今月の1日
		let firstDay = MonthlyCalenderView.intToDate(year, month: month, day: 1, hour: 0, minute: 0, second: 0)
		//1日のある週の最初の日
		let monthlyStartDate: Date = MonthlyCalenderView.thisWeekStartDate(today: firstDay)
		
		self.cellWidth = frame.size.width / CGFloat(weekDayCount)
		self.cellHeight = frame.size.height / CGFloat(weeks)
		
		weekCells = []
		for y in 0 ..< weeks {
			let date = monthlyStartDate.addingTimeInterval(3600 * 24 * 7 * Double(y))
			let cell = WeekCellView(frame: CGRect(x: 0, y: self.cellHeight * CGFloat(y), width: frame.size.width, height: self.cellHeight), startDate: date)
			self.addSubview(cell)
			cell.delegate = self
			weekCells.append(cell)
		}
	}
	
	
	//MARK:-  WeekCellViewDelegate
	func weekCellViewTaped(cell: WeekCellView, date: Date) {
		
		self.delegate?.monthlyCalenderViewTaped(cell: self, date: date)
	}
	func weekCellViewLongPress(cell: WeekCellView, date: Date) {
		
		self.delegate?.monthlyCalenderViewLongPress(cell: self, date: date)
	}
	
	
	
	// NSDateを文字列に変換する
	class func dateToInt(date: Date) -> (year: Int, month: Int, day: Int, weekday: Int, hour: Int, minute: Int, second: Int) {
		
		let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
		let unit: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second, .weekday]
		let comps: NSDateComponents = calender.components(unit, from: date as Date) as NSDateComponents
		return (year: comps.year, month: comps.month, day: comps.day, weekday: comps.weekday, hour: comps.hour, minute: comps.minute, second: comps.second)
	}
	//年月日をNSDate返す
	class func intToDate(_ year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
		
		let dateString = "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"
		let formatter = DateFormatter()
		//タイムゾーン()を言語設定に合わせる
		formatter.locale = Locale(identifier: NSLocale.Key.languageCode.rawValue)
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = formatter.date(from: dateString)!
		return date
	}
	//今週の開始日を返す
	class func thisWeekStartDate(today: Date) -> Date {
		
		let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
		let todayComps = calender.components([.year, .month, .day, .weekday], from: today)
		let todayWeekday = todayComps.weekday!
		var thisWeekStartDate: Date!
		
		if todayWeekday == 1 {thisWeekStartDate = today}
		else if todayWeekday == 2 {thisWeekStartDate = Date(timeInterval: -(3600 * 24 * 1), since: today)}
		else if todayWeekday == 3 {thisWeekStartDate = Date(timeInterval: -(3600 * 24 * 2), since: today)}
		else if todayWeekday == 4 {thisWeekStartDate = Date(timeInterval: -(3600 * 24 * 3), since: today)}
		else if todayWeekday == 5 {thisWeekStartDate = Date(timeInterval: -(3600 * 24 * 4), since: today)}
		else if todayWeekday == 6 {thisWeekStartDate = Date(timeInterval: -(3600 * 24 * 5), since: today)}
		else if todayWeekday == 7 {thisWeekStartDate = Date(timeInterval: -(3600 * 24 * 6), since: today)}
		return thisWeekStartDate
	} 
}
