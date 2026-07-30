# Redfish Inventory CLI

A Ruby command-line application for managing hardware assets and racks through a Redfish Inventory REST API.

The CLI allows users to create, manage and inspect racks and assets while interactively selecting useful Redfish fields from uploaded JSON files.

---

## Features

### Rack management

The CLI can:

- List all racks
- Show a specific rack
- Create a rack
- Update a rack
- Delete a rack
- List all assets assigned to a rack

### Asset management

The CLI can:

- List all assets
- Show a specific asset
- Create an asset from a Redfish JSON file
- Update editable asset fields
- Update an asset's Redfish JSON
- Delete an asset
- View a previous asset version

---

## Interactive Redfish JSON Search

When creating an asset, the CLI recursively searches through the uploaded Redfish JSON file.

It searches through:

- Nested objects
- Arrays
- Objects inside arrays
- Vendor-specific Redfish extensions

Example:

```text
Search JSON fields: memory

1. MemorySummary/TotalSystemMemoryGiB
2. MemorySummary/MemoryMirroring
3. Memory/0/CapacityMiB

Select path numbers separated by commas:
1,3
```

For every selected path the CLI asks for a display name:

```text
Enter a name for:
MemorySummary/TotalSystemMemoryGiB

> Total Memory
```

The user may continue searching for additional fields before submitting the asset.

The stored field information looks like:

```json
{
  "name": "Total Memory",
  "path": "MemorySummary/TotalSystemMemoryGiB"
}
```

Only the JSON path is stored.

This allows the backend to retrieve the latest value from the stored Redfish JSON whenever required.

---

# Project Structure

```text
redfish-inventory-cli/
├── bin/
│   └── redfish-inventory
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

# Running the CLI

Run commands from the project root.

```bash
./bin/redfish-inventory <resource> <action> [arguments]
```

Resources:

```text
assets
racks
```

---

# Asset Commands

## List assets

```bash
./bin/redfish-inventory assets list
```

---

## Show an asset

```bash
./bin/redfish-inventory assets show 1
```

---

## Create an asset

```bash
./bin/redfish-inventory assets create-asset \
    /Users/ab/Downloads/redfish_asset.json \
    name="Server 1" \
    rackId=1 \
    size=2 \
    position=4
```

During creation the CLI will:

1. Validate the supplied JSON file.
2. Validate the required asset fields.
3. Parse the uploaded Redfish JSON.
4. Ask for a JSON search term.
5. Search recursively through the JSON.
6. Display matching JSON paths.
7. Allow one or more paths to be selected.
8. Ask for a display name for each selected field.
9. Allow additional searches if required.
10. Build the asset payload.
11. Submit the asset to the backend API.

Generated payload:

```json
{
  "rackId": 1,
  "name": "Server 1",
  "size": 2,
  "position": 4,
  "data": [
    {
      "name": "Total Memory",
      "path": "MemorySummary/TotalSystemMemoryGiB"
    },
    {
      "name": "Logical CPUs",
      "path": "ProcessorSummary/LogicalProcessorCount"
    }
  ],
  "json": {
    "text": "{ Full Redfish JSON }",
    "filename": "redfish_asset.json"
  }
}
```

---

## Update an asset

```bash
./bin/redfish-inventory assets update-asset \
    1 \
    name="Updated Server"
```

Or update multiple fields:

```bash
./bin/redfish-inventory assets update-asset \
    1 \
    name="Updated Server" \
    position=8
```

---

## Update an asset's Redfish JSON

```bash
./bin/redfish-inventory assets update-json \
    1 \
    /Users/ab/Downloads/new_redfish.json
```

---

## Delete an asset

```bash
./bin/redfish-inventory assets delete-asset 1
```

---

## Show a previous asset version

```bash
./bin/redfish-inventory assets show-version 1 0
```

Version indexing starts at **0**.

---

# Rack Commands

## List racks

```bash
./bin/redfish-inventory racks list
```

---

## Show a rack

```bash
./bin/redfish-inventory racks show 1
```

---

## Create a rack

```bash
./bin/redfish-inventory racks create-rack \
    name="Rack A" \
    size=42
```

Notes are optional:

```bash
./bin/redfish-inventory racks create-rack \
    name="Rack A" \
    size=42 \
    notes="GPU Rack"
```

---

## Update a rack

```bash
./bin/redfish-inventory racks update-rack \
    1 \
    name="Rack B"
```

Or:

```bash
./bin/redfish-inventory racks update-rack \
    1 \
    name="Rack B" \
    size=48
```

---

## List assets within a rack

```bash
./bin/redfish-inventory racks list-assets 1
```

---

## Delete a rack

```bash
./bin/redfish-inventory racks delete-rack 1
```

---

# API Client

All communication with the backend is handled through a shared `ApiClient`.

Supported HTTP methods:

- GET
- POST
- PATCH
- DELETE

Commands are responsible only for:

- Parsing command-line arguments
- Building request payloads
- Displaying responses

The `ApiClient` is responsible for:

- Making HTTP requests
- Parsing JSON responses
- Raising API errors when requests fail

---

# Production Architecture

The CLI communicates exclusively with the backend REST API.

It never communicates directly with MongoDB or any other database.

Typical flow:

```text
CLI
 │
 ▼
ApiClient
 │
 ▼
REST API
 │
 ▼
Backend
 │
 ▼
Database
```

---

# Asset Creation Workflow

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
Display matching JSON paths
        │
        ▼
User selects one or more fields
        │
        ▼
User enters display names
        │
        ▼
Search again?
      ┌──────────────┐
      │     Yes      │
      └──────┬───────┘
             │
             ▼
     Search JSON again
             │
             ▼
            No
             │
             ▼
Generate asset payload
             │
             ▼
POST asset to backend API
             │
             ▼
Asset created
```