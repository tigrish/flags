# Flags

Creates PNG thumbnails for different locales

## Installation

Librsvg is used to convert the svg files to png. It must be installed and `rsvg` must be in your path :

    brew install librsvg

Imagemagick is used to add borders and effects :

    brew install imagemagick

Then install bundler and required gems

    gem install bundler
    bundle install

## Usage

Running witout arguments will generate all flags defined in lib/flags.yml

    bundle exec flags

You can generate specific flags like so :

    bundle exec flags -l fr,de,es