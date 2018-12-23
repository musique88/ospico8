pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--_functions

function _init()
	state = "mouse"
	mouse = mkmouse(64,64)
	windows = {}
end

function _update()
	mouse:update()
	for w in all(windows) do
		w:update()
	end
end

function _draw()
	cls()
	map(0,0,0,120)
	for w in all(windows) do
		w:draw()
	end
	osupdates()
	mouse:draw()
	debug()
end
-->8
--actual fucntions

function mkmouse(x,y)
	local m = {
		pos = mkvector(x,y),
		acc = mkvector(0,0),
		click = false,
		update = function(self)
			if btn(0) then
				self.acc.x=-1
			elseif btn(1) then
				self.acc.x=1
			else
				self.acc.x=0
			end
			if btn(2) then
			 self.acc.y=-1
			elseif btn(3) then
				self.acc.y=1
			else
				self.acc.y=0
			end
			self.pos.x+=self.acc.x
			self.pos.y+=self.acc.y
			if btn(4) then
				self.click = true
			else
				self.click = false
			end
		end,
		draw = function(self)
			spr(8,self.pos.x,self.pos.y)
		end
	}
	return m
end

function mkwindow(sourcepos)
	local app
	if isinrectangle(mkrectangle(16,120,8,8),
		mouse.pos)then
		app = "firefox"
	elseif isinrectangle(mkrectangle(24,120,8,8),
		mouse.pos)then
		app = "files"
	end
	if isinrectangle(mkrectangle(32,120,8,8),
		mouse.pos)then
		app = "vlc"
	elseif isinrectangle(mkrectangle(40,120,8,8),
		mouse.pos)then
		app = "openoffice"
	end
	local w = {
		app = app,
		id = #windows+1,
		pos = mkvector(rnd(25),rnd(25)),
		size = mkvector(rnd(50)+25,rnd(50)+25),
		update = function(self)
			if isinrectangle(mkrectangle(self.pos.x+4,
			self.pos.y,self.size.x-16,4),mouse.pos) and
			mouse.click then
				local wcpos = #windowconflict+1
				add(windowconflict,self.id)
				if ishigherintable(windowconflict,wcpos) then
 				add(windows,self)
 				del(windows,self)
 				self.pos.x+=mouse.acc.x
 				self.pos.y+=mouse.acc.y
 			end
			end
		end,
		draw = function(self)
			color(1)
			--background plate
			rectfill(self.pos.x,self.pos.y,
			self.pos.x+self.size.x,self.pos.y+self.size.y)
			--x
			sspr(84,0,4,4,self.pos.x+self.size.x-3,self.pos.y)
			--full
			sspr(80,4,4,4,self.pos.x+self.size.x-7,self.pos.y)
			--_
			sspr(84,4,4,4,self.pos.x+self.size.x-11,self.pos.y)
			--icon
			if self.app == "firefox" then
				sspr(72,0,4,4,self.pos.x,self.pos.y)
			elseif self.app == "files" then
				sspr(76,0,4,4,self.pos.x,self.pos.y)
			elseif self.app == "vlc" then
				sspr(72,4,4,4,self.pos.x,self.pos.y)
			elseif self.app == "openoffice" then
				sspr(76,4,4,4,self.pos.x,self.pos.y)
			end
			--random noise for the app(for now)
			color(7)
			rectfill(self.pos.x+1,self.pos.y+5,
				self.pos.x+self.size.x-1,self.pos.y+self.size.y-1)
		end
	}
	return w
end

function osupdates()
	local mousexlubed = flr(mouse.pos.x/8)
	local mouseylubed = flr(mouse.pos.y/8)
	if fget((mget(mousexlubed,
		mouseylubed-15)),0) then
		color(13)
		rect(mousexlubed*8,
		mouseylubed*8,mousexlubed*8+7,
		mouseylubed*8+7)
		if btnp(4) then
			add(windows,mkwindow(mouse.pos))
		end
	end
end
-->8
--utilz

function ishigherintable(table,posintable)
	local temp=true
	for i=1,#table do
		temp = temp and (table[i] <= table[posintable])
	end
	return temp
end

function mkvector(x,y)
	return {x=x,y=y}
end

function mkrectangle(x,y,w,h)
	return {x=x,y=y,w=w,h=h}
end

function debug()
	color(7)
	print(mouse.click)
	print(#windows,0,8)
	print(mouse.pos.x,0,16)
	print(mouse.pos.y,16,16)
end

function isinrectangle(rectangle,pos)
	return rectangle.x <= pos.x and
								rectangle.x+rectangle.w >= pos.x and
								rectangle.y <= pos.y and
								rectangle.y+rectangle.h >= pos.y
end
__gfx__
00000000cc0000cc111111111111111111111111111111111111111111111111050000001cc1ff11111181180000000000000000000000000000000000000000
00000000c077770c1111111111cccc11111111111119911111cccc1111111161565000008ccaffff111118810000000000000000000000000000000000000000
00700700c017710c11111111188ccca11fff1111111661111cc7ccc1111116615665000099a9f55f111118810000000000000000000000000000000000000000
00077000c077770c111111111999caa11ffffff1111991111ccc77c111116661566650001991ffff111181180000000000000000000000000000000000000000
000770000777777011111111199ccaa11f5f5ff1116666111c7cccc111116661566650001ff11cc1999911110000000000000000000000000000000000000000
00700700077777701111111119999a911ff5f5f1119999111cc77cc111111661566550001991cc7c911911110000000000000000000000000000000000000000
000000000997799011111111119999111ffffff11999999111cccc111111116105560000ffffc7cc9119cccc0000000000000000000000000000000000000000
00000000c99cc99c1111111111111111111111111111111111111111111111110000000099991cc19999cccc0000000000000000000000000000000000000000
__gff__
0001000101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0102030405060202020202020202020700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
