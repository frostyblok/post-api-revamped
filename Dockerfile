FROM ruby:2.6.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /post-api
WORKDIR /post-api
COPY Gemfile /post-api/Gemfile
COPY Gemfile.lock /post-api/Gemfile.lock
RUN gem install bundler
RUN bundler -v
RUN bundle install && cp Gemfile.lock /tmp
COPY . /post-api

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
