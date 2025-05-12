<a href="https://github.com/yourusername/open_fresk">
  <img src="app/assets/images/open_fresk/favicon.png" width="100px" alt="OpenFresk Logo">
</a>

# OpenFresk

OpenFresk is a 100% open-source project for non-profit organizations to deploy and manage interactive “Fresque” workshops on a self-hosted web platform.

> **Self-hosted.** Deploy on your own infrastructure and retain full control over your data.
> **Extensible.** Customize views, controllers, and assets to match your brand and workflow.
> **Rapid setup.** Launch a platform in minutes with the built-in dummy host app.
> **100% Open source.** Free to use, modify, and contribute.

---

**With OpenFresk, you can:**

- 📅 **Create and schedule workshops** to manage time slots and sessions.
- 🙍 **Manage participant registration and authentication** with built-in user flows.
- 💳 **Sell tickets and manage payments** (via Stripe, PayPal, etc.).
- 🤝 **Facilitate collaborative exercises and collect feedback** during workshops.

---

## Key Benefits

- 🔒 **Ownership.** Fully self-hosted and branded.
- ⚡️ **Speed.** Rapid deployment with minimal configuration.
- 🛠️ **Flexibility.** Override any part of the engine to fit your needs.
- ❤️ **Community.** Backed by a growing open-source community.

---

## Prerequisites

- Git (https://git-scm.com/)
- Ruby 3.2.2 (recommended via rbenv or RVM)
- Bundler (`gem install bundler`)
- PostgreSQL >= 9.3 with development headers (`libpq-dev` on Debian/Ubuntu or `postgresql` on macOS)
- Node.js and Yarn (optional, for JavaScript dependencies)

---

## Getting Started

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/open_fresk.git
   cd open_fresk
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Switch to the dummy host app**:

   ```bash
   cd test/dummy
   ```

4. **Set up the app** (gems, database, assets):

   ```bash
   bin/setup
   ```

5. **Run the server**:

   ```bash
   bin/rails server
   ```

6. **Visit** `http://localhost:3000/open_fresk` in your browser.

To run on a different port (e.g., 3001):

```bash
bin/rails server -p 3001
```

---

## Built With

- Ruby on Rails 7
- Puma (web server)
- PostgreSQL (database)
- Sprockets & Importmap (asset management)
- Stimulus (JavaScript controllers)
- FontAwesome5 (icons)

---

## Contributing

We welcome contributions! To get started:

1. Fork the repository on GitHub.
2. Clone your fork and create a branch:
   ```bash
   git clone https://github.com/yourusername/open_fresk.git
   cd open_fresk
   git checkout -b my-feature
   ```
3. Follow the **Getting Started** guide to run the dummy host app.
4. Implement your feature or bugfix, and add tests.
5. Run the test suite:
   ```bash
   bundle exec rails test
   ```
6. Commit your changes and push to your fork.
7. Open a Pull Request on GitHub.

Please adhere to the existing code style and write tests for new functionality.

---

## Security

Please report any security issues via GitHub Issues or by contacting the maintainers directly.

---

## License

OpenFresk is released under the MIT License. See the [MIT-LICENSE](MIT-LICENSE) file for details
