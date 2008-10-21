#!/usr/bin/ruby1.9
#-*- coding: UTF-8 -*-

if __FILE__ == $0
  puts "This is a module, don't run it from the command line."
  exit
end

class String
  def color(*arg)                         # colorize a string
    Console.color(arg) +
    self +
    Console.color(:default)
  end
  def printAt(*arg)
    row = 0
    col = 0
    if not arg.is_a?(Array)
      arg = [arg]
    end
    if arg.length > 0
      row = arg[0]
    end
    if arg.length > 1
      col = arg[1]
    end
    Cursor.save
    Cursor.position = row, col
    print self
    Cursor.restore
  end
end

class Console
  def self.clear           # reset the terminal
    print "\ec"       # *42*
  end
  
  def self.color(*arg)                         # colorize a string
    if arg[0].is_a?(Array)
      arg = arg[0]
    end
    if arg.length == 0
      arg = :default, :red, :bg_default
    end
    attribute = {         # mapper for the attributes
      :normal     => 0,
      :bright     => 1,
      :dim        => 2,
      :underscore => 4,
      :blink      => 5,
      :reverse    => 7,
      :hidden     => 8,
      :default    => 0
    }
    fg_color = {          # mapper for the foreground color
      :black   => 30,
      :red     => 31,
      :green   => 32,
      :yellow  => 33,
      :blue    => 34,
      :magenta => 35,
      :cyan    => 36,
      :white   => 37,
      :default => 39
    }
    bg_color = {          # mapper for the background color
      :bg_black   => 40,
      :bg_red     => 41,
      :bg_green   => 42,
      :bg_yellow  => 43,
      :bg_blue    => 44,
      :bg_magenta => 45,
      :bg_cyan    => 46,
      :bg_white   => 47,
      :bg_default => 49
    }
    if arg.length > 0                 # turn symbols into numbers
      arg[0] = attribute[arg[0]]      # attributes
    end
    if arg.length > 1
      arg[1] = fg_color[arg[1]]       # foreground color
    end
    if arg.length > 2
      arg[2] = bg_color[arg[2]]       # background color
    end
    "\e[#{arg.join(";")}m"   # magic ansi escape sequence
  end

  def self.color=(arg)
    if not arg.is_a?(Array)
      arg = [arg]
    end
    if arg.length == 0
      arg = :default, :red, :bg_default
    end
    print self.color arg
  end

  def self.width
    `tput cols`.chomp.to_i
  end

  def self.height
    `tput lines`.chomp.to_i
  end
end

class Cursor
  def self.position
    row = ""
    col = ""
    c = ""

    termsettings = `stty -g`
    system("stty raw -echo")
    print "\e[6n"
    while (c = STDIN.getc.chr) != ";"
      if c == "\e" or c == "["
        next
      else
        row += c
      end
    end
    while (c = STDIN.getc.chr) != "R"
      col += c
    end
    system("stty #{termsettings}")

    [row, col]
  end

  def self.position=(arg)
    row = 0
    col = 0
    if not arg.is_a?(Array)
      arg = [arg]
    end
    if arg.length > 0
      row = arg[0]
    end
    if arg.length > 1
      col = arg[1]
    end
    print "\e[" + row.to_s + ";" + col.to_s + "H"
  end

  def self.up(*arg)
    if arg.length == 0
      arg[0] == 1
    end
    print "\e[#{arg[0]}A"
  end

  def self.down(*arg)
    if arg.length == 0
      arg[0] == 1
    end
    print "\e[#{arg[0]}B"
  end

  def self.right(*arg)
    if arg.length == 0
      arg[0] == 1
    end
    print "\e[#{arg[0]}C"
  end

  def self.left(*arg)
    if arg.length == 0
      arg[0] == 1
    end
    print "\e[#{arg[0]}D"
  end

  def self.save
    print "\e7"
  end

  def self.restore
    print "\e8"
  end
end

class Win
  def initialize
    @row = 1
    @col = 1
    @width = 10
    @height = 5
    @text = ""
    @border = true
    @fg = :default
    @bg = :bg_default
    @bordercolor = :default
  end

  def width=(width)
    @width = width
  end

  def width
    @width
  end

  def height=(height)
    @height = height
  end

  def height
    @height
  end

  def text=(text)
    @text = text
  end

  def text
    @text
  end

  def border=(border)
    if border == :none
      @border = false
      return
    end
    @border = true
    @bordercolor = border
  end

  def border
    @border
  end

  def position=(arg)
    if not arg.is_a?(Array)
      arg = [arg]
    end
    if arg.length > 0
      @row = arg[0]
    end
    if arg.length > 1
      @col = arg[1]
    end
  end

  def position
    [@row, @col]
  end

  def fg=(fg)
    @fg = fg
  end

  def fg
    @fg
  end

  def bg=(bg)
    @bg = bg
  end

  def bg
    @bg
  end

  def drawBorder
#    system('tput smacs')
    ("\u250C" + "\u2500" * (@width - 2) + "\u2510").color(:normal, @bordercolor, @bg).printAt @row, @col
    ("\u2514" + "\u2500" * (@width - 2) + "\u2518").color(:normal, @bordercolor, @bg).printAt @row + @height - 1, @col
    0.upto(@height - 3) do |i|
      ("\u2502" + " " * (@width - 2) + "\u2502").color(:normal, @bordercolor, @bg).printAt @row + i + 1, @col
    end
#    system('tput rmacs')
  end

  def draw
    text = @text.split("\n")
    0.upto(text.length - 1) do |i|
      if @border == true
        text[i] = text[i][0, @width - 2]
      else
        text[i] = text[i][0, @width]
      end
    end
    if @border == false
      0.upto((text.length > @height ? @height : text.length) - 1) do |i|
        text[i].color(:normal, @fg, @bg).printAt @row + i , @col
      end
    else
      drawBorder
      0.upto(@text.length > @height - 3 ? @height - 3 : text.length) do |i|
        text[i].to_s.color(:normal, @fg, @bg).printAt @row + i + 1, @col + 1
      end
    end
  end
end
