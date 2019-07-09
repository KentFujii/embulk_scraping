# embulk scraping

- extract_parser
- transform_filter
- load_formatter

## setup

```
embulk bundle --path vendor/bundle
```

## debug

embed `binding.pry` to your plugin and run the command below

```
embulk preview scraping.yml -b ./ -I ./ -G
```

## run

```
embulk run scraping.yml -b ./ -I ./
```

