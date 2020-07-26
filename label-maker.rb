 #!/usr/bin/env ruby
require "yaml"
require "octokit"
require "dotenv"
require "yaml"
Dotenv.load
LABELS = YAML.load(File.read("labels.yml"))

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
p stuff
LABELS.each do |name, details|
  if labels.select {|l| l.name.downcase==name.downcase}.empty?
    #puts "Adding #{name} (\##{color})"
    puts "Adding #{name} with color \##{details["color"]} and description #{details["description"]}"
    client.add_label(repo, name, details["color"], options = {"description" => details["description"]} )
  else
    puts "Skipping #{name} already exists"
  end
end
