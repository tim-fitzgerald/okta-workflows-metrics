# frozen_string_literal: true

$LOAD_PATH.unshift("/var/task/vendor/cache")
require "json"

require "datadog_api_client"

def lambda_handler(event:, context:)
  begin
    check_origin_signature_key(event["headers"]["x-signature-key"])

    event = JSON.parse(event["body"])

    metric_name = parse_event_type(event)
    workflow_name = event["flow_name"]

    message = datadog_submit_metric(metric_name, workflow_name)
    body = JSON.generate({ message: message.to_s })

    { statusCode: 200, body: body }
  rescue StandardError => e
    # Log the error for debugging
    puts "Error processing event: #{e.message}" 
    puts e.backtrace.join("\n") 

    # Return an error response
    { statusCode: 500, body: JSON.generate({ message: "Error processing event: #{e.message}" }) } 
  end
end

def check_origin_signature_key(signature_key)
  if signature_key != ENV.fetch("SIGNATURE_KEY", nil)
    return { statusCode: 401, body: "Unauthorized: Origin signature key does not match." }
  end
end

def datadog_client
  DatadogAPIClient.configure do |config|
    config.api_key = ENV.fetch("DATADOG_API_KEY", nil)
  end
  DatadogAPIClient::V2::MetricsAPI.new
end

def datadog_metric_body(metric_name, workflow_name)
  DatadogAPIClient::V2::MetricPayload.new({
    series: [
      {
        metric: metric_name,
        type: DatadogAPIClient::V2::MetricIntakeType::GAUGE,
        points: [
          DatadogAPIClient::V2::MetricPoint.new({
            timestamp: Time.now.to_i,
            value: 1,
          }),
        ],
        tags: [
          "workflow:#{workflow_name}",
          "version:1.0",
        ],
      },
    ],
  })
end

def datadog_submit_metric(metric_name, workflow_name)
  puts "Submitting metric to Datadog: #{metric_name}"
  body = datadog_metric_body(metric_name, workflow_name)
  datadog_client.submit_metrics(body)
end

def parse_event_type(event)
  "okta.workflows.#{event["event_type"].downcase}"
end

