//
//  SampleTableViewController.swift
//  MyMovie2
//
//  Created by Mac on 2015. 11. 14..
//  Copyright © 2015년 Mac. All rights reserved.
//

import UIKit

// 일반 뷰 컨트롤러에 만드는 경우 (테이블뷰 화면크기도 조절 가능함) -> 상단은 테이블 뷰로 사용하고 하단은 다른 용도로 쓸 경우 **
// 스토리보드에서 연결 해줘야 함 ** (데이터소스+델리게이트) 테이블뷰 우클릭해서 상단의 컨트롤러 아이콘으로 드래그
class SampleTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	// 프로토콜만 구현한것이기 때문에 override가 아님
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		cell.textLabel?.text = "\(indexPath.row) 번째 데이터"
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
}

