# frozen_string_literal: true
require 'rake_performance'
namespace :users do

  desc 'Assign wallets to users.'
  task assign_wallet: :environment do
    counter = 0
    users = User.where(admin: false)

    users.all.each do |u|
      unless u.wallet.present?
        Wallet.create(balance: 0, user_id: u.id)
        counter += 1
      end
    end

    puts '=== Successfully run wallet assignment task. ==='
    puts "Total #{counter} times."
  end

end