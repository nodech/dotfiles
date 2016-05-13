#!/usr/bin/env ruby

DOWNLOAD_FOLDER = "/Users/nod/.ariaDn"

Dir.chdir(DOWNLOAD_FOLDER)

entries = Dir.entries(".")
entries.shift(2)

class DownloadFile
  attr_reader :percent, :speed, :eta, :downloading

  def initialize(file)
    @file = file
    last_lines = `tail -n 5 #{file}`

    if last_lines =~ /Status Legend/ then
      delete
      return
    end

    lines = last_lines.split(/\n/)

    if /\[[^\(]*\((?<percent>[0-9]{1,3}%).*DL:(?<speed>[^ ]*).*ETA:(?<eta>.*)\]/ =~ lines[1] then
      @percent = percent
      @speed = speed
      @eta = eta

      @downloading = true
    end
  end

  def delete
    @downloading = false
    `rm #{@file}`
  end

  def to_s
    "#{@percent} #{@speed}, #{@eta}"
  end

  #def folder
end

def parse_percent(file)
  downloadingFile = DownloadFile.new file

  return downloadingFile
end

downloading = entries.map do |file|
  parse_percent file
end

list = downloading.select { |progress| progress.downloading }.shuffle

puts "-" if list.length == 0
list.each do |file| puts file end
