-- next_timeline.lua
require("lualibs")

local modulename = "Next Timeline"

local Timeline = {}
Timeline.__index = Timeline

function Timeline:new(options)
  options = options or {}
  local instance = {
    -- Configuration options with defaults
    datewidth = options.datewidth or 2.3,
    timelinegap = options.timelinegap or 0.5,
    eventgap = options.eventgap or 1.0,
    timelinethickness = options.timelinethickness or 0.1,
    eventpadding = options.eventpadding or 0.3,
    safemargin = options.safemargin or 0.2,
    eventspacing = options.eventspacing or 0.8,

    -- State tracking
    events = {},
    eventcount = 0,
    lastbottom = 0,
    timelinetop = 0.8,
    timelinebottom = -0.8,

    -- Colors and styles
    accentcolor = options.accentcolor or "accent",
    bodycolor = options.bodycolor or "body",
    emphasiscolor = options.emphasiscolor or "emphasis",
  }
  setmetatable(instance, Timeline)
  return instance
end


--- Convert TeX scaled points to centimeters
--- 
--- Performs the complete unit conversion from TeX's internal scaled points (sp)
--- to centimeters through the conversion chain: sp → pt → inches → cm
--- - Convert scaled points to points (65,536 sp = 1 pt)
--- - Convert points to inches (72.27 pt = 1 inch in TeX)
--- - Convert inches to centimeters (1 inch = 2.54 cm)
--- @param value number The value in TeX scaled points (sp) to convert
--- @return number The equivalent value in centimeters (cm)
local function sp_to_cm(value)
  return value / 65536 / 72.27 * 2.54
end

--- Calculate dynamic dimensions for timeline layout
---
--- Computes the available width for timeline elements based on the current
--- line width and configured spacing parameters. This ensures the timeline
--- fits properly within the available space while maintaining proper margins.
---
--- The calculation accounts for:
--- - Date column width
--- - Timeline gaps (left and right sides)
--- - Timeline thickness
--- - Event box padding
--- - Safety margins to prevent overfull boxes
local function calculate_dimensions(self)
  local linewidth_cm = sp_to_cm(tex.dimen.linewidth)

  -- Calculate available width for event box
  self.availablewidth = linewidth_cm - self.datewidth - self.timelinegap - self.eventgap - self.timelinethickness - 2 * self.eventpadding - self.safemargin
  self.eventtextwidth = self.availablewidth - 0.4
end

function Timeline:render_tikz_styles()
  local styles = {}

  -- Calculate dimensions first
  calculate_dimensions(self)

  table.insert(styles, string.format([[
    event/.style={
      rectangle, 
      draw=%s!60, 
      fill=%s!5, 
      thick,
      minimum width=%g cm,
      text width=%g cm,
      align=left,
      rounded corners=4pt,
      inner sep=%g cm
    },]], self.accentcolor, self.bodycolor, self.availablewidth, self.eventtextwidth, self.eventpadding))

  table.insert(styles, string.format([[
    date/.style={
      text width=%g cm,
      align=right,
      anchor=east,
      font=\color{%s}
    },]], self.datewidth, self.emphasiscolor))

  table.insert(styles, string.format([[
    timeline/.style={
      draw=%s!80, 
      thick, 
      line width=2pt
    },]], self.accentcolor))

  table.insert(styles, string.format([[
    dot/.style={
      circle,
      fill=%s,
      minimum size=8pt,
      inner sep=0pt
    },]], self.accentcolor))

  table.insert(styles, string.format([[
    bigcircle/.style={
      circle,
      draw=%s,
      fill=white,
      thick,
      minimum size=15pt,
      inner sep=0pt
    }]], self.accentcolor))

  return table.concat(styles, "\n\t")
end

function Timeline:add_event(date_content, event_content)
  self.eventcount = self.eventcount + 1

  -- Calculate position based on previous event's bottom plus spacing
  local ypos
  if self.eventcount == 1 then
    ypos = 0
  else
    ypos = self.lastbottom - self.eventspacing -- Add spacing below last event
  end

  -- Store event data
  local event = {
    id = self.eventcount,
    date = date_content,
    content = event_content,
    ypos = ypos
  }

  table.insert(self.events, event)

  -- For now, estimate the bottom position (this could be improved with actual text measurement)
  -- Rough estimation: each line is about 0.5cm, assume average of 3 lines per event
  local estimated_height = 1.5
  self.lastbottom = ypos - estimated_height

  -- Update timeline bottom
  self.timelinebottom = self.lastbottom - self.eventspacing
end

function Timeline:render_events()
  local result = {}

  for i, event in ipairs(self.events) do
    -- Coordinate for this event
    table.insert(result, string.format([[\coordinate (pos%d) at (0,%g);]], event.id, event.ypos))

    -- Date/location node (left side)
    table.insert(result, string.format([[\node[date, anchor=north east] (date%d) at ($(pos%d) + (-%g,0)$) {%s};]],
      event.id, event.id, self.timelinegap, event.date))

    -- Content node (right side)
    table.insert(result, string.format([[\node[event, anchor=north west] (event%d) at ($(pos%d) + (%g,0)$) {%s};]],
      event.id, event.id, self.eventgap, event.content))
  end

  return table.concat(result, "\n")
end

function Timeline:render_circles()
  local result = {}

  table.insert(result, [[\begin{pgfonlayer}{circles}]])

  for i, event in ipairs(self.events) do
    -- Big circle with white fill covers the timeline
    table.insert(result, string.format([[\node[bigcircle] at (0, 0 |- date%d.center) {};]], event.id))
    -- Small dot on top of big circle
    table.insert(result, string.format([[\node[dot] at (0, 0 |- date%d.center) {};]], event.id))
  end

  table.insert(result, [[\end{pgfonlayer}]])

  return table.concat(result, "\n")
end

function Timeline:render_timeline_line()
  if self.eventcount == 0 then
    return ""
  end

  return string.format([[
    \begin{pgfonlayer}{background}
      \draw[timeline] (0,%g) -- (0,%g);
    \end{pgfonlayer}]], self.timelinetop, self.timelinebottom)
end

function Timeline:render_complete_tikz()
  if self.eventcount == 0 then
    return ""
  end

  local result = {}

  -- Start tikzpicture with layers and styles
  table.insert(result, [[\pgfdeclarelayer{background}]])
  table.insert(result, [[\pgfdeclarelayer{circles}]])
  table.insert(result, [[\pgfsetlayers{background,circles,main}]])
  table.insert(result, [[\begin{tikzpicture}[]])
  table.insert(result, "    " .. self:render_tikz_styles())
  table.insert(result, "  ]")

  -- Render events
  table.insert(result, "  " .. self:render_events())

  -- Render circles
  table.insert(result, "  " .. self:render_circles())

  -- Render timeline
  table.insert(result, "  " .. self:render_timeline_line())

  table.insert(result, [[\end{tikzpicture}]])

  return table.concat(result, "\n")
end

return Timeline