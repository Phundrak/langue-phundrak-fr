FROM google/dart:2.7

WORKDIR /app

RUN mkdir /pub-cache
ENV PUB_CACHE=/pub-cache
ENV PATH="${PATH}:/pub-cache/bin"
RUN pub global activate webdev
# RUN pub global activate stagehand

ADD pubspec.* /app/
RUN pub get
ADD . /app/
RUN pub get --offline

# EXPOSE 8010
