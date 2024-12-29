# Tab2SVG

A command-line tool that converts guitar ASCII tablatures to SVG format for better visualization and sharing.

## Setup

```bash
# Clone the repository
git clone [repository-url] tab2svg
cd tab2svg

# Run setup script
chmod +x setup.sh
./setup.sh

# Build the project
dune build

# Run tests
dune test
```

## Project Structure

```
tab2svg/
├── bin/            # Binary executables
├── lib/            # Core library code
│   ├── parser/     # Tab parsing components
│   └── svg/        # SVG generation components
├── test/           # Test suites
└── dune-project    # Project configuration
```

## Development

The project follows a modular design pattern with clear separation of concerns:

1. Parser module:
   - Lexical analysis of ASCII tab input
   - Parsing into structured representation
   - Error handling for malformed input

2. SVG module:
   - Vector graphics generation
   - Layout management
   - Style handling

## Testing

Run the test suite:

```bash
dune test
```

## Contributing

1. Follow OCaml formatting guidelines (enforced by ocamlformat)
2. Ensure all tests pass
3. Add tests for new features
4. Update documentation as needed

## License

MIT License