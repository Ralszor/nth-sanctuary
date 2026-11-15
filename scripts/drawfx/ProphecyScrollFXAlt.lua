---@class ProphecyScrollFX: FXBase
local ProphecyScrollFXAlt, super = Class(FXBase)

function ProphecyScrollFXAlt:init(outline, texture, priority, options)
    super.init(self, priority)
    ---@type love.Image
    self.texture = type(texture) == "string" and Assets.getTexture(texture) or (type(texture) == "userdata" and texture)
    self.texture = self.texture or Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_SEAMLESS")
    self.surf_textured = -1;
    self.tile_object = 364;
    self.base_texture = 88;
    self.scroll_texture = 991;
    self.fade_time_seconds = 4;
    self.fade_from = 0;
    self.fade_to = 1;
    self.scroll_speed = 1;
    self.tick = 0;
    self.intro_mode = false;
	self.outline = outline or nil
    self.options = options or {}
    self.drawcolor = ColorUtils.hexToRGB(self.options["color"] or "#42D0FF")

end

function ProphecyScrollFXAlt:update()
    self.tick = self.tick + ((1/15) * self.scroll_speed * DTMULT)
end

local function draw_sprite_tiled_ext(tex, _, x, y, sx, sy, color, alpha)
    local r,g,b,a = love.graphics.getColor()
    if color then
        Draw.setColor(color, alpha)
    end
    Draw.drawWrapped(tex, true, true, x, y, 0, sx, sy)
    love.graphics.setColor(r,g,b,a)
end

local function draw_set_alpha(a)
    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(r,g,b,a)
end

function ProphecyScrollFXAlt:draw(texture)
    self:drawPart(texture, Ch4Lib.scr_wave(0, 0.4, 4, 0))
end

local function oldHexToRgb(hex, value)
    local color = ColorUtils.hexToRGB(hex)
    return {
        color[1],
        color[2],
        color[3],
        color[4] * (value or 1),
    }
end

function ProphecyScrollFXAlt:drawPart(texture, alpha)

    local parent = self.parent
    for i = 1, 4 do
        parent = parent.parent or parent
        if parent:includes(World) then
            ---@cast parent World
            parent = parent.map.tile_layers[1] or parent.map.image_layers[1] or parent.map.events[1]
        end
    end

    local _cx, _cy = parent:getScreenPos()
    _cx, _cy = -_cx, -_cy

    local surf_textured = Draw.pushCanvas(640, 480);
	love.graphics.clear(self.drawcolor, 0);
    local pnl_tex = Assets.getTexture("backgrounds/perlin_noise_looping")
	local pnl_canvas = Draw.pushCanvas(pnl_tex:getDimensions())
	draw_sprite_tiled_ext(pnl_tex, 0, 0, 0, 1, 1, self.drawcolor)
	Draw.popCanvas(true)
	local x, y = -((_cx * 2) + ((Kristal.getTime()) * 30)) * 0.5, -((_cy * 2) + ((Kristal.getTime()) * 30)) * 0.5
	draw_sprite_tiled_ext(Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_SEAMLESS"), 0, x, y, 2, 2, oldHexToRgb("#FFFFFF", 0.6));
	local orig_bm, orig_am = love.graphics.getBlendMode()
	love.graphics.setBlendMode("add", "premultiplied");
	draw_sprite_tiled_ext(pnl_canvas, 0, x, y, 2, 2, COLORS.white)
	love.graphics.setBlendMode(orig_bm, orig_am);
    Draw.popCanvas()

	Draw.setColor(1,1,1,1)
	if self.outline then
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			local shader = Kristal.Shaders["Mask"]
			love.graphics.setShader(shader)
			Draw.draw(texture, -self.outline, -self.outline)
			Draw.draw(texture, self.outline, self.outline)
			Draw.draw(texture, self.outline, -self.outline)
			Draw.draw(texture, -self.outline, self.outline)
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(0,0,0.4,0.5)
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		Draw.setColor(0.3,0.3,0.6,0.2)
		Draw.drawCanvas(surf_textured)
		love.graphics.setStencilTest()
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			local shader = Kristal.Shaders["Mask"]
			love.graphics.setShader(shader)
			Draw.draw(texture, -self.outline, 0)
			Draw.draw(texture, self.outline, 0)
			Draw.draw(texture, 0, -self.outline)
			Draw.draw(texture, 0, self.outline)
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		Draw.setColor(0,0,0.5,1)
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		Draw.setColor(0.5,0.5,0.7,0.5)
		Draw.drawCanvas(surf_textured)
		love.graphics.setStencilTest()
		Draw.setColor(1,1,1,1)
		love.graphics.setBlendMode("add");
	end
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
		local shader = Kristal.Shaders["Mask"]
        love.graphics.setShader(shader)
        Draw.draw(texture)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    Draw.drawCanvas(surf_textured);
	love.graphics.setBlendMode("alpha");
    love.graphics.setStencilTest()
end


return ProphecyScrollFXAlt