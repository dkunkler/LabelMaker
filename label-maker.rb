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

LABELS.each do |name, details|
  if labels.select {|l| l.name.downcase==name.downcase}.empty?
    #puts "Adding #{name} (\##{color})"
    puts "Adding \e[1m#{name}\e[22m to \e[1m#{repo}\e[22m" 
    puts "  \e[1mColor\e[22m: \##{details["color"]}"
    puts "  \e[1mDescription\e[22m #{details["description"]}"
    client.add_label(repo, name, details["color"], options = {"description" => details["description"]} )
  else
    label = client.label(repo,name)
    puts "\e[1m#{name}\e[22m already exists"
    puts " \e[31m---current values---\e[0m "
    puts "  \e[31mColor\e[0m: \##{label.color}"
    puts "  \e[31mDescription\e[0m: #{label.description}"
    puts " \e[32m---new values---\e[0m "
    puts "  \e[32mColor\e[0m: \##{details["color"]}"
    puts "  \e[32mDescription\e[0m #{details["description"]}"
    foundAnswer = false
    while not foundAnswer do
      puts "Would you like to replace? y/n"
      answer = $stdin.gets
      answer = answer.chomp
      if answer == 'n'
        puts "Skipping \e[1m#{name}\e[22m"
        break
      elsif answer == "y"
        puts "Replacing \e[1m#{name}\e[22m in \e[1m#{repo}\e[22m"
        client.delete_label!(repo,name)
        client.add_label(repo, name, details["color"], options = {"description" => details["description"]} )
        puts ""
        break
      end
    end
    puts ""
    
  end
end
