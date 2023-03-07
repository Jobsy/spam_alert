
# Load environment variables from .env file
require 'dotenv/load'

# Load constant values from separate file
require_relative '../../config/constants/constants'

class PayloadsController < ApplicationController
  # Skip CSRF token verification for create action
  skip_before_action :verify_authenticity_token, only: :create

  def create
    # Extract payload params from request params
    payload_params = payload_params(params)

    # Validate payload params
    if valid_payload?(payload_params)
      # If payload is a spam notification, send message to Slack
      case payload_params[:Type]
      when "SpamNotification"
        send_slack_message(payload_params)
      # If payload is a hard bounce, return success response without processing further
      when "HardBounce"
        render json: { status: "success", message: "Payload processed successfully" }, status: :ok
      end
    else
      # If payload is invalid, return error response
      render json: { error: "Invalid payload" }, status: :unprocessable_entity
    end
  rescue JSON::ParserError => e
    # If payload is not valid JSON, return error response
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end

  private

  # Strong parameters for payload
  def payload_params(params)
    params.require(:payload).permit(ALLOWED_KEYS)
  end

  # Validate payload against allowed keys
  def valid_payload?(payload)
    payload.keys.sort == ALLOWED_KEYS.sort
  end

  # Send Slack message with formatted payload
  def send_slack_message(payload)
    message = SlackMessage.new(payload).build_message
    SlackWebhook.new(ENV["SLACK_WEBHOOK_URL"]).send_message(message)
    render json: { status: "success", message: "Payload processed successfully" }, status: :ok
  end
end

# SlackWebhook class for sending messages to Slack API
class SlackWebhook
  def initialize(webhook_url)
    @webhook_url = webhook_url
  end

  # Send message to Slack API
  def send_message(payload)
    HTTParty.post(@webhook_url, body: payload.to_json, headers: { 'Content-Type' => 'application/json' })
  rescue HTTParty::Error => e
    # If HTTParty error occurs, log error message
    puts "An HTTParty error occurred: #{e.message}"
  rescue StandardError => e
    # If any other error occurs, log error message
    puts "An error occurred: #{e.message}"
  end
end

# SlackMessage class for formatting payload into Slack message blocks
class SlackMessage
  def initialize(payload)
    @payload = payload
  end

  # Build Slack message blocks from payload
  def build_message
    {
      "blocks": [
        header_block,
        section_block(*["Type:", "Name:"].zip([@payload[:Type], @payload[:Name]]).flatten),
        section_block(*["When:", "Spammer Email:"].zip([@payload[:BouncedAt], @payload[:Email]]).flatten),
        section_block(*["Description:"].zip([@payload[:Description]]).flatten),
      ]
    }
  end

  private

  # Header block for Slack message
  def header_block
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "New Spam",
        "emoji": true
      }
    }
  end

  # Section block for Slack message with label-value pairs
  def section_block(*label_value_pairs)
    fields = label_value_pairs.each_slice(2).map do |label, value|
      {
        "type": "mrkdwn",
        "text": "*#{label}*\n #{value}"
      }
    end
    
      {
        "type": "section",
        "fields": fields
      }
  end

end
