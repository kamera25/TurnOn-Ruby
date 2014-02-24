require "sdl"
require "lib/fpstimer"


count = 4

SDL.init(SDL::INIT_EVERYTHING)

SDL::WM.set_caption("Turn on", "img/icon.ico")

title = SDL::Surface.load("img/turnoff_title.png")
ton = SDL::Surface.load("img/turnon.png")
toff = SDL::Surface.load("img/turnoff.png")
up = SDL::Surface.load("img/up.png")
down = SDL::Surface.load("img/down.png")
start = SDL::Surface.load("img/start.png")

three = SDL::Surface.load("img/three.png")
four = SDL::Surface.load("img/four.png")
five = SDL::Surface.load("img/five.png")
six = SDL::Surface.load("img/six.png")
clearlogo = SDL::Surface.load("img/clear.png")
bak = false
clear = false
timer = FPSTimerLight.new
timer.reset
SDL::TTF.init
font = SDL::TTF.open("fonts-japanese-gothic.ttf",32,0)
SDL::Mixer.open   # 音声の初期化
ton_se = SDL::Mixer::Wave.load("turnon.wav")


loop do

SCREEN_W = 640
SCREEN_H = 480
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)



loop do  
  #キーが「押されたかどうか」を調べる
  while event=SDL::Event2.poll
    case event
    when SDL::Event2::Quit #ウィンドウの×ボタンが押された
      exit
    when SDL::Event2::KeyDown
      exit if event.sym == SDL::Key::ESCAPE
    end
  end

	screen.put(title, 0, 0)
	screen.put(up, SCREEN_W/2-25, 220)
	screen.put(down, SCREEN_W/2-25, 350)
	screen.put(start, SCREEN_W/2-50, 410)

	if (count == 3) then
		screen.put(three, SCREEN_W/2-25, 290)
	elsif( count == 4) then
		screen.put(four, SCREEN_W/2-25, 290)
	elsif( count == 5) then
		screen.put(five, SCREEN_W/2-25, 290)
	else
		screen.put(six, SCREEN_W/2-25, 290)
	end

	if SCREEN_W/2-25 < SDL::Mouse.state[0] && SDL::Mouse.state[0] < SCREEN_W/2+25 && 220 < SDL::Mouse.state[1] && SDL::Mouse.state[1] < 270 && SDL::Mouse.state[2] == true && bak == false 
		count=count+1
		if(6<count) then
			count = 6		
		end
	elsif SCREEN_W/2-25 < SDL::Mouse.state[0] && SDL::Mouse.state[0] < SCREEN_W/2+25 && 350 < SDL::Mouse.state[1] && SDL::Mouse.state[1] < 400 && SDL::Mouse.state[2] == true && bak == false 
		count=count-1
		if(count < 3) then
			count = 3		
		end
	elsif SCREEN_W/2-50 < SDL::Mouse.state[0] && SDL::Mouse.state[0] < SCREEN_W/2+50 && 410 < SDL::Mouse.state[1] && SDL::Mouse.state[1] < 460 && SDL::Mouse.state[2] == true && bak == false 
		break;
	end

	screen.update_rect(0, 0, 0, 0)

	bak = SDL::Mouse.state[2]

  timer.wait_frame do
    screen.update_rect(0, 0, 0, 0)
  end
end



#main game
SCREEN_W = count * 101 
SCREEN_H = count * 101 + 140
click= 0
clear = false
t = Time.now
screen = SDL.set_video_mode(SCREEN_W, SCREEN_H, 16, SDL::SWSURFACE)
tmap = Array.new(count+2).map!{Array.new}

i=0
while i < count+2
	j=0
	while j < count+2

		if rand(2) == 1 then
			tmap[i][j] = false	
		else
			tmap[i][j] = true	
		end		
		
		j = j+1	
	end

	i = i + 1
end

loop do  
	if clear == true then
		break
	end
	clear = true

  while event=SDL::Event2.poll
    case event
    when SDL::Event2::Quit #ウィンドウの×ボタンが押された
      exit
    when SDL::Event2::KeyDown
      exit if event.sym == SDL::Key::ESCAPE
    end
  end

screen.fill_rect(0, 0, SCREEN_W, SCREEN_H, [240, 240, 240])


i=0
while i < count
	j=0
	while j < count
			if tmap[i+1][j+1] == false then
				clear = false
			end
			j = j+1	
	end
	i = i + 1
end

i=0
while i < count
	j=0
	while j < count
			if tmap[i+1][j+1] == true then
				screen.put(ton, i*101, j*101)
			elsif
				screen.put(toff, i*101, j*101)

			end		




			#key check
			if i*101 < SDL::Mouse.state[0] && SDL::Mouse.state[0] < i*101+100 && j*101 < SDL::Mouse.state[1] && SDL::Mouse.state[1] < j*101+100 && SDL::Mouse.state[2] == true && bak == false  then
				tmap[i+1][j+1] = !tmap[i+1][j+1]
				tmap[i+1+1][j+1] = !tmap[i+1+1][j+1]
				tmap[i+1-1][j+1] = !tmap[i+1-1][j+1]
				tmap[i+1][j+1+1] = !tmap[i+1][j+1+1]
				tmap[i+1][j+1-1] = !tmap[i+1][j+1-1]
				SDL::Mixer.play_channel(-1, ton_se, 0)    # 効果音を鳴らす
				click = click + 1
			end
	
			j = j+1	
	end

	i = i + 1
end



	bak = SDL::Mouse.state[2]
	nowt = (Time.now - t).to_f.round
	#render
	font.draw_blended_utf8(screen,"Turn On/Off : #{click}",10,count*100 + 30,170,170,170)
	font.draw_blended_utf8(screen,"Time : #{nowt}",10,count*100 + 80,170,170,170)

	if( clear == true) then
		screen.put(clearlogo, SCREEN_W/2-100, SCREEN_H/2 - 80)
	end

	screen.update_rect(0, 0, 0, 0)
  timer.wait_frame do
    screen.update_rect(0, 0, 0, 0)
  end	

end



sleep(3)

end
