test "String#split on an unqualified", ->
  ok 'a/b/c'.split('/').length is 3

test "String#split on a qualified", ->
  split = '/a/b/c'.split('/')
  ok split.length is 4
  ok split[0] is ""

test "String#split on root", ->
  split = '/'.split('/')
  ok split.length is 2
  ok split[0] is ""
  ok split[1] is ""

test "String#split on self", ->
  split = '.'.split('/')
  ok split.length is 1
  ok split[0] is "."
