FROM ruby:2.4.0-alpine

RUN apk --update add --virtual build-dependencies build-base bash

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install
RUN gem install shotgun

# Upload source
COPY . $APP_HOME

# Start server
ENV PORT 9393
EXPOSE 9393
CMD ["bundle", "exec", "shotgun", "--host", "0.0.0.0"]
