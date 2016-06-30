require "music"
button = {}

function button_spawn(x,y,text, id)
  table.insert(button, {x = x, y = y, text = text, id = id})
end
function button_draw()
  for i,v in ipairs(button) do
      love.graphics.setColor(255, 255, 255)
      love.graphics.setFont(medium)
      love.graphics.print(v.text,v.x,v.y)
  end
end
function button_click(x,y)
  for i,v in ipairs(button) do
      if
        (x > v.x) and
        (x < (v.x + medium:getWidth(v.text))) and
        (y > v.y) and
        (y < v.y + medium:getHeight(v.text)) then
          if v.id == "quit" then
            love.event.push("quit")
          end
          if v.id == "start"
          then
            gamestate = "playing"
            gameMusic:setVolume(0.1)
            gameMusic:setLooping(true)
            gameMusic:play()
            ball.bonk = love.audio.newSource("sound/Blip_Select.mp3", static)
            ball.bonk:setVolume(0.2)
          end
    end
  end
end
