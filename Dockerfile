FROM google/dart:2.7

WORKDIR /app

# Get Dart dependencies
RUN mkdir -p /pub-cache
ENV PUB_CACHE=/pub-cache
ENV PATH="${PATH}:/pub-cache/bin"
RUN pub global activate webdev
ADD pubspec.* /app/
RUN pub get
RUN pub get --offline

RUN apt update && apt install ruby-sass ruby-dev build-essential -y
RUN gem install sass-listen

ADD . /app/

CMD ["./start.sh"]
