//
//  FlagData.swift
//  ManMan
//
//  Created by Apple on 2019/4/11.
//  Copyright © 2019 Mavismwt. All rights reserved.
//

import Foundation

public struct FlagData: Codable {
    var userId: String?
    var profileURL: String?
    var nickname: String?
    var time: Int64?
    var detail: String?
    var comment = [CommentDetail]()
    var commentNum: Int?
    var isLiked: Bool?
    var likeNum: Int?
    var id: String?
}
public struct CommentDetail: Codable {
    var userName: String?
    var userComment: String?
}

public struct UserInfo: Codable {
    var id: String?
    var wxid: String?
    var name: String?
    var imgURL: String?
}
