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

### Search by authors

```crystal
options = SearchOptions.new
      authors = ["Owen", "Wilkinson", "Gillespie"]
      options.add_author_terms(authors)

    papers = Arxivist.search(options)

	papers.each {|paper| puts(paper.to_s)}
    
# title: Scalable Inference for Markov Processes with Intractable Likelihoods, 
# link: http://arxiv.org/abs/1403.6886v2, 
# authors: Jamie Owen, Darren J. Wilkinson, Colin S. Gillespie

# title: Likelihood free inference for Markov processes: a comparison, 
# link: http://arxiv.org/abs/1410.0524v1, 
# authors: Jamie Owen, Darren J. Wilkinson, Colin S. Gillespie
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
