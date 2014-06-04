# Reposit

Quickly create GitHub repos from the command line.

## Installation

`$ gem install reposit`

## Requirements

Requires `gawk`. Install with homebrew: `$ brew install gawk`

## Usage

Reposit creates a new repository on GitHub and copies the SSH url to your clipboard.

1. Generate a new personal API key by visiting [https://github.com/settings/applications](https://github.com/settings/applications) and choosing 'Generate New Token'.
2. From your command line, run:

  ```bash
  $ reposit <repository_name>
  ```
3. On first run, you will be asked to enter your GitHub username and newly generated API key.

## Optional Usage

```bash
$ reposit <repository_name> -o <organization_name>
```

## Troubleshooting

If repositories aren't being created and/or the SSH url isn't being copied to your clipboard, it probably means your credentials are incorrect. Reset them by running:

  ```bash
  $ reposit --setup
  ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/reposit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

1. Add ability to specify public or private repos

Built in NYC by [@loganhasson](http://twitter.com/loganhasson)