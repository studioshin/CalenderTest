//
//  DayCellView.swift
//

import UIKit

protocol DayCellViewDelegate {
	func dayCellViewTaped(cell: DayCellView, date: Date)
	func dayCellViewLongPress(cell: DayCellView, date: Date)
}

class DayCellView: UIView {
	
	var delegate: DayCellViewDelegate?
	
	class func dayCellView(frame: CGRect) -> DayCellView {
		
		let vc = UIViewController(nibName: "DayCellView", bundle: nil)
		let v = vc.view as! DayCellView
		v.frame = frame
		return v
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.dayLabel.layer.masksToBounds = true
		self.dayLabel.layer.cornerRadius = dayLabel.frame.size.width / 2 
		
		//ロングプレス
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_ :)))
		longPress.minimumPressDuration = 0.6
		self.addGestureRecognizer(longPress)
		
		//タップ
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_ :)))
		self.addGestureRecognizer(tap)
		
		self.layer.borderColor = UIColor.lightGray.cgColor
		self.layer.borderWidth = 0.5
		
	}
	
	@objc func tap(_ tap: UITapGestureRecognizer) {
		
		self.delegate?.dayCellViewTaped(cell: self, date: _date)
	}
	@objc func longPress(_ longPress: UILongPressGestureRecognizer) {
		
		self.delegate?.dayCellViewLongPress(cell: self, date: _date)
	} 
	
	
	@IBOutlet weak var dayLabel: UILabel!
	
	
	
	func set(schedules: [Any], startDate: Date) {
		
		self.date = startDate
		self.scheduleDatas = schedules
	}
	
	private var scheduleList: [Any] = []
	var scheduleDatas: [Any] {
		
		get {
			return scheduleList
		}
		
		set {
			scheduleList = newValue
			
		}
	}
	
	var _date: Date!
	var date: Date {
		get {
			return _date
		}
		set {
			_date = newValue
			
			let d = MonthlyCalenderView.dateToInt(date: _date)
			self.dayLabel.text = "\(d.day)"
			let today = MonthlyCalenderView.dateToInt(date: Date())
			if d.year == today.year && d.month == today.month {
				//今月
				if d.day == today.day {
					//今日
					dayLabel.backgroundColor = UIColor(displayP3Red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
					
				} else {
					self.backgroundColor = UIColor.clear
				}
			} else {
				//今月ではない
				self.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
			}
			
		}
	}
}

