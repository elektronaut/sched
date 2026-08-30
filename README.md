[![Version](https://img.shields.io/gem/v/sched.svg?style=flat)](https://rubygems.org/gems/sched)
[![Build](https://github.com/elektronaut/sched/actions/workflows/build.yml/badge.svg)](https://github.com/elektronaut/sched/actions/workflows/build.yml)

# Sched

Third-party Ruby client library for the [Sched API](https://sched.com/api).

## Usage

```
require 'sched'
sched = Sched::Client.new('conference', 'api_key')
event = sched.event('PANEL4')
```

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/elektronaut/sched). See
[CONTRIBUTING.md](CONTRIBUTING.md) for how to get set up and how
commits are formatted, and note that this project ships with a
[code of conduct](CODE_OF_CONDUCT.md).

## License

Released under the [MIT License](LICENSE).
