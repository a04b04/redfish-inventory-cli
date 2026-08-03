# Redfish Inventory CLI

A Ruby command-line application for managing server inventory using the Redfish API.

The application supports both a fully interactive terminal interface and a traditional command-line interface powered by `dry-cli`.

---

## Features

### Assets

- List all assets
- View an asset
- Create an asset from a Redfish JSON file
- Update asset information
- Upload a new JSON version
- Browse previous JSON versions
- Add tracked data fields
- Remove tracked data fields
- Delete assets

### Racks

- List racks
- View rack information
- Create racks
- Update racks
- Delete racks
- Browse assets within a rack

### Interactive Mode

- Menu-driven interface
- Keyboard navigation
- Asset and rack selection
- Version browsing
- JSON viewing
- Guided asset creation
- Guided asset updates

---

# Installation

```bash
git clone <repository>
cd redfish-inventory-cli
bundle install
```

---

# Configuration

Update the API URL inside:

```
lib/redfish_inventory/config.rb
```

Example:

```ruby
API_URL = "http://localhost:3000/api/v1/"
```

---

# Interactive Mode

Launch the interactive interface:

```bash
redfish-inventory interactive
```

or

```bash
redfish-inventory i
```

---

# Command Line Usage

## Assets

### List assets

```bash
redfish-inventory assets list
```

### Show an asset

```bash
redfish-inventory assets show 5
```

### Create an asset

```bash
redfish-inventory assets create system.json \
    name="Compute Node 01" \
    rackId=1 \
    size=2 \
    position=10
```

### Update an asset

```bash
redfish-inventory assets update 5 \
    name="Compute Node 02"
```

```bash
redfish-inventory assets update 5 \
    rackId=2 \
    position=12
```

### Upload a new JSON version

```bash
redfish-inventory assets update-json 5 system.json
```

### View a previous version

```bash
redfish-inventory assets show-version 5 0
```

### Add tracked data

```bash
redfish-inventory assets add-data 5
```

Search for Redfish fields and choose which ones to track.

### Delete tracked data

```bash
redfish-inventory assets delete-data 5
```

Displays the tracked fields and allows one to be removed.

### Delete an asset

```bash
redfish-inventory assets delete 5
```

---

## Racks

### List racks

```bash
redfish-inventory racks list
```

### Show a rack

```bash
redfish-inventory racks show 2
```

### Create a rack

```bash
redfish-inventory racks create \
    name="Rack A" \
    size=42 \
    notes="GPU Rack"
```

### Update a rack

```bash
redfish-inventory racks update 2 \
    name="Rack B"
```

### Delete a rack

```bash
redfish-inventory racks delete 2
```

### List assets within a rack

```bash
redfish-inventory racks list-assets 2
```

---

# Tracked Data

Tracked data allows important Redfish values to be monitored without viewing the full JSON document.

Examples include:

- Total Memory
- BIOS Version
- Model
- Serial Number
- Logical CPU Count

Tracked fields are linked to JSON paths and are automatically updated whenever a new JSON version is uploaded.

---

# JSON Version History

Each uploaded JSON file is stored as a new version.

You can:

- Browse previous versions
- Compare tracked values between versions
- View the original JSON for any version

---

# Technologies

- Ruby
- dry-cli
- tty-prompt
- Net::HTTP
- JSON
- Redfish API

