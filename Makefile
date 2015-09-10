all: src/SwiftPlusPlusiOSLib.swift src/SwiftPlusPlusOSXLib.swift

src/SwiftPlusPlusiOSLib.swift: SwiftPlusPlus/*.swift
	@mkdir -p src
	@find SwiftPlusPlus -path SwiftPlusPlus/OSX -prune -o -name '*.swift' -exec cat {} \; -exec echo \; -exec echo \; > src/SwiftPlusPlusiOSLib.swift

src/SwiftPlusPlusOSXLib.swift: SwiftPlusPlus/*.swift
	@mkdir -p src
	@find SwiftPlusPlus -path SwiftPlusPlus/iOS -prune -o -name '*.swift' -exec cat {} \; -exec echo \; -exec echo \; > src/SwiftPlusPlusOSXLib.swift

clean:
	@rm -rf src/
