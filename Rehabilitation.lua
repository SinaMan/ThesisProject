--Initialize variables
init = init or 0
world = world or nil
floor = floor or nil
drsfloor = drsfloor or nil
drsBall = drsBall or nil
visualsBall = visualsBall or {}
drsCone=drsCone or nil
threshold=threshold or 0.5
score=score or 0
reset = reset or 0
obstacles = obstacles or {}
boolean=true
 a=a or 0

--Initialize Physical Objects
leftFeet = leftFeet or nil
rightFeet = rightFeet or nil
walls = walls or nil
listCones = listCones or {}
roof = roof or nil
innerWalls= innerWalls or {}

--Time parameters
nextTime = frametime() + 0.5
-- Time of last spawn of object
lastSpawnTime = lastSpawnTime or frametime()
-- Wait time for next object to fall
waitTime = waitTime or 9

--Experimentation
obst=obst or {}
parentObst=parentObst or {}
parentWalls=parentWalls or {}
obstVisuals=obstVisuals or {}
newVisual=newVisual or {}
hitleft=hitleft or 0
hitright=hitright or 0
heights = heights or {0.1,0.2,0.4}
posLRs = posLRs or {-0.5,0.5}
count = count or 0

--Mathematical functions
Cos = math.cos
Sin = math.sin
Tan = math.tan
pi=math.pi


--Create the boarders of the Game
function createBoarders()

	local posWall=posWall or {}
	local scaleWall=scaleWall or {}
	local rotWall=rotWall or {}
	
	--Position of Walls
	posWall[1]={0, 3.5, -9.7}
	posWall[2]={0, 1, -9.7}
	posWall[3]={-1.4, 2.5, -5}
	posWall[4]={1.4, 2.5, -5}
	posWall[5]={0, 5, 1}
	--posWall[6]={-4, 0.3, -1.9}
	--posWall[7]={4, 0.3, -1.9}
	
	--Scale of Walls
	scaleWall[1]={0.1, 4, 5}
	scaleWall[2]={0.1, 3,3}
	scaleWall[3]={0.1, 6, 20}
	scaleWall[4]={0.1, 6, 20}
	scaleWall[5]={0.1, 22, 4}
	--scaleWall[6]={0.2, 6, 8}
	--scaleWall[7]={0.2, 6, 8}
	
	--Rotation of Walls
	rotWall[1]={0,90,0}
	rotWall[2]={0,90,0}
	rotWall[3]={0,0,0}
	rotWall[4]={0,0,0}
	rotWall[5]={0,90,90}
	--rotWall[6]={0,0,0}
	--rotWall[7]={0,0,0}
	
	--Create Walls of the Game
	for i=1,5 do 
		local wallsVisuals = object.create("Cube","Blue")	
		parentWalls= object.create("Cube","Blue")
		wallsVisuals:setscaling (scaleWall[i][1],scaleWall[i][2],scaleWall[i][3])
		parentWalls:setparent(wallsVisuals)
		roof = w1:createbox(scaleWall[i][1],scaleWall[i][2], scaleWall[i][3], "Static") 
		roof:setposition(posWall[i])
		roof:setorientation(rotWall[i])
		roof:connectdrsobject(wallsVisuals)
		if i==5 then
			parentWalls:hide()
		else
			parentWalls:show()
		end
		parentWalls:setposition(0,10,0)
		--roof:getattacheddrsobject():hide()
	end
	
end

--Distance Function in 3D
function distance3D(t1, t2)
	return math.sqrt((t1[1]-t2[1])^2 + (t1[2]-t2[2])^2 + (t1[3]-t2[3])^2)
end

--Distance Function in 3D
function distancePoints(t1, t2)
	return math.sqrt((t1-t2)^2)
end

function getRandom()
	-- Returns a random value between 5.5 - 9.5
	return math.random(700, 950) / 80
end

function createObject(height,posLR)
	scale={0.5, heights[height], 1}
	local speed=speed or 2.5
	
	obstVisuals = object.create("Cube","Red")	
	parentObst=object.create("Cube","Red")	
	obstVisuals:setscaling (scale[1],scale[2],scale[3])
	obst = w1:createbox(scale[1],scale[2], scale[3], "Static") 
	obst:setposition(posLRs[posLR], 0.6*heights[height],-15)
	obst:connectdrsobject(obstVisuals)
	obst:trackcontacts()
	parentObst:setparent(obstVisuals)
	parentObst:setposition(0,10,0)
	obj = {}
	obj.o = obstVisuals
	--obj.pos = position
	obj.obst = obst
	obj.fallspeed = speed
	return obj
end


