//
//  PlatformSupport.swift
//  Game
//
//  Created by Nicolás Miari on 2020/05/09.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
typealias Color = NSColor
#endif

#if os(iOS)
import UIKit
typealias Color = UIColor
#endif
