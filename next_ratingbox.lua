-- next_ratingbox.lua
local modulename = "Next RatingBox"

local RatingBox = {}
RatingBox.__index = RatingBox

function RatingBox:new(accent_color, muted_color, max, spacing)
  local instance = {
    accent_color = accent_color or "accent",
    muted_color = muted_color or "body!30",
    max = max or 5,
    spacing = spacing or "1em",
  }
  setmetatable(instance, RatingBox)
  return instance
end

function RatingBox:render_rating(rating)
  local result = {}

  -- Start accessibility support
  table.insert(result, [[\BeginAccSupp{method=plain,ActualText={]] .. rating .. [[}}]])

  for i = 1, self.max do
    local half_step = i - 0.5

    if math.abs(rating - half_step) < 0.01 then
      -- Half-filled marker
      table.insert(result, [[\clipbox*{0pt 0pt {.5\width} {\height}}{\color{]].. self.accent_color ..[[}{\nextRatingMarker}}]])
      table.insert(result, [[\clipbox*{{.5\width} 0pt {\width} {\height}}{\color{]].. self.muted_color ..[[}{\nextRatingMarker}}]])
    else
      -- Full or empty marker
      if i > rating then
        table.insert(result, [[\color{]].. self.muted_color ..[[}{\nextRatingMarker}]])
      else
        table.insert(result, [[\color{]].. self.accent_color ..[[}{\nextRatingMarker}]])
      end
    end

    -- Add spacing between markers except after the last one
    if i < self.max then
      table.insert(result, [[\hspace{]] .. self.spacing .. [[}]])
    end
  end

  -- End accessibility support
  table.insert(result, [[\EndAccSupp{}]])

  return table.concat(result)
end

return RatingBox