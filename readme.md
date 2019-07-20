# embulk scraping

- input
  - scraping_parser htmlからrubyの入力に変換
- filters
  - scraping_filter_extract 入力項目別に正規化
  - scraping_filter_transform 正規化済のデータで項目を作る
  - scraping_filter_load 出力を振り分ける
- output
  - scraping_formatter rubyの出力をjsonに変換

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

