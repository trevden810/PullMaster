-- Texture conversion script
-- This script converts SVG files to BLP format for WoW

local function ConvertSVGtoBLP(svgPath, blpPath)
    -- Check if BLPConv exists
    if not os.execute("which BLPConv") then
        print("Error: BLPConv not found. Please install BLPConv first.")
        return false
    end
    
    -- First convert SVG to PNG using Inkscape
    local pngPath = svgPath:gsub(".svg", ".png")
    local cmd = string.format("inkscape --export-type=png --export-filename=%s %s", pngPath, svgPath)
    
    if os.execute(cmd) then
        -- Now convert PNG to BLP
        cmd = string.format("BLPConv -n -f BLP2 -o %s %s", blpPath, pngPath)
        if os.execute(cmd) then
            -- Clean up temporary PNG
            os.remove(pngPath)
            return true
        end
    end
    
    return false
end

-- Texture directories
local textureDir = "../textures"
local outputDir = "../Interface/AddOns/PullMaster/textures"

-- Create output directory if it doesn't exist
os.execute(string.format("mkdir -p %s", outputDir))

-- Convert all SVG files
local files = {
    "boss_marker",
    "pull_marker",
    "route_arrow",
    "patrol_indicator",
    "loot_indicators/cloth",
    "loot_indicators/leather",
    "loot_indicators/mail",
    "loot_indicators/plate"
}

for _, file in ipairs(files) do
    local svgPath = string.format("%s/%s.svg", textureDir, file)
    local blpPath = string.format("%s/%s.blp", outputDir, file)
    
    print(string.format("Converting %s...", file))
    if ConvertSVGtoBLP(svgPath, blpPath) then
        print("Success!")
    else
        print("Failed to convert " .. file)
    end
end