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
textbox.border = :double, :white
textbox.bg = :bg_black
textbox.fg = :yellow
textbox.draw

network = Win.new
network.width = Console.width / 2
network.height = Console.height - 1
network.position = 0, Console.width - network.width
network.border = :round, :red
network.bg = :bg_white
network.fg = :yellow
network.text = `/sbin/ifconfig`
network.draw


Cursor.position = Console.height - 2
print "\n"

