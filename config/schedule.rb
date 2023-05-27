set :output, {:standard=>'log/cron_log.log',:error=>'log/cron_error_log.log'}
Tz="Asia/Kuala_Lumpur"

every :day, at: '10:45am' do 
  rake 'campaigns:sync_url_clicks'    
end