 #!/usr/bin/env ruby
require "yaml"
require "octokit"
require "dotenv"
require "yaml"
Dotenv.load


client ||= Octokit::Client.new(
  :login        => ENV.fetch("GH_USER", ENV["USER"]),
  :access_token => ENV["GH_TOKEN"],
)

method = ARGV[0]
unless method
  raise StandardError.new "Please provide an action to perform! -a for add or -w for write"
end

REPO = ARGV[1]
unless REPO
  raise StandardError.new "Please provide a repo name! github/<repo name> or <user name/<repo name>"
end

fn = ARGV[2]
unless fn
  fn = "labels.yml"
  puts "No file name specified. File name has been defaulted to \"labels.yml\""
end
FILENAME = fn
LABELS = YAML.load(File.read(FILENAME))

#string compare <==> is case sensitive, but you cannot add labels that differ
#only by case. Must use case insensitive compare, or will error when
#adding "Blocked" label to a repo that already has "blocked" label.

def addLabelsToRepo(labels, repo, client)
  begin
  repoLabels = client.labels(repo)
  repoColors = []
  repoLabels.each do |name|
    repoColors << name.color
  end
  labels.each do |name, details|
    if repoLabels.select {|l| l.name.downcase==name.downcase}.empty?
      #puts "Adding #{name} (\##{color})"
      puts "Adding \e[1m#{name}\e[22m to \e[1m#{repo}\e[22m" 
      puts "  \e[1mColor\e[22m: \##{details["color"]}"
      puts "  \e[1mDescription\e[22m #{details["description"]}"
      if repoColors.include? details["color"]
        puts "\e[35mWARNING: Color #{details["color"]} already exists in repo\e[0m"
      end
      repoColors << details["color"].to_i
      client.add_label(repo, name, details["color"], options = {"description" => details["description"]} )
    else
      label = client.label(repo,name)
      puts ""
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
          repoColors.pop(details["color"].to_i)
          if repoColors.include? details["color"]
            puts "\e[35mWARNING: Color #{details["color"]} already exists in repo \e[0m"
          end
          repoColors << details["color"].to_i
          client.add_label(repo, name, details["color"], options = {"description" => details["description"]} )
          
          break
        end
      end
      puts ""
    end
  end
  rescue StandardError => bang
    puts ""
    puts "\e[31m#{bang}\e[0m"
    puts ""
    puts "\e[31mError:\e[0m Please check your permissions"
  end
end

def repoLabelsToYAML(repo, client, fileName)
  labels = client.labels(repo)
  labelHash = {}
  labels.each do |label|
    sub = {}
    sub["color"] = label.color
    sub["description"] = label.description
    labelHash[label.name] = sub
  end
  File.open(fileName, "w") { |file| file.write(labelHash.to_yaml) }
end


if method == "-a"
  addLabelsToRepo(LABELS, REPO, client)
elsif method == "-w"
  repoLabelsToYAML(REPO, client, FILENAME)
end
