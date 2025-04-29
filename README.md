# OpenFresk
Short description and motivation.

## Prerequisites

- Git (https://git-scm.com/)
- Ruby 3.2.2 (use rbenv, RVM, or see https://www.ruby-lang.org/en/downloads/)
- Bundler (`gem install bundler`)
- PostgreSQL (>= 9.3) and development headers (e.g., `libpq-dev` on Debian/Ubuntu or `postgresql` via Homebrew on macOS). Ensure the server is installed and running. See https://www.postgresql.org/download/.
- Node.js and Yarn (optional, only required for managing JavaScript dependencies)

## Getting Started

Follow these steps to clone the repository and launch the dummy host application:

1. Clone the repository and navigate into it:

   ```bash
   git clone https://github.com/yourusername/open_fresk.git
   cd open_fresk
   ```

2. Install Ruby gem dependencies:

   ```bash
   bundle install
   ```

3. Navigate to the dummy Rails application:

   ```bash
   cd test/dummy
   ```

4. Run the setup script to install any missing gems and prepare the database:

   ```bash
   bin/setup
   ```

5. Start the Rails server:

   ```bash
   bin/rails server
   ```

6. Open your browser and visit `http://localhost:3000/open_fresk` to see the OpenFresk engine in action.

If you need to use a different port (e.g., 3001), run:

```bash
bin/rails server -p 3001
```

Troubleshooting:

- Ensure PostgreSQL credentials in `test/dummy/config/database.yml` match your setup.
- If you encounter permission or connection issues, configure your PostgreSQL user or use environment variables (e.g., `DATABASE_URL`).

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "open_fresk"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install open_fresk
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
