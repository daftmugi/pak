#!/usr/bin/env ruby

Dir.chdir(File.expand_path("..", __FILE__))

load "../bin/pak"

$0 = "pak"
pak = PAK.new
template = File.read("README.template.md")

pak_usage = pak.usage.lines[2..].join("").chomp()
find_duplicates_usage = pak.find_duplicates_usage.chomp()

usage = "```\n#{pak_usage}\n```"
find_duplicates_usage = "```\n#{find_duplicates_usage}\n```"

template.sub!("`USAGE_BLOCK`", usage)
template.sub!("`FIND_DUPLICATES_USAGE_BLOCK`", find_duplicates_usage)

puts(template)
