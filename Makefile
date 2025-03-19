default: test lint

test:
	laura test/

lint:
	luacheck src/ test/

.PHONY: lint test 

