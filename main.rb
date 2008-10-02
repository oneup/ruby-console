#!/usr/bin/ruby

require "console"

reset

print "hello\n".color :normal, :red, :bg_white

print getCursPos().join(", ")

setCursPos()
print "links oben"
setCursPos(5)
print "5te zeile".color :blink, :red

setCursPos(6, "5te zeile".length)
print "eingerückt"



print "\n"
