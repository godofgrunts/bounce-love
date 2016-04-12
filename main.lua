--[[
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
--]]

local music
local bonk

local paddle1
local paddle2
local pw -- paddle width
local ph -- paddle height
local ball

local p1y
local p2y

local bxs -- ball x speed
local bys -- ball y speed
local bx
local by

local screen_width = 500
local screen_height = 300

function love.load()

    love.window.setTitle('Bounce')
    love.window.setMode(screen_width, screen_height)
    ball = love.graphics.newImage("sprites/ball.png")
    paddle1 = love.graphics.newImage("sprites/paddle.png")
    paddle2 = love.graphics.newImage("sprites/paddle.png")
    p1y = love.graphics.getHeight()/2
    p2y = love.graphics.getHeight()/2
    bxs = -300 -- always starts the same
    bys = 300 -- always starts the same
    bx = love.graphics.getWidth()/2
    by = love.graphics.getHeight()/2
    pw = paddle1:getWidth()
    ph = paddle1:getHeight()
    music = love.audio.newSource("sound/fight_looped.wav", static)
    music:play()
    bonk = love.audio.newSource("sound/Blip_Select.mp3", static)

end



function love.draw()

    love.graphics.draw(ball, bx, by)
    love.graphics.draw(paddle1, -10, p1y)
    love.graphics.draw(paddle2, love.graphics.getWidth() - 20, p2y)

end

function love.update(dt)

    if (love.keyboard.isDown("s")) and (p1y < love.graphics.getHeight() - 24) then
        p1y = p1y + 200 * dt
    end
    if (love.keyboard.isDown("w")) and (p1y > - 12) then
        p1y = p1y - 200 * dt
    end

    if (love.keyboard.isDown("l")) and (p2y < love.graphics.getHeight() - 24) then
        p2y = p2y + 200 * dt
    end
    if (love.keyboard.isDown("o")) and (p2y > - 12) then
        p2y = p2y - 200 * dt
    end

    if (by >= love.graphics.getHeight() - 24) then
        bys = -math.abs(bys)
        bonk:play()
    end
    if (by <= -5) then
        bys = math.abs(bys)
        bonk:play()
    end
    if (bx >= love.graphics.getWidth() -24) then
        bxs = -math.abs(bxs)
        bonk:play()
    end
    if (bx <= -13) then
        bxs = math.abs(bxs)
        bonk:play()
    end

    by = by + bys * dt
    bx = bx + bxs * dt
end