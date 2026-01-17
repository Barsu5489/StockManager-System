FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

# Install Rails and dependencies
RUN su vscode -c "gem install rails bundler"
RUN su vscode -c "/usr/local/rvm/bin/rvm fix-permissions"

# Install SQLite
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends sqlite3 libsqlite3-dev libvips

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"
