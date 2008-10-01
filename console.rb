#!/usr/bin/ruby

class String
  def color(*arg)
    if arg.length == 0
      arg = [:normal, :red]
    end
    attribute = {
      :normal     => 0,
      :bright     => 1,
      :dim        => 2,
      :underscore => 4,
      :blink      => 5,
      :reverse    => 7,
      :hidden     => 8
    }
    fg_color = {
      :black   => 30,
      :red     => 31,
      :green   => 32,
      :yellow  => 33,
      :blue    => 34,
      :magenta => 35,
      :cyan    => 36,
      :white   => 37
    }
    bg_color = {
      :bg_black   => 40,
      :bg_red     => 41,
      :bg_green   => 42,
      :bg_yellow  => 43,
      :bg_blue    => 44,
      :bg_magenta => 45,
      :bg_cyan    => 46,
      :bg_white   => 47
    }
    if arg.length > 0
      arg[0] = attribute[arg[0]]
    end
    if arg.length > 1
      arg[1] = fg_color[arg[1]]
    end
    if arg.length > 2
      arg[2] = bg_color[arg[2]]
    end
    "\e[" + arg.join(";") + "m" + self + "\e[0m"
  end
end

def reset
  puts "\ec"
end


