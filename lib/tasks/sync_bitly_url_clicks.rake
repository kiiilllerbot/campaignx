namespace :campaigns do

  desc 'Sync bitly url clicks'
  task sync_url_clicks: :environment do
    # Past 3 months campaigns
    @campaigns = Campaign.last_three_months

    @campaigns.each do |c|
      if c.short_url.present?
        token = ENV["BITLY_API_TOKEN"]
        query = {
          "unit"     => "day",
          "units"     => -1,
        }

        headers = {
          "Authorization" => "Bearer #{token}"
        }
          
        url = c.short_url
        u = url.split('/')[-1]

        res = HTTParty.get(
          "https://api-ssl.bitly.com/v4/bitlinks/bit.ly/#{u}/clicks/summary", 
          :query => query,
          :headers => headers
        )

        c.update(clicks: res["total_clicks"])

      end
    end
    p "============= SUCCESFULLY SYNCED WITH BITLY ================"
  end

end
