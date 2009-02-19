#!/usr/bin/env ruby
#-*- coding: UTF-8 -*-

require "console"

Console.clear()
$is_ascii = false

filelist = Win.new()
playlist = Win.new()

while 1:

    filelist.text = Dir.entries(Dir.pwd).join("\n")
    filelist.width = Console.width / 2
    filelist.height  = Console.height
    filelist.position = 0, 0
    playlist.width = Console.width - filelist.width
    playlist.height = Console.height
    playlist.position = 0, filelist.width
    filelist.draw()
    playlist.draw()
    Cursor.position = 0, 0
    sleep 0.5
end

