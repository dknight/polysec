default: test lint coverage

test:
	laura --nocoverage test/

coverage:
	laura test

lint:
	luacheck src/ test/

.PHONY: lint test coverage

