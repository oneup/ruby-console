#!/usr/bin/ruby1.9
#-*- coding: UTF-8 -*- 

require "console"

Console.clear

Cursor.down
puts "hello\n".color :blink, :red, :bg_white

print Cursor.position.join(", ")

Cursor.position = nil
print "links oben"

Cursor.position = 5
"5te zeile".color :blink, :red

Cursor.position = 6,4
print "eingerückt"

print "\n\n"

puts "lol"
Console.color = :normal, :green, :bg_white

print "grün"

Console.color = :default

print "normal"

Cursor.up 4
print "lol"

textbox = Win.new
textbox.position = 12, 10
textbox.width = 15
textbox.height = 5
textbox.text = `ls`
textbox.border = :single, :red
textbox.bg = :bg_black
textbox.fg = :yellow
textbox.draw


Cursor.position = 18
print "\n"

