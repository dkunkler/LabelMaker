#!/usr/bin/env ruby
require "yaml"
require "octokit"
require "dotenv"
Dotenv.load

LABELS = {
  "1-WIP"       => "ffe6c9",
  "2-WIP"       => "ffe6c9",
  "3-WIP"       => "ffe6c9",
  "4-WIP"       => "ffe6c9",
  "5-WIP"       => "ffe6c9",
  "Blocked"     => "f46164",
  "Chaos"       => "95def4",
  "Compute Foundation" => "e7c0f9",
  "Data Infrastructure" => "e99695",
  "Data Pilelines" => "b2ffc5",
  "Database Infrastructure" => "72f957",
  "Git Systems Protocols" => "fcf56f",
  "Git Systems Storage" => "cccc00",
  "Git Core" => "ee8800",
  "Observability" => "cce0ff",
  "Physical Infrastructure" => "713dbf",
  "SRE-Americas" => "80b3ff",
  "SRE-EMEA" => "0066ff",
  "Status: Green" => "00cc00",
  "Status: Red" => "ff0000",
  "Status: Yellow" => "ffff00"

}

client ||= Octokit::Client.new(
  :login        => ENV.fetch("GH_USER", ENV["USER"]),
  :access_token => ENV["GH_TOKEN"],
)

repo = ARGV[0]
unless repo
  raise StandardError.new "Please provide a repo name! github/<repo name> or <user name/<repo name>"
end

#string compare <==> is case sensitive, but you cannot add labels that differ
#only by case. Must use case insensitive compare, or will error when
#adding "Blocked" label to a repo that already has "blocked" label.

labels = client.labels(repo)
LABELS.each do |name, color|
  if labels.select {|l| l.name.downcase==name.downcase}.empty?
    puts "Adding #{name} (\##{color})"
    client.add_label(repo, name, color)
  else
    puts "Skipping #{name} already exists"
  end
end
