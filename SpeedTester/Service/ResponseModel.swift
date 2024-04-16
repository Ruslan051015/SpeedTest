//
//  ResponseModel.swift
//  SpeedTester
//
//  Created by Руслан Халилулин on 16.04.2024.
//

import Foundation

struct ResponseModel: Decodable {
  let created: String
  let description: String
  let downloads: Int
  let expires: String
  let id: String
  let link: String
  let name: String
  let status: Int
  let success: Int

}
