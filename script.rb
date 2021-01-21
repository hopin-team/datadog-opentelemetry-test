require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/exporter/jaeger'

# Configure the sdk with custom export
OpenTelemetry::SDK.configure do |c|
  if ENV['OTLP'] == 'true'
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
        OpenTelemetry::Exporter::OTLP::Exporter.new(
          endpoint: '127.0.0.1:55681/v1/trace',
          insecure: true
        )
      )
    )
  else
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
        OpenTelemetry::Exporter::Jaeger::CollectorExporter.new(
          endpoint: 'http://127.0.0.1:14268/api/traces'
        )
      )
    )
  end
end

# To start a trace you need to get a Tracer from the TracerProvider
tracer = OpenTelemetry.tracer_provider.tracer('my_app_or_gem', '0.1.0')

OpenTelemetry.logger = Logger.new(STDOUT, level: Logger::DEBUG)

# create a span
tracer.in_span("foo #{ENV['OTLP'] == 'true' ? 'otlp' : 'jaeger'}") do |span|
  span.add_event('event in foo')
end
