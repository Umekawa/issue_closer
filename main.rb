# frozen_string_literal: true

require 'octokit'
require 'dotenv'

Dotenv.load

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

per_page = ENV['PER_PAGE'] || 30

search_result = nil
while search_result.nil? || search_result.items.size.positive?
  search_result = client.search_issues("repo:#{ENV['GITHUB_ID']}/#{ENV['REPOSITORY_NAME']} #{ENV['SEARCH_QUERY']}",
                                       page: 1, per_page:)
  search_result.items.each do |issue|
    client.close_issue("#{ENV['GITHUB_ID']}/#{ENV['REPOSITORY_NAME']}", issue.number)
    puts "#{issue.title} (Issue ##{issue.number}) has been closed."
    sleep 1
  end
  sleep 1
end
