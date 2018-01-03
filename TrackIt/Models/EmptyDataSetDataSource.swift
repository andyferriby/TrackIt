//
//  EmptyDataSetDataSource.swift
//  TrackIt
//
//  Created by Jason Ji on 5/8/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EmptyDataSetDataSource: NSObject {
    var title: String?
    var dataSetDescription: String?
    var verticalOffset: CGFloat?
    
    @objc init(title: String, dataSetDescription: String, verticalOffset: CGFloat) {
        self.title = title
        self.dataSetDescription = dataSetDescription
        self.verticalOffset = verticalOffset
    }
}

extension EmptyDataSetDataSource: DZNEmptyDataSetSource {
    
    @objc func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let title = title else { return nil }
        
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0),
                          NSAttributedStringKey.foregroundColor: ColorManager.moneyColor()]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    @objc func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let dataSetDescription = dataSetDescription else { return nil }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
                          NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                          NSAttributedStringKey.paragraphStyle: paragraph]
        
        return NSAttributedString(string: dataSetDescription, attributes: attributes)
    }
    
    @objc func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        guard let verticalOffset = verticalOffset else { return 0 }
        return verticalOffset
    }
}
