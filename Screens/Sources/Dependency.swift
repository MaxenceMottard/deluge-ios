//
//  File.swift
//  Screens
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation
import Workers
import Utils
@preconcurrency import Swinject

private let assembler = Assembler([
    WebWorkersAssembly(),
    UtilsAssembly(),
    RepositoriesAssembly()
])

public let Dependency = assembler.resolver
