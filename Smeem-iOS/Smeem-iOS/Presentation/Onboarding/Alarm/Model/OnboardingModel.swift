//
//  OnboardingModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

// MARK: - UserPlan

struct UserPlanRequest: Codable {
    let target: String
    let trainingTime: TrainingTime
    let hasAlarm: Bool
}

struct TrainingTime: Codable {
    let day: String
    let hour, minute: Int
}

// MARK: - Nickname

struct ServiceAcceptRequest: Codable {
    let username: String
    let termAccepted: Bool
}

struct ServiceAcceptResponse: Codable {
    let badges: [PopupBadge]
}

struct NicknameCheckResponse: Codable {
    let isExist: Bool
}

//struct NicknameResponse: Codable {
//    let success: Bool
//    let message: String
//    let data: ObjectID?
//}
//
//struct ObjectID: Codable {}
