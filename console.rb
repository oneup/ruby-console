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

    [row.to_i - 1, col.to_i - 1]
  end

  def self.position=(arg)
    row = 0
    col = 0
    if not arg.is_a?(Array)
      arg = [arg]
    end
    if arg.length > 0
      row = arg[0].to_i + 1
    end
    if arg.length > 1
      col = arg[1].to_i + 1
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
    @border = :single
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

  def border=(arg)
    if not arg.is_a?(Array)
      arg = [arg]
    end
    if arg.length > 0
      @border = arg[0]
    end
    if arg.length > 1
      @bordercolor = arg[1]
    end
  end

  def border
    [@border, @bordercolor]
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
    single = {
      :upper_left  => "\u250C",
      :upper_right => "\u2510",
      :lower_left  => "\u2514",
      :lower_right => "\u2518",
      :horizontal  => "\u2500",
      :vertical    => "\u2502"
    }
    bold = {
      :upper_left  => "\u250D",
      :upper_right => "\u2511",
      :lower_left  => "\u2515",
      :lower_right => "\u2519",
      :horizontal  => "\u2501",
      :vertical    => "\u2503"
    }
    double = {
      :upper_left  => "\u2554",
      :upper_right => "\u2557",
      :lower_left  => "\u255A",
      :lower_right => "\u255D",
      :horizontal  => "\u2550",
      :vertical    => "\u2551"
    }
    round = {
      :upper_left  => "\u256D",
      :upper_right => "\u256E",
      :lower_left  => "\u2570",
      :lower_right => "\u256F",
      :horizontal  => "\u2500",
      :vertical    => "\u2502"
    }
    mapper = case @border
      when :single then single
      when :bold   then bold
      when :double then double
      when :round  then round
      else single
    end
    (mapper[:upper_left] + mapper[:horizontal] * (@width - 2) + mapper[:upper_right]).color(:normal, @bordercolor, @bg).printAt @row, @col
    (mapper[:lower_left] + mapper[:horizontal] * (@width - 2) + mapper[:lower_right]).color(:normal, @bordercolor, @bg).printAt @row + @height - 1, @col
    0.upto(@height - 3) do |i|
      (mapper[:vertical] + " " * (@width - 2) + mapper[:vertical]).color(:normal, @bordercolor, @bg).printAt @row + i + 1, @col
    end
  end

  def draw
    text = @text.split("\n")
    0.upto(text.length - 1) do |i|
      if @border != :none
        text[i] = text[i][0, @width - 2]
      else
        text[i] = text[i][0, @width]
      end
    end
    if @border == :none
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
