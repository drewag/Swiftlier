src/SwiftPlusPlusLib.swift: SwiftPlusPlus/*.swift
	@mkdir -p src
	@find SwiftPlusPlus -name '*.swift' -exec cat {} \; -exec echo \; -exec echo \; > src/SwiftPlusPlusLib.swift
