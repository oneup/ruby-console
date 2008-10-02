#!/usr/bin/ruby

require "console"

Console.clear



"hello\n".color :normal, :red, :bg_white # prints automatically good!?

print Cursor.position.join(", ")

Cursor.position = nil
print "links oben"

Cursor.position = 5
"5te zeile".color :blink, :red

Cursor.position = (6, "5te zeile".length)
Cursor.position = 6,4
print "eingerückt"

print "\n\n"

puts "lol"
green = Console.color = :normal, :green, :bg_white

print "grün"

Console.color = :default

print "normal"

print "\n"
