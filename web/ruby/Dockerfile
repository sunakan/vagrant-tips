ARG DOCKER_RUBY_TAG
FROM ruby:${DOCKER_RUBY_TAG} as development

WORKDIR /var/local/app/

RUN apt-get update
RUN apt-get install --assume-yes \
  default-libmysqlclient-dev \
  build-essential
COPY app/Gemfile* ./
RUN bundle install
COPY app/* ./
RUN groupadd ruby-app \
  && useradd ruby-app -g ruby-app --no-create-home \
  && chown -R ruby-app:ruby-app ./

USER ruby-app
CMD ["bundle", "exec", "ruby", "./app.rb"]
