FROM openjdk:8-jre-stretch

# init
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ADD . /embulk-scraping
WORKDIR /embulk-scraping

# embulk
RUN curl -o /usr/local/bin/embulk --create-dirs -L "https://dl.embulk.org/embulk-0.9.19.jar"
RUN chmod +x /usr/local/bin/embulk
## embulk dependencies
COPY Gemfile /embulk-scraping/
# COPY embulk/Gemfile /susanoh/embulk/
RUN cd /embulk-scraping && embulk bundle --path vendor/bundle
