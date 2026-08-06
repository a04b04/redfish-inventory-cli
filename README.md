# Redfish Inventory CLI

A Ruby command-line application for managing **assets**, **racks**, **templates**, **roles**, and **permissions** through the Asset Rack REST API.

The CLI provides both a traditional command-based interface using **Dry::CLI** and an interactive terminal interface built with **TTY::Prompt**.

---

# Features

- 🔐 JWT authentication
- ⚙️ Configurable API endpoint
- 🖥 Interactive terminal interface
- 📦 Asset management
- 🗄 Rack management
- 📋 Template management
- 👥 Role management
- 🔑 Permission browser
- 📊 Statistics
- 🎨 Pretty terminal tables using TTY::Table

---

# Installation

Install dependencies:

```bash
bundle install
```

Configure the API endpoint:

```bash
./bin/redfish-inventory config set-url http://localhost:3000/api/v1
```

Replace the URL with your Asset Rack API server.

The URL is stored locally, so this only needs to be configured once.

Run the CLI:

```bash
./bin/redfish-inventory
```

or launch the interactive interface:

```bash
./bin/redfish-inventory interactive
```

---

# Configuration

View the configured API endpoint:

```bash
./bin/redfish-inventory config set-url http://localhost:3000/api/v1
```

You can run the command again at any time to point the CLI at another Asset Rack API instance.

---

# Authentication

## Login

```bash
./bin/redfish-inventory login
```

You'll be prompted for:

- Username
- Password

The CLI securely stores your JWT token and automatically includes it with future API requests.

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
- Selected JSON fields
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

- Reads a JSON document
- Interactive JSON path search
- Select multiple fields
- Assign friendly field names
- Upload original JSON alongside metadata

---

## Update Asset

```bash
./bin/redfish-inventory assets update <id> \
name="Updated Server"
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

Replaces the stored JSON while preserving asset metadata.

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

## Add Asset Data

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

Displays racks in a formatted table.

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
notes="GPU Rack"
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

Interactive creation of reusable templates.

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

Creates a role with the selected permissions.

---

## Add Permissions

```bash
./bin/redfish-inventory roles add-permissions <id> \
--permissions=4,7
```

Adds permissions to an existing role.

---

## Remove Permissions

```bash
./bin/redfish-inventory roles remove-permissions <id> \
--permissions=4,7
```

Removes permissions from an existing role.

The CLI validates that the selected permissions currently exist before attempting removal.

---

## Delete Role

```bash
./bin/redfish-inventory roles delete <id>
```

---

# Permissions

## List Permissions

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

The interactive interface provides menu-driven navigation for the majority of CLI functionality.

## Assets

- List Assets
- Show Asset
- Create Asset
- Update Asset
- Delete Asset
- Manage Asset Data
- View JSON
- Browse JSON History

---

## Racks

- List Racks
- Show Rack
- Create Rack
- Delete Rack
- Browse Assets in a Rack

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

- Overall Statistics
- Rack Statistics
- Asset Statistics

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

Authentication uses JWT Bearer tokens stored locally after a successful login.

---

# Project Structure

```
lib/
├── auth/
├── commands/
├── dry_cli/
├── interactive/
├── api_client.rb
├── config.rb
├── config_store.rb
├── errors.rb
└── json_field_selector.rb
```