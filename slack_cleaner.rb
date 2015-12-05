#! /usr/bin/env ruby

require 'slack'

class SlackCleaner
  def initialize(channels, token, time = 24 * 60 * 60)
    @channels = channels
    @time = time
    Slack.configure do |config|
      config.token = token
    end
  end

  def clean
    channels = Slack.channels_list
    channels['channels'].each do |channel|
      next unless @channels.include?(channel['name'])
      clear_channel(channel)
    end
  end

  private

  def clear_channel(channel)
    start_time = 1
    delete_before = (Time.now - @time).to_i
    loop do
      messages = Slack.channels_history(channel: channel['id'], oldest: start_time, count: 100)
      break if messages.nil? || messages['messages'].empty?
      start_time = messages['messages'][0]['ts'].to_f
      messages['messages'].reverse_each do |msg|
        return if msg['ts'].to_f >= delete_before
        Slack.chat_delete(channel: channel['id'], ts: msg['ts'])
      end
      break unless messages['has_more']
    end
  end
end

SlackCleaner.new(['random'], 'TOKEN').clean
