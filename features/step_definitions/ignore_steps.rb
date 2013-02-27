Given /I have an appropriate \.gitignore file/ do
  step "a file named \".gitignore\" with:", ".coy\nfoo\nbar\nsecret"
end

Given /^the current directory is a (.*?) repo$/ do |vcs|
  repo_dir = {'git' => '.git', 'mercurial' => '.hg', 'svn' => '.svn'}[vcs.downcase]
  step "a directory named \"#{repo_dir}\""
end

Given /^a ([^ ]+) with:$/ do |ignore_file, string|
  step "a file named \"#{ignore_file}\" with:", string
end

Given /^we ignore coy with (.*?)$/ do |vcs|
  ignore_file = {:git => '.gitignore', :hg => '.hgignore', :svn => '.svnignore'}[vcs.downcase.to_sym]
  step "a file named \"#{ignore_file}\" with:", ".coy\n"
end
