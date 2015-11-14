//
//  MovieCell.swift
//  MyMovie2
//
//  Created by Mac on 2015. 11. 14..
//  Copyright © 2015년 Mac. All rights reserved.
//

import UIKit

// 프로토타입 셀에 클래스를 연결함.
// 레이블을 확장하려면 레이블클래스를 상속받아 작성하고 레이블을 선택해 클래스를 연결.
class MovieCell : UITableViewCell {
	
	@IBOutlet var title: UILabel!
	@IBOutlet var desc: UILabel!
	@IBOutlet var rating: UILabel!
	
	@IBOutlet var thumbnail: UIImageView!
}
