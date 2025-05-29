		//
		//  MatterMQTTEvent.swift
		//  HAPiNest
		//
		//  Created by Jan Verrept on 26/05/2025.
		//  Copyright © 2025 Jan Verrept. All rights reserved.
		//
		import Foundation

		struct MatterEvent: Codable {
			
			// Type is a reserved keyword in Swift, so keep the underscore!!!
			enum Type_: Int, Codable {
				case willSet = 0
				case didSet = 1
				case read = 2
				case write = 3
				
				var description: StaticString {
					switch self {
						case .willSet: "willSet"
						case .didSet: "didSet"
						case .read: "read"
						case .write: "write"
					}
				}
				
			}
			
			let timestamp:Double
			let eventType: MatterEvent.Type_
			let tag: String?
			let nodeID: UInt64
			let endpointID: UInt16
			let clusterID: UInt32
			let attributeType: String
			let attributeValue: Int
			
			init(from decoder: Decoder) throws {
				
				let container = try decoder.container(keyedBy: CodingKeys.self)
				
				self.timestamp = Date().timeIntervalSince1970
				self.eventType = try container.decode(Type_.self, forKey: .eventType)
				self.tag = try container.decodeIfPresent(String.self, forKey: .tag)
				self.nodeID = try container.decode(UInt64.self, forKey: .nodeID)
				self.endpointID = try container.decode(UInt16.self, forKey: .endpointID)
				self.clusterID = try container.decode(UInt32.self, forKey: .clusterID)
				self.attributeType = try container.decode(String.self, forKey: .attributeType)
				self.attributeValue = try container.decode(Int.self, forKey: .attributeValue)
				
			}
			
		}


