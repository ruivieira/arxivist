# arxivist

A library to search arXiv.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  arxivist:
    github: ruivieira/arxivist
```


## Usage


```crystal
require "arxivist"
```


### Simple search

```crystal
opt = Arxivist::SearchOptions.new
opt.add_terms(["Monte", "Carlo"])
opt.max_results = 15

papers = Arxivist.search(opt)
# title: The derivation of Particle Monte Carlo methods
#for plasma modeling from transport equations, 
#link: http://arxiv.org/abs/0805.3105v1

# title: Fast orthogonal transforms for multi-level quasi-Monte Carlo integration
# link: http://arxiv.org/abs/1508.02162v1

# ...
```

## Development

TODO

## Contributing

1. Fork it ( https://github.com/ruivieira/arxivist/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [ruivieira](https://github.com/ruivieira) Rui Vieira - creator, maintainer
