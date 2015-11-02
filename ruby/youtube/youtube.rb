#to run this, simply add your developer key (I removed mine) and add the term you would like to search as an additional argument when running the file. For example, if you wanted to search for 'cute cats', you would type 'ruby youtube.rb cute cats'. The search will run and the first 3 videos will be displayed in the terminal.


require 'rubygems'
gem 'google-api-client'
require 'google/api_client'

#NOTE: Key must be supplied on line below to run properly.
#DEVELOPER_KEY = >>ENTER_KEY_HERE<<
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'

def get_service
  client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0'
  )
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  return client, youtube
end

def run
  search_term = ARGV.join(' ')
  puts "Searching for #{search_term}..."
  max_results = 3

  client, youtube = get_service

  begin
    response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :q => search_term,
        :type => 'video',
        :maxResults => max_results
      }
    )

    results = []

    response.data.items.each do |result|
      results << [result.snippet.title, result.id.videoId]
    end

    puts "Search Results:\n"
    results.each do |result|
      puts "VIDEO: #{result[0]}"
      puts "URL: https://www.youtube.com/watch?v=#{result[1]}"
      puts
    end

  rescue Google::APIClient::TransmissionError => e
    puts e.result.body
  end
end

run