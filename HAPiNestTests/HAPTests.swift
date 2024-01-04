//
//  HAPTests.swift
//  HAPTests
//
//  Created by Jan Verrept on 04/08/2021.
//  Copyright © 2021 Jan Verrept. All rights reserved.
//
import Foundation
import HAP
import XCTest
import JVSwift

class HAPtests: XCTestCase {
	
	func testHAPSupportFolder() throws {
		
		let hapSupportFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/Library/Application Support/HAP")
		var isFolder:ObjCBool = false
		let supportFolderExists = FileManager.default.fileExists(atPath: hapSupportFolder.path, isDirectory: &isFolder) && isFolder.boolValue
		XCTAssertTrue(supportFolderExists)
		
	}
	
	func testHAPconfigFile() throws {
		
		let hapSupportFolder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/Library/Application Support/HAP")
		let configFile = hapSupportFolder.appendingPathComponent("configuration.json")
		let hapStorage = FileStorage(filename: configFile.path)
		let configData = try hapStorage.read()
		XCTAssertNotEqual(configData.count, 0)
		
	}
	
}
