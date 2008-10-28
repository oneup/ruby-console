# TODO
# put @things in bukket
# label @things
# set status (working, maybe, etc)
# get list of things
# rank list

class Array
  def first
    self[0]
  end

  def rest # TODO: i think this exists somewhere, but was too lazy to search so i built it myself bla bla bla
    self[1..self.length]
  end
end

class String
  def yml
    yaml = YAML.load_file(self + ".yml")
    if yaml == false
      return nil
    else
      return yaml
    end
  end
end

#require "console"
# require "../pixel_people/PuitUniverse/from_future_import.rb"
require "yaml"

`touch bukket.yml`
bukket = {
  'name' => 'anonymous'
}.merge("bukket".yml || {})

todo = []

puts "hello #{bukket["name"]}"

cmd = "huh? #"
while cmd != "exit"
  cmd = gets.strip
  if cmd.include? " "
    words = cmd.split(" ")
    bukket[words.first] = words.rest
  else
    puts bukket[cmd]
  end
end

puts "TODO: SAVE TO YAML FILE"
