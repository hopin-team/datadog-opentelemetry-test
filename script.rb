require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/exporter/jaeger'

# Configure the sdk with custom export
OpenTelemetry::SDK.configure do |c|
  c.add_span_processor(
    OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
      OpenTelemetry::Exporter::OTLP::Exporter.new(insecure: true)
    )
  )
  c.add_span_processor(
    OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
      OpenTelemetry::Exporter::Jaeger::CollectorExporter.new(
        endpoint: 'http://localhost:14268/api/traces'
      )
    )
  )
end

# To start a trace you need to get a Tracer from the TracerProvider
tracer = OpenTelemetry.tracer_provider.tracer('my_app_or_gem', '0.1.0')

OpenTelemetry.logger = Logger.new(STDOUT, level: Logger::DEBUG)


# create a span
tracer.in_span('foo') do |span|
  span.add_event('event in foo')
end

