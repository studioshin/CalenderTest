//
//  ViewController.swift
//  CalenderTest
//
//  Created by 北村 真二 on 2019/06/08.
//  Copyright © 2019 STUDIO SHIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MonthlyCalenderViewDelegate {

	
	@IBOutlet weak var calenderBaseView: UIView!
	@IBOutlet weak var calenderLabel: UILabel!
	
	@IBOutlet weak var nextButton: UIButton!
	@IBAction func nextButtonAction(_ sender: Any) {
		
		month += 1
		if month > 12 {
			month = 1
			year += 1
		}
		updateCalender()
	}
	
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		month -= 1
		if month < 1 {
			month = 12
			year -= 1
		}
		updateCalender()
	}
	
	var monthCalView: MonthlyCalenderView!
	var year: Int = 0
	var month: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func viewWillLayoutSubviews() {
		
		if monthCalView == nil {
			let frame = self.calenderBaseView.frame
			//曜日表示
			let weekBar = WeekBarView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 20))
			self.calenderBaseView.addSubview(weekBar)
			weekBar.center = CGPoint(x: frame.size.width / 2, y: 10)
			//月間カレンダー
			monthCalView = MonthlyCalenderView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - 20))
			self.calenderBaseView.addSubview(monthCalView)
			monthCalView.center = CGPoint(x: frame.size.width / 2, y: (frame.size.height / 2) + 10)
			monthCalView.delegate = self
			//日付設定
			let date = Date()
			let d = MonthlyCalenderView.dateToInt(date: date)
			year = d.year
			month = d.month
			updateCalender()
		}
	}
	
	func updateCalender() {
		
		calenderLabel.text = "\(year)年\(month)月"
		monthCalView.set(year: year, month: month)
	}
	
	
	// MonthlyCalenderViewDelegate
	func monthlyCalenderViewTaped(cell: MonthlyCalenderView, date: Date) {
		
		let d = MonthlyCalenderView.dateToInt(date: date)
		let alert = UIAlertController(title: "Tap", message: "\(d.year)年\(d.month)月\(d.day)日", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	func monthlyCalenderViewLongPress(cell: MonthlyCalenderView, date: Date) {
		
		let d = MonthlyCalenderView.dateToInt(date: date)
		let alert = UIAlertController(title: "Long press", message: "\(d.year)年\(d.month)月\(d.day)日", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	
}

