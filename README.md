# Redfish Inventory CLI

A command-line application for managing Redfish assets, racks, templates, roles and permissions through the Asset Rack API.

The CLI provides both a traditional command-based interface and an interactive terminal UI built with **TTY::Prompt**.

---


# Features

- 🔐 JWT authentication
- 🖥 Interactive terminal interface
- 📦 Asset management
- 🗄 Rack management
- 📋 Template management
- 📊 Statistics
- 👥 Role management
- 🔑 Permission browser
- 🎨 Pretty terminal tables using TTY::Table

---

# Configuration

The CLI needs to know the URL of the Asset Rack API.

Open:

```text
lib/redfish_inventory/config.rb
---

# Installation

```bash
bundle install
```

Run the CLI with:

```bash
./bin/redfish-inventory
```

or

```bash
./bin/redfish-inventory interactive
```

---

# Authentication

## Login

```bash
./bin/redfish-inventory login
```

You'll be prompted for:

- Username
- Password

The CLI stores your JWT securely and automatically includes it with future requests.

---

## Remove Stored Token

```bash
./bin/redfish-inventory remove-token
```

---

# Assets

## List Assets

```bash
./bin/redfish-inventory assets list
```

Displays all assets in a formatted table.

---

## Show Asset

```bash
./bin/redfish-inventory assets show <id>
```

Displays:

- Asset details
- Associated JSON fields
- Option to display the stored JSON document

---

## Create Asset

```bash
./bin/redfish-inventory assets create <json-file> \
name="Server 1" \
rackId=1 \
size=2 \
position=4
```

Features:

- Reads a JSON file
- Searches JSON fields interactively
- Allows multiple field selections
- Maps JSON paths to friendly names
- Uploads both metadata and original JSON

---

## Update Asset

```bash
./bin/redfish-inventory assets update <id> \
name="New Name"
```

Supports updating:

- Name
- Rack
- Position
- Size

---

## Replace Asset JSON

```bash
./bin/redfish-inventory assets update-json <id> file.json
```

Uploads a new JSON payload while preserving asset metadata.

---

## Delete Asset

```bash
./bin/redfish-inventory assets delete <id>
```

---

## View Historical JSON

```bash
./bin/redfish-inventory assets show-version <id> <version>
```

---

## Add Asset Data Paths

```bash
./bin/redfish-inventory assets add-data <id>
```

Interactively searches JSON and adds additional tracked fields.

---

## Delete Asset Data

```bash
./bin/redfish-inventory assets delete-data <id>
```

---

# Racks

## List Racks

```bash
./bin/redfish-inventory racks list
```

Displays racks using a formatted table.

---

## Show Rack

```bash
./bin/redfish-inventory racks show <id>
```

Displays:

- ID
- Name
- Size
- Notes

---

## Create Rack

```bash
./bin/redfish-inventory racks create \
name="Rack A" \
size=42 \
notes="GPU rack"
```

---

## Update Rack

```bash
./bin/redfish-inventory racks update <id>
```

Supports updating:

- Name
- Size
- Notes

---

## Delete Rack

```bash
./bin/redfish-inventory racks delete <id>
```

---

## List Assets Within a Rack

```bash
./bin/redfish-inventory racks list-assets <id>
```

---

# Templates

## List Templates

```bash
./bin/redfish-inventory templates list
```

---

## Show Template

```bash
./bin/redfish-inventory templates show <id>
```

Displays template information and associated JSON paths.

---

## Create Template

```bash
./bin/redfish-inventory templates create
```

Interactive creation of reusable JSON templates.

---

## Rename Template

```bash
./bin/redfish-inventory templates update-name <id>
```

---

## Add Template Paths

```bash
./bin/redfish-inventory templates add-path <id>
```

---

## Update Template Path

```bash
./bin/redfish-inventory templates update-path <template-id> <path-id>
```

---

## Delete Template

```bash
./bin/redfish-inventory templates delete <id>
```

---

# Roles

## List Roles

```bash
./bin/redfish-inventory roles list
```

Displays:

- Role ID
- Role Name
- Permission Count

---

## Show Role

```bash
./bin/redfish-inventory roles show <id>
```

Displays:

- Role details
- Assigned permissions

---

## Create Role

```bash
./bin/redfish-inventory roles create \
--name="Rack Viewer" \
--permissions=4,7
```

Creates a new role with the specified permissions.

---

## Add Permissions

```bash
./bin/redfish-inventory roles add-permissions <id> \
--permissions=4,7
```

---

## Remove Permissions

```bash
./bin/redfish-inventory roles remove-permissions <id> \
--permissions=4,7
```

The CLI validates that the selected permissions currently exist on the role before attempting removal.

---

## Delete Role

```bash
./bin/redfish-inventory roles delete <id>
```

---

# Permissions

## List Available Permissions

```bash
./bin/redfish-inventory permissions list
```

Displays every available permission in a formatted table.

---

# Statistics

## Overall Statistics

```bash
./bin/redfish-inventory stats
```

---

## Rack Statistics

```bash
./bin/redfish-inventory stats racks
```

---

## Asset Statistics

```bash
./bin/redfish-inventory stats assets
```

---

# Interactive Mode

Launch the interactive interface:

```bash
./bin/redfish-inventory interactive
```

The interface provides menu-driven navigation for all major features.

## Assets

- List Assets
- Show Asset
- Create Asset
- Update Asset
- Delete Asset
- Manage Asset Data
- View JSON
- Browse History

---

## Racks

- List Racks
- Show Rack
- Create Rack
- Delete Rack
- Browse Rack Assets

---

## Templates

- List Templates
- Show Template
- Create Template
- Delete Template
- Manage Template Paths

---

## Roles

- List Roles
- Show Role
- Create Role
- Alter Permissions
- Delete Role

---

## Permissions

- Browse all available permissions

---

## Statistics

- Overall statistics
- Rack statistics
- Asset statistics

---

# Built With

- Ruby
- Dry::CLI
- TTY::Prompt
- TTY::Table
- Net::HTTP
- JSON

---

# API

The CLI communicates with the Asset Rack REST API using authenticated JSON requests.

Authentication uses JWT Bearer tokens stored locally after login.

---

# Project Structure

```
lib/
├── commands/
├── dry_cli/
├── interactive/
├── auth/
├── api_client.rb
├── config.rb
└── json_field_selector.rb
```

