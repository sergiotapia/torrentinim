deps:
	@nimble install -y --verbose

run:
	@nimble run torrentinim

build:
	@nimble build -Y -d:ssl --threads:on --opt:size \
		-d:release --verbose src/torrentinim.nim torrentinim

test:
	@testament --targets:c cat .
	@find tests/ -type f ! -name "*.nim" -exec rm {} \;