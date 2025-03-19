default: test lint

test:
	laura --nocoverage test/

lint:
	luacheck src/ test/

.PHONY: lint test 

