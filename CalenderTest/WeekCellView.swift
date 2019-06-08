//
//  WeekCellView.swift
//

import UIKit

protocol WeekCellViewDelegate {
	func weekCellViewTaped(cell: WeekCellView, date: Date)
	func weekCellViewLongPress(cell: WeekCellView, date: Date)
}


class WeekCellView: UIView, DayCellViewDelegate {

	var delegate: WeekCellViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init(frame: CGRect, startDate: Date) {
		self.init(frame: frame)
		self.startDate = startDate
	}
	
	var dayCells: [DayCellView] = []
	var _startDate: Date!
	var startDate: Date! {
		get {
			return _startDate
		}
		set {
			_startDate = newValue
			let w = frame.size.width / 7 
			let h = frame.size.height 
			var count = 0
			for v in self.subviews {
				v.removeFromSuperview()
			}
			self.dayCells = []
			for i in 0 ..< 7 {
				let date = _startDate.addingTimeInterval(3600 * 24 * Double(count))
				count += 1
				let cell = DayCellView.dayCellView(frame: CGRect(x: w * CGFloat(i), y: 0, width: w, height: h))
				self.addSubview(cell)
				cell.delegate = self
				self.dayCells.append(cell)
				cell.date = date
				
			}
			for v in self.subviews {
				if let label = v as? UILabel, label.tag == 100 {
					self.bringSubviewToFront(label)
				}
			}
		}
	}
	
	//MARK:-  DayCellViewDelegate
	func dayCellViewTaped(cell: DayCellView, date: Date) {
		
		self.delegate?.weekCellViewTaped(cell: self, date: date)
	}
	func dayCellViewLongPress(cell: DayCellView, date: Date) {
		
		self.delegate?.weekCellViewLongPress(cell: self, date: date)
	}
}
