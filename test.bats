#!/usr/bin/env bats

@test "-SxDf" {
	rm ./test.json || true
	run dist/cli.js -S 34 -x 3 -D . -f test.json
	[ "$output" = "1" ]
	[ -e "./test.json" ]
}

@test "loop" {
	run dist/cli.js -x 3 -D . -f test.json
	run dist/cli.js -x 3 -D . -f test.json
	run dist/cli.js -x 3 -D . -f test.json
	[ "$output" = "1" ]
	rm ./test.json || true
}

