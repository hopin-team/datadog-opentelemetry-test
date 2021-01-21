#### Setup

```
bundle install
export DATADOG_API_KEY=foo
```

#### To reproduce

In one terminal:

```
erb config.yml.erb > config.yml && otel-collector --config config.yml
```

In another terminal:

```
# for jaeger
bundle exec ruby script.rb
# for otlp
OTLP=true bundle exec ruby script.rb
```
