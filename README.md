# Colorado Benefits

Code repository for Colorado Benefits, an application for reporting life changes that affect public assistance benefits by
[Code for America](https://www.codeforamerica.org).

## Getting Set Up

### macOS

Install [Homebrew].

Install [Heroku CLI].

`brew install heroku/brew/heroku`

Install and start PostgreSQL.

`brew install postgresql`

`brew services start postgresql`

[Homebrew]: https://brew.sh/
[Heroku CLI]: https://devcenter.heroku.com/articles/heroku-cli

### Ruby on Rails

This application is built using [Ruby on Rails].

Your system will require [Ruby] to develop on the application.

The required Ruby version is listed in the [.ruby-version](.ruby-version) file.

If you do not have this binary, [use this guide to get set up on MacOS].

[Ruby on Rails]: http://rubyonrails.org
[Ruby]: https://www.ruby-lang.org/en/
[use this guide to get set up on MacOS]: http://installfest.railsbridge.org/installfest/macintosh

### Configuring the Application

1. Clone this repo
2. Ask the team for the RAILS_MASTER_KEY
3. Add it to a new file `config/master.key`
4. Run `bin/setup`

## Day-to-day Development

### Local Server

* Run the server(s): `foreman start`
* Visit [your local server](http://localhost:3000)
* To preview any emails that were sent while testing locally, visit the [running mailhog instance](http://localhost:8025/)
* Run tests, Rubocop, bundle audit, and Brakeman: `rake`

### Conventions

* **Secrets** - We store all secrets in credentials.yml.enc. Locally you will need a `config/master.key` file with the master key in it (stored in LastPass). To edit run `EDITOR=vi bin/rails credentials:edit`
* **Environment config** - We store non-sensitive environment configuration in environment variables. In development, environment variables are loaded from `.env`. When adding an environment, be sure to update the `.env` file and `app.json` (used by Heroku for review apps).

### Form Navigation

This application is a long questionnaire. You will probably want to work on parts of 
it without completing the whole application.

After booting the server and filling out the first few questions,
go to `http://localhost:3000/sections` to jump around.

### Testing

#### Running specs

For development purposes, we generally just run `rspec`.

#### Spec Helpers

* Use `match_html` to test that two HTML strings match, excluding whitespace, order of attributes, etc.:

```ruby
expect(rendered).to match_html <<-HTML
  <table class="foo bar">
  <tr>
  <td>Hi!</td>
  </tr>
  </table>
HTML
```


### Styleguide/Branding
This application was designed using an Atomic design system.

The styleguide can be viewed at [GetCalFresh Styleguide](http://localhost:3000/cfa/styleguide).

## Deploying

### Timing for Deploys

* Staging: Deployed automatically on successful builds from `master`.

### Deploying to Staging

[CircleCI](https://circleci.com/gh/codeforamerica/colorado-benefits) is currently set up to deploy green builds to **staging**.

### Deploying to Production

Our release process will promote the staging environment to production.

Before deploying to production, we want to make sure that:

* All tickets that are awaiting acceptance have been accepted
* All necessary configuration variables are set on production
* All buildpacks are the same between staging and production

To promote the staging environment to production click the "Promote to production..." button in the colorado-benefits pipeline in Heroku.