function controlObstacle(obj,num)
	local o = obj.obst
	local pos = pos or {}
	pos= o:getposition()
	pos[3] = pos[3] + obj.fallspeed * framedelta()
	o:setposition(posLRs[num], pos[2], pos[3])
	if pos[3]>3 then
		o:getattacheddrsobject():hide()
		o:setposition(posLRs[num],0.2,-9)
		o:getattacheddrsobject():show () 
	end
	o:trackcontacts()
	if rightFeet:hascollision(o) == true then
		hitright=1
	end
	if leftFeet:hascollision(o) == true then
		hitleft=1
	end
end

function intCount(limit)
    count = count + 1
	if count>limit then
		count=1
	end
	return count
end

-- Update Function 
function updateObjects(speed)
	--local o = obst
	hitright=0
	hitleft=0
	local scale={1, 2, 0.5}
	local height = math.random(1,3)
	local posLR = math.random(1,2)
	posLeft = {inputs.get(7), inputs.get(8), inputs.get(9)}
	posRight= {inputs.get(10), inputs.get(11), inputs.get(12)}
	leftFeet:setposition(posLeft)
	rightFeet:setposition(posRight)
	if (frametime() - lastSpawnTime > waitTime) then
		obstacles [#obstacles + 1] = createObject(height,posLR)
		print("hey")
		lastSpawnTime = frametime()
		waitime = frametime() + 2
	end
	
	for i = 1, # obstacles do	
		local o =obstacles
		
		controlObstacle(o[i],a)
	end
	outputs.set("hitleft", hitleft)
	outputs.set("hitright", hitright)
end

--Initilization code
if init~=1 then
	init = 1

	--Physic World
	w1= world.createworld()	
	w1:setworldproperties ("gravity = 9.81; step_size=0.003") 
	w1:creatematerial ("Static", 0)
	w1:creatematerial ("Ball", 10)
	w1:createcontactproperties("Ball-Wall", "friction=0")
	--world:createcontactproperties("Ball-Wall", "friction=0.5;softness_kd=.., softness_kp=..")
	w1:setcontactproperties ( "Static", "Ball", "Ball-Wall") 
	
	--Create Walls and Ball
	floor = w1:createbox(3, 0.2,30, "Static")
	floor:setposition(0,-0.2,0)
	leftFeet = w1:createsphere(0.2, "Ball")
	rightFeet = w1:createsphere(0.2, "Ball")
	drsLeft  = object.create("Sphere", "Red")
	drsRight = object.create("Sphere", "Green")
	drsLeft:setscaling(0.2)
	drsRight:setscaling(0.2)
	drsLeft:collisions (drsLeft) 
	drsRight:collisions (drsRight) 
	
	--[[Create Parent Ball
	drsParLeft = object.create("Sphere", "Red")
	drsParRight = object.create("Sphere", "Green")
	--drsParBall:setcastshadows(true)
	ball:connectdrsobject(drsParBall)]]
	
	drsfloor = object.create("Cube", "Black")
	parentFloor=object.create("Cube", "Green")
	drsfloor:setscaling(3, 0.4, 30)
	parentFloor:setparent(drsfloor)
	parentFloor:setposition(0,10,0)
	
	leftFeet:connectdrsobject(drsLeft)
	rightFeet:connectdrsobject(drsRight)
	floor:connectdrsobject(drsfloor)
	
	rightFeet:trackcontacts()
	leftFeet:trackcontacts()
	
	--drsParBall:setparent(drsBall)
	--drsParBall:setscaling(0.2)
	--drsParBall:setposition(0,17,0)
	--Call functions
	createBoarders()
	
	
	
	--obst=createObstacles(height)
	
	
	
	--[[Radius of the Ring created by cubes
	local radius=radius or {}
	radius[1]=0.61
	radius[2]=0.35
	for i=3,7 do
		radius[i]=0.11
	end
	
	--Position of the Ring
	local posRing= posRing or {}
	for i=1,3 do
		posRing[i]={0,1.1,-7.9}
	end
	posRing[4]={0,1.2,-8.4}
	posRing[5]={0,1.5,-8.9,}
	posRing[6]={1,1.7,-9.3}	
	posRing[7]={-1,1.7,-9.3}
	
	--Rotation of the Ring
	local rotRing={20,10,0}

	--Create a number of Circles
	for i=1,7 do
		--Create a number of circles 
		pos,rot=createRings(radius[i],posRing[i],rotRing[i])
		createPhysic(pos,rot, radius[i])
		--Place the position of the scoring cones, in the centre of the circle
		listCones[i]=createCones(posRing[i],i)
	end	]]
end
