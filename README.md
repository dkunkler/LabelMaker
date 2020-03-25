# LabelMaker
Creates labels in any repo. Useful for shared labels across repos.

If label already exists, it let's you know, but it is possible to end up with duplicate colors.

Props to @jssjr for the source. 

Requires a Ruby environment and Octokit

Uses GH_USER and GH_TOKEN for authorized repo access. Works in bash or zsh

## Detailed instructions:

First, choose which shell you plan to run the script from, bash or zsh

From your shell, check if you already have ruby installed:

  `ruby -v`

If you don't have ruby, install:

  `brew install ruby`

  `sudo gem install octokit`.  
  it will ask for your computer password (not github password)

Now that you have ruby, you’ll need to set up certificates so you have permission to add labels to your repos.

Got to https://github.com/settings/security
    -> Developer Settings.  
    -> Personal access tokens.  
    -> Generate new token.  
    -> Add a note so you know how you plan to use this token, e.g. Label Maker.  
        -> *Under Select Scopes, check `repo` box, in order to edit private repos.*  
        -> Generate token.  
COPY THIS TOKEN INFORMATION, so you can access it in the future.

*Note, you will only be able to edit labels in repos for which you have permissions as a contributor.*

To use the newly created token:

	for bash, create or edit the following file:
	/Users/<username>/.bash_profile

	for zsh, create or edit the following file:
	/Users/<username>/.zprofile

in either file, add the following lines:

  `export GH_USER=<username>`
  
  `export GH_TOKEN=<generated token value>`

Clone or download the label-maker.rb script
Edit `label-maker.rb`

configure the LABELS names and colors you want to inject into a repo
Save it

From your shell, navigate to the label-maker.rb directory

`ruby label-maker.rb github/<repo name>`

Repeat for each repo
