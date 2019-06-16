# embulk scraping

## setup
```
embulk bundle --path vendor/bundle
embulk run config/html.yml -b ./ -I ./
```

## debug


embed `binding.pry` to your plugin and run the command below

```
embulk preview config/scraping.yml -b ./ -I ./

```
