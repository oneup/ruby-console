#!/usr/bin/ruby

require "console"

Console.clear

print "hello\n".color :normal, :red, :bg_white

print Cursor.position.join(", ")

Cursor.position = nil
print "links oben"

Cursor.position = 5
print "5te zeile".color :blink, :red

#Cursor.position = (6, "5te zeile".length)
Cursor.position = 6,4
print "eingerückt"

Console.color = :normal, :green, :bg_white
print "ab jetzt grün"

print "lol"

Console.color = :default

print "normal"

print "\n"
