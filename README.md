#### Setup

```
bundle install
```

#### To reproduce

In one terminal:

```
erb config.yml.erb > config.yml && otel-collector --config config.yml
```

In another terminal:

```
bundle exec ruby script.rb
```
