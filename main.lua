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
require "menu"
require "music"


local music

paddle1 = { x = 10, y = love.graphics.getHeight()/2, speed = 200, img = nil, score = 0}
paddle2 = { x = love.graphics.getWidth() - 40, y = love.graphics.getHeight()/2, speed = 200, img = nil, score = 0}
ball = { x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2, speed = { x = 200, y = 200}, img = nil, bonk = nil}
local change = { -1, 1 }
local gameOver = false

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end

function love.load()

    gamestate = "menu"

    medium = love.graphics.setNewFont(12)

    button_spawn(5,50,"Start","start")
    button_spawn(5,200,"Quit","quit")

    ball.img = love.graphics.newImage("sprites/ball.png")
    paddle1.img = love.graphics.newImage("sprites/paddle.png")
    paddle2.img = love.graphics.newImage("sprites/paddle.png")





end



function love.draw()
    if gamestate == "menu" then
        button_draw()
    end
    if gamestate == "playing" then

        if (gameOver == false) then
            love.graphics.draw(ball.img, ball.x, ball.y)
            love.graphics.draw(paddle1.img, paddle1.x, paddle1.y)
            love.graphics.draw(paddle2.img, paddle2.x, paddle2.y)
            love.graphics.print("Score " .. paddle1.score, 100, 50)
            love.graphics.print("Score " .. paddle2.score, love.graphics.getWidth()-100, 50)
        else
            if (paddle1.score >= 10) then
                love.graphics.print("Player 1 Wins!", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
            elseif (paddle2.score >= 10) then
                love.graphics.print("Player 2 Wins!", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
            end
            love.graphics.print("Press 'r' to restart!", love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 20)
        end
    end
end

function love.update(dt)
  if gamestate == "playing" then
        if (love.keyboard.isDown("s")) and (paddle1.y < love.graphics.getHeight() - 24) then
            paddle1.y = paddle1.y + paddle1.speed * dt
        end
        if (love.keyboard.isDown("w")) and (paddle1.y > - 12) then
            paddle1.y = paddle1.y - paddle1.speed * dt
        end

        if (love.keyboard.isDown("l")) and (paddle2.y < love.graphics.getHeight() - 24) then
            paddle2.y = paddle2.y + paddle2.speed * dt
        end
        if (love.keyboard.isDown("o")) and (paddle2.y > - 12) then
            paddle2.y = paddle2.y - paddle2.speed * dt
        end

        if (ball.y >= love.graphics.getHeight() - 24) then
            ball.speed.y = -math.abs(ball.speed.y)
            ball.bonk:play()
        end
        if (ball.y <= -5) then
            ball.speed.y = math.abs(ball.speed.y)
            ball.bonk:play()
        end
        if (ball.x >= love.graphics.getWidth() -24) then
            ball.speed.x = -math.abs(ball.speed.x)
            ball.x = love.graphics.getWidth()/2
            ball.y = love.graphics.getHeight()/2
            ball.bonk:play()
            paddle1.score = paddle1.score + 1
        end
        if (ball.x <= -13) then
            ball.speed.x = math.abs(ball.speed.x)
            ball.x = love.graphics.getWidth()/2
            ball.y = love.graphics.getHeight()/2
            ball.bonk:play()
            paddle2.score = paddle2.score + 1
        end
        if CheckCollision(ball.x + 7, ball.y + 2.5, ball.img:getWidth() - 7 , ball.img:getHeight() -2.5 , paddle1.x + 5, paddle1.y + 5, paddle1.img:getWidth() - 15 , paddle1.img:getHeight() - 5 ) then
            ball.speed.x = math.abs(ball.speed.x)
            ball.speed.y = change[math.random(2)] * ball.speed.y
            ball.bonk:play()
        end
        if CheckCollision(ball.x + 7, ball.y + 2.5, ball.img:getWidth() - 7 , ball.img:getHeight() -2.5 , paddle2.x + 18, paddle2.y + 5, paddle2.img:getWidth() - 15 , paddle2.img:getHeight() - 5 ) then
            ball.speed.x = -math.abs(ball.speed.x)
            ball.speed.y = change[math.random(2)] * ball.speed.y
            ball.bonk:play()
        end
        if (paddle1.score >= 10 or paddle2.score >= 10) then
            ball.speed.x = 0
            ball.speed.y = 0
            gameOver = true
        end
        if (gameOver == true and love.keyboard.isDown('r')) then
            gameOver = false
            paddle1.score = 0
            paddle2.score = 0
            ball.speed.x = 200
            ball.speed.y = 200
            gameMusic:stop()
            gamestate = "menu"
        end
        ball.y = ball.y + ball.speed.y * dt
        ball.x = ball.x + ball.speed.x * dt
    end
end

function love.mousepressed(x, y)
    button_click(x,y)
end
