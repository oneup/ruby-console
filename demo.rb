#!/usr/bin/ruby1.9
#-*- coding: UTF-8 -*-

require "console"

Console.clear

textbox = Win.new
textbox.position = 1, 1
textbox.width = Console.width
textbox.height = Console.height - 1
textbox.text = `ls`
textbox.draw

Cursor.position = Console.height

