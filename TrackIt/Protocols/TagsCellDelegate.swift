//
//  TagsCellDelegate.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol TagsCellDelegate {
    func tagsCell(_ cell: TagsCell, didTapTagTitle title: String)
    func tagsCell(_ cell: TagsCell, didTapRemoveButtonForTitle title: String)
    @objc optional func tagsCellDidTapAddTag(_ cell: TagsCell)
}
