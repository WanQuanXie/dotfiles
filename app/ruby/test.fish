#!/usr/bin/env fish

include lib/test

set -l GEM_SOURCE (gem sources | tail -n 1)
test "$GEM_SOURCE" = "https://gems.ruby-china.com/"
