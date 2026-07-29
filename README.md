# Redfish Inventory CLI

A Ruby command-line application for managing hardware assets and racks through a Redfish inventory API.

The CLI can also run in a local demo mode using JSON files instead of the production API.

## Features

### Rack management

The CLI can:

- List all racks◊
- Show a specific rack
- Create a rack
- Update a rack
- Delete a rack
- List all assets assigned to a rack
- Update the JSON associated with a rack

### Asset management

The CLI can:

- List all assets
- Show a specific asset
- Create an asset from a Redfish JSON file
- Update editable asset fields
- Update an asset's Redfish JSON
- Delete an asset
- View a specific stored JSON version

### Redfish JSON field selection

When creating an asset, the CLI can search through the uploaded Redfish JSON recursively.

It searches through:

- Nested objects
- Arrays
- Objects inside arrays
- Vendor-specific Redfish fields

The CLI displays matching JSON paths as a numbered list.

Example:

```text
Search JSON fields: memory

1. MemorySummary
2. MemorySummary.MemoryMirroring
3. MemorySummary.TotalSystemMemoryGiB

Select a path number: 3
Enter a name for this field: Total Memory
The selected field is stored as:

```json
{
  "name": "Total Memory",
  "path": "MemorySummary.TotalSystemMemoryGiB"
}
```

The CLI stores the JSON path rather than the current value. This allows the backend to retrieve the latest value from the stored Redfish JSON whenever it is needed.

---

## Project Structure

```text
redfish-inventory-cli/
├── bin/
│   └── redfish-inventory
├── data/
│   ├── assets.json
│   └── racks.json
├── lib/
│   ├── redfish_inventory.rb
│   └── redfish_inventory/
│       ├── api_client.rb
│       ├── cli.rb
│       ├── config.rb
│       ├── errors.rb
│       └── commands/
│           ├── assets.rb
│           └── racks.rb
└── spec/
```

---

## Running the CLI

Run commands from the project root.

```bash
./bin/redfish-inventory <resource> <action> [arguments]
```

Available resources:

```text
assets
racks
```

---

## Asset Commands

### List assets

```bash
./bin/redfish-inventory assets list
```

### Show an asset

```bash
./bin/redfish-inventory assets show 1
```

### Create an asset

```bash
./bin/redfish-inventory assets create-asset \
    /Users/ab/Downloads/redfish_asset.json \
    name="Server 1" \
    rackId=1 \
    size=2 \
    position=4
```

During asset creation the CLI will:

1. Validate the supplied JSON file.
2. Validate the required asset fields.
3. Parse the uploaded Redfish JSON.
4. Ask the user for a JSON search term.
5. Search the Redfish JSON recursively.
6. Display all matching JSON paths.
7. Allow the user to select the required path.
8. Ask the user to provide a display name for the selected field.
9. Build the asset payload.
10. Create the asset.

The generated payload matches the backend schema:

```json
{
  "rackId": 1,
  "name": "Server 1",
  "size": 2,
  "position": 4,
  "data": [
    {
      "name": "Total Memory",
      "path": "MemorySummary.TotalSystemMemoryGiB"
    }
  ],
  "json": {
    "text": "{ Full Redfish JSON file }",
    "filename": "redfish_asset.json"
  }
}
```

### Update an asset

```bash
./bin/redfish-inventory assets update-asset 1 name="Updated Server" position=8
```

### Update an asset's Redfish JSON

```bash
./bin/redfish-inventory assets update-json 1 /path/to/new_redfish.json
```

### Delete an asset

```bash
./bin/redfish-inventory assets delete-asset 1
```

### Show a stored JSON version

```bash
./bin/redfish-inventory assets show-version 1 0
```

Version indexing begins at **0**.

---

## Rack Commands

### List racks

```bash
./bin/redfish-inventory racks list
```

### Show a rack

```bash
./bin/redfish-inventory racks show 1
```

### Create a rack

```bash
./bin/redfish-inventory racks create name="Rack A" size=42
```

Notes are optional:

```bash
./bin/redfish-inventory racks create \
    name="Rack A" \
    size=42 \
    notes="GPU Rack"
```

### Update a rack

```bash
./bin/redfish-inventory racks update-rack 1 name="Rack B" size=48
```

### Update rack JSON

```bash
./bin/redfish-inventory racks update-json 1 /path/to/rack.json
```

### List assets within a rack

```bash
./bin/redfish-inventory racks list-assets 1
```

### Delete a rack

```bash
./bin/redfish-inventory racks delete 1
```

---

## Demo Mode

The CLI currently supports a local demo mode.

Instead of communicating with the backend API, demo mode stores data in:

```text
data/assets.json
data/racks.json
```

Demo sections are clearly marked within the source code:

```ruby
# Demo only — delete everything between these comments for production

...

# End demo-only section — delete everything above this comment for production
```

When switching to production, simply remove the demo code and uncomment the API request.

---

## Production Mode

In production the CLI communicates exclusively with the backend REST API.

Example:

```ruby
asset = ApiClient.post('/assets', payload)
```

The CLI never communicates directly with MongoDB or any other database.

---

## Current Asset Creation Workflow

```text
Run create-asset command
        │
        ▼
Validate command arguments
        │
        ▼
Read Redfish JSON file
        │
        ▼
Parse JSON
        │
        ▼
Ask user for search term
        │
        ▼
Search JSON recursively
        │
        ▼
Display numbered matching paths
        │        ▼
User selects required path
        │
        ▼
User enters a display name
        │
        ▼
Generate payload
        │
        ▼
Create asset
        │
        ▼
Save locally (demo) or POST to the backend API (production)
```