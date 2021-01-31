[![Build Status](https://travis-ci.org/octopusinvitro/chat-viewer.svg?branch=master)](https://travis-ci.org/octopusinvitro/chat-viewer)
[![build status](https://gitlab.com/octopusinvitro/chat-viewer/badges/master/pipeline.svg)](https://gitlab.com/octopusinvitro/chat-viewer/commits/master)
[![Coverage Status](https://coveralls.io/repos/github/octopusinvitro/chat-viewer/badge.svg?branch=master)](https://coveralls.io/github/octopusinvitro/chat-viewer?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/928faf993ccf571770dc/maintainability)](https://codeclimate.com/github/octopusinvitro/chat-viewer/maintainability)
[![Dependency status](https://badges.depfu.com/badges/a5f9aa0eb83998a1a81f7b1298a0b4f8/overview.svg)](https://depfu.com/github/octopusinvitro/chat-viewer?project=Bundler)


# Readme

Sinatra app to parse and show **plaintext** chats from WhatsApp, Facebook and the old MSN Messenger.

Throw your chats in the `chats` folder at the root level.


## Features

### Messenger chats

* Messages have no timestamp..
* Differentiates between system message, user message and user's contacts messages.
* Differentiates between group chats chats and one-to-one chats.
* Supports any encoding that can be detected with `file --mime filename.txt`, and both `\r\n` and `\n` newline characters.
* Supports multiline messages.
* Converts URLs to links.
* Converts [the old MSN emojis](https://elouai.com/msn-emoticons.php) to ASCII emojis.
* Supports Spanish ("Contact Name dice:") and English ("Contact Name says:").


### Whatsapp chats

* Messages have a timestamp
* Differentiates between system message, user message and user's contacts messages.
* Differentiates between group chats chats and one-to-one chats.
* Supports `UTF-8` encoding only.
* Supports multiline messages.
* Parses `<Media Omited>` into text.
* Converts URLs to links.
* Converts `~` to strike through text.
* Supports emojis in file names.
* Sorts messages by date, as WhatsApp export does not export them in order.


## Chats structure:

Put chats in the right folder. You can group a contact's chats in a folder.
* the Messenger parser with detect any files starting with `chat` and with a `.txt` extension inside or outside of a contact folder.
* the WhatsApp parser will detect one file inside every contact folder or several outside of contact folders, with a `.txt` extension.

```
chats/
├── facebook
│   ├── chat1.txt
│   ├── chat2.txt
│   └── chat3.txt
├── messenger
│   ├── contact1
│   │   ├── chat1.txt
│   │   └── chat2.txt
│   ├── contact2
│   │   ├── chat1.txt
│   │   └── chat2.txt
│   ├── contact1.txt
│   └── contact2.txt
└── whatsapp
    ├── contact
    │   ├── avatar.jpeg
    │   └── contact.txt
    ├── with-emojis
    │   ├── avatar.jpeg
    │   └── ✨with-emojis✨.txt
    ├── contact1.txt
    └── contact2.txt
```


## How to use this project

This is a Ruby project. Tell your Ruby version manager to set your local Ruby version to the one specified in the `Gemfile`.

For example, if you are using [rbenv](https://cbednarski.com/articles/installing-ruby/):

1. Install the right Ruby version:
  ```bash
  rbenv install < VERSION >
  ```
1. Move to the root directory of this project and type:
  ```bash
  rbenv local < VERSION >
  ruby -v
  ```

You will also need to install the `bundler` gem, which will allow you to install the rest of the dependencies listed in the `Gemfile` file of this project.

```bash
gem install bundler
rbenv rehash
```


### Folder structure

* `bin `: Executables
* `lib `: Sources
* `spec`: Tests


### To initialise the project

```bash
bundle install
```


### To run the app

Make sure that the `bin/app` file has execution permissions:

```bash
chmod +x bin/app
```

Then just type:

```bash
bin/app
```

If this doesn't work you can always do:

```bash
bundle exec ruby bin/app
```


## Tests


### To run all tests and rubocop

```bash
bundle exec rake
```


### To run a specific file


```bash
bundle exec rspec path/to/test/file.rb
```


### To run a specific test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```


### To run rubocop

```bash
bundle exec rubocop
```


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License


## TODO

- [ ] open single files not in folder in Messenger
- [ ] parse Facebook chats
- [ ] finish adding MSN emojis and improve regex in `messenger_message`
- [ ] load user avatar from chats folder for WhatsApp chats
- [ ] search for the list of chats so that no scroll is needed
- [ ] find a replacement for `URI.extract` to avoid the warning
