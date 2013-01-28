Given /^I have a protected directory named "(.*?)" with password "(.*?)"$/ do |vol_name, password|
  @password = password
  step "I run `coy create #{vol_name} --password #{password}`"
end

Given /^protected directory "(.*?)" is open$/ do |vol_name|
  step "I run `truecrypt .coy/#{vol_name}.tc --password=#@password #{vol_name}`"
  step "a directory named \"#{vol_name}\" should exist"
end

Then /^let's cleanup "(.*?)"$/ do |vol_name|
  step "I run `truecrypt -d .coy/#{vol_name}.tc`"
end
