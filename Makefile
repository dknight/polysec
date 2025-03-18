default: test lint


test:
	laura .

lint:
	luacheck src/ test/

.PHONY: lint test 

