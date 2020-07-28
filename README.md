# LabelMaker
Creates labels in a repo. Useful for shared labels across repos.

Takes labels from a YAML file and adds them to a designated repo.

If label already exists, it asks if you want to replace the old label or not.

Props to @jssjr for the source. 

Requires a Ruby environment, Octokit, and dotenv

Uses GH_USER and GH_TOKEN for authorized repo access. Works in bash or zsh

Your token must have appropriate permissions, and you must have contributor access to the repo in which you plan to add labels.

## Detailed instructions:

First, choose which shell you plan to run the script from, bash or zsh

From your shell, check if you already have ruby installed:

  `ruby -v`

If you don't have ruby, install:

  `brew install ruby`
  or
  `sudo apt install ruby`


If you don't have octokit, install:   
  `sudo gem install octokit`    
(it will ask for your computer password, not GitHub password)

If you don't already have dotenv, install:  
  `sudo gem install dotenv`

Now that you have ruby, you’ll need to set up certificates so the script will have permission to add labels to your repos.

Go to https://github.com/settings/security
  * Developer Settings.  
  * Personal access tokens.  
  * Generate new token.  
    * Add a note so you know how you plan to use this token, e.g. Label Maker.  
    * **Under Select Scopes, check `repo` box, in order to edit private repos.**  
  * Generate token.  
COPY THE GENERATED TOKEN, so you can access it below, and in the future.

**Note, you will only be able to edit labels in repos for which you have permissions as a contributor.**

To use the newly created token:

	for bash, create or edit the following file:
	/Users/<username>/.bash_profile

	for zsh, create or edit the following file:
	/Users/<username>/.zprofile

in either file, add the following lines:

  `export GH_USER=<username>`
  
  `export GH_TOKEN=<generated token value>`

Clone or download the label-maker.rb script.  
Edit `label-maker.rb`

[TODO]  
* Update syntax to note write source repo labels into a yaml file
* Update syntax for reading yaml file into target repo labels 

From your shell, navigate to the label-maker.rb directory

`ruby label-maker.rb github/<repo name>`
or  
`ruby label-maker.rb <username>/<repo name>`

Repeat for each repo
1
