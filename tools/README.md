# Texture Conversion Tools

## Requirements

- Inkscape (for SVG to PNG conversion)
- BLPConv (for PNG to BLP conversion)

## Usage

1. Install requirements:
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install inkscape
   
   # Download and install BLPConv from WoW Model Viewer project
   ```

2. Run the conversion script:
   ```bash
   lua convert_textures.lua
   ```

This will convert all SVG files in the textures directory to BLP format suitable for WoW.

## Adding New Textures

1. Add your SVG file to the appropriate directory under `textures/`
2. Add the filename (without extension) to the `files` table in `convert_textures.lua`
3. Run the conversion script
