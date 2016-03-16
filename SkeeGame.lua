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
nextTime = frametime() + 6
radius=radius or {}
speed=speed or 0

--Initialize Physical Objects
ball = ball or nil
walls = walls or nil
listCones = listCones or {}
roof = roof or nil
innerWalls= innerWalls or {}
leftFeet = leftFeet or nil
rightFeet=rightFeet or 0
drsLeft = drsLeft or 0
drsRight= drsRight or 0

--Counters
counter=counter or 1
counter2=counter2 or 1
counter3=counter3 or 1
numTries=numTries or 10
 
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
	
	posWall[1]={0, 3.5, -9.7}
	--posWall[2]={0, 1, 0.7}
	posWall[2]={-1.4, 2.5, -5}
	posWall[3]={1.4, 2.5, -5}
	posWall[4]={0, 5, 1}
	posWall[5]={-1.2, 0.3, -1.9}
	posWall[6]={1.2, 0.3, -1.9}
	
	scaleWall[1]={0.1, 4, 5}
	--scaleWall[2]={0.1, 3,3}
	scaleWall[2]={0.1, 5, 12}
	scaleWall[3]={0.1, 5, 12}
	scaleWall[4]={0.1, 22, 4}
	scaleWall[5]={0.2, 6, 8}
	scaleWall[6]={0.2, 6, 8}
	
	rotWall[1]={0,90,0}
	--rotWall[2]={0,90,0}
	rotWall[2]={0,0,0}
	rotWall[3]={0,0,0}
	rotWall[4]={0,90,90}
	rotWall[5]={0,0,0}
	rotWall[6]={0,0,0}
	
	--Seven Walls of the Game
	for i=1,6 do 
		roof = w1:createbox(scaleWall[i][1],scaleWall[i][2], scaleWall[i][3], "Static") 
		roof:setposition(posWall[i])
		roof:setorientation(rotWall[i])
		roof:getattacheddrsobject():hide()
	end
	
end


--Create Inner Surface
function createInnerWall()
	local orienWalls=orienWalls or {}
	local posWalls=posWalls or {}
	local scaleWalls=scaleWalls or {}
	posWalls[1] = {0, 0.4, -7}
	posWalls[2]= {0, 0.2, -6}
	posWalls[3] = {0, 0.2, -6.2}
	scaleWalls[1] = {7, 0.1,3}
	scaleWalls[2] = {0.3, 0.1,3}
	scaleWalls[3] ={0.1,0.1,3}
	orienWalls[1]={0,90,25}
	orienWalls[2]={0, 90, 30}
	orienWalls[3]={0, 90, 0}
	
	----Three Inner Surfaces
	for i=1,3 do 
		local obstacleVisual = object.create("Cube", "Green")
		obstacleVisual:setscaling(scaleWalls[i])
		innerWalls[i] = w1:createbox(scaleWalls[i][1], scaleWalls[i][2], scaleWalls[i][3], "Static")
		innerWalls[i]:setposition(posWalls[i])
		innerWalls[i]:setorientation(orienWalls[i])
		innerWalls[i]:connectdrsobject(obstacleVisual)
		innerWalls[i]:getattacheddrsobject():hide()
	end
	return innerWalls
end


--Create Objects in a Circle Position
function createRings(radius, posRing)
	local parCube=parCube or nil
	local scale = scale or {}
	local cubes=cubes or {}
	local angle	= angle or 0 
	local degr	= degr or 0
	local npos=npos or {}
	local parentCube = prantCube or nil
	local cubesVisuals= cubesVisuals or {}
	local numberCubes=numerCubes or 7
	local pos=pos or {}
	local rot=rot or {}
	scale={0.1,0.3,0.1}
	
	--Create a parent object
	local parentCube = object.create("Cube","Red")
	parentCube:setscaling (scale[1],scale[2],scale[3])
	parentCube:setposition(0,0,0, "world")	
	parentCube:hide()
	if counter<3  then
		numberCubes= numberCubes+7
	end
	
	for i = 1,numberCubes do				
			scale= {0.02,0.3,4*Tan(pi/numberCubes)*radius}	
			angle=2*pi*i/numberCubes
			degr=-i*360/numberCubes
			cubesVisuals[i] = object.create("Cube","Red")
			
			--Parent all objects to the parent object at centre of the circle position (0,0,0) 
			cubesVisuals[i]:setparent(parentCube);
			cubesVisuals[i]:setscaling (scale[1],scale[2],scale[3])
			cubesVisuals[i]:setposition(2*Cos(angle)*radius,0,2*Sin(angle)*radius, "world")
			cubesVisuals[i]:setorientation (0,degr,0, "world")	
			cubesVisuals[i]:hide()
	end
	
	--Translate and Rotate all objects according to the parent object 
	parentCube:setposition(posRing, "world")
	parentCube:setrotation(25,0,0)
	
	--Store the new position & orientation
	for i=1,numberCubes do 
		pos[i]=cubesVisuals[i]:getposition()
		rot[i]=cubesVisuals[i]:getrotation()
	end 
	counter3=counter3+1
	return pos,rot
end



--Create Circles with Physical cubic objects 
function createPhysic(pos, rot, radius)
	
	local scale = scale or {}
	local cubes=cubes or {}
	local angle	= angle or 0 
	local degr	= degr or 0
	local parentCube = prantCube or nil
	scale={0.1,0.3,0.1}
	setmaxobjects(200) 
	local numberCubes=numerCubes or 7
	--Less Cubes combined in the smaller circles
	if counter<3  then
		numberCubes=numberCubes+7
	end

	--Create Physical Objects: Ring Objects
	for i = 1,numberCubes do
			degr=-i*360/numberCubes
			scale= {0.02,0.3,4*Tan(pi/numberCubes)*radius}
			local cubesVisuals = object.create("Cube","Blue")	
			cubesVisuals:setscaling (scale[1],scale[2],scale[3])
			cubes[i] = w1:createbox(scale[1],scale[2],scale[3],"Static")	
			cubes[i]:setposition(pos[i][1],pos[i][2],pos[i][3])
			cubes[i]:setorientation(rot[i][1],rot[i][2],rot[i][3])
			cubes[i]:connectdrsobject(cubesVisuals)	
			cubes[i]:getattacheddrsobject():hide()
			
			--Disconnect half circle
			if counter==1 then
				if -degr>160  then
					cubes[i]:disablecontrol () 
					cubes[i]:disconnectdrsobject()
					cubes[i]:destroybody()
				end
			end
	end
	
	counter=counter+1
end

--Collision Cones to track Collision with the Ball inside the rings
function createCones(pos, number)
	local scale={0.05,0.25,0.1}
	
	--Place Cones
	if counter2==1 then
		pos={0,0.4,-6.79}
	elseif (counter2==2) then
		pos={0,0.6,-7.3}
	elseif (counter2==3) then
		pos={0,0.8,-7.9}
	elseif (counter2==4 ) then
		pos={0,1.05,-8.4}
	elseif (counter2==5) then
		pos={0,1.3,-8.9}
	elseif (counter2==6) then
		pos={-1,1.45,-9.3}
	else 
		pos={1,1.45,-9.3}
	end
	
	cones=w1:createbox(scale[1],scale[2],scale[3],"Static")
	cones:setposition(pos)
	coneVisuals = object.create("Cone","Red")
	coneVisuals:setscaling (scale)
	cones:connectdrsobject(coneVisuals)
	cones:trackcontacts()
	cones:getattacheddrsobject():hide()
	counter2=counter2+1
	return cones
end

--Distance Function in 3D
function distance3D(t1, t2)
	return math.sqrt((t1[1]-t2[1])^2 + (t1[2]-t2[2])^2 + (t1[3]-t2[3])^2)
end

--Distance Function in 3D
function distancePoints(t1, t2)
	return math.sqrt((t1-t2)^2)
end

function getRandomForce()
	-- Returns a random force between 1 - 2
	return math.random(100, 200) / 200 
end

-- Update Function 
function updateObjects()
	local posBall=ball:getposition()
	
	--Position of the Feet of the user
	posLeft = {inputs.get(7), inputs.get(8), inputs.get(9)}
	posRight= {inputs.get(10), inputs.get(11), inputs.get(12)}
	leftFeet:setposition(posLeft[1],17,posLeft[3])
	rightFeet:setposition(posRight[1],17,posRight[3])
	
	--Calculate the distance Between Ball-Feet
	distLeft=distance3D(posBall,posLeft)
	distRight=distance3D(posBall,posRight)
	
	--If distance small than a threshold apply force
	if posLeft[2]<0.2 and distLeft<threshold then
		--ball:setcontrolbaseforce(0, 0, -speed)
		deceltime = deceltime or frametime() 
		speedBall = speed - 0.005*(frametime() + deceltime) 
		ball:setcontrolbaseforce(0,0,speedBall)
		broadcast("Action")
		reset = 1
	end
	
	if posRight[2]<0.2 and distRight<threshold then
		--ball:setcontrolbaseforce(0, 0, -speed)
		deceltime = deceltime or frametime() 
		speedBall = speed - 0.005*(frametime() + deceltime) 
		ball:setcontrolbaseforce(0,0,speedBall)
		broadcast("Action")
		reset = 1
	end
	
	if (reset == 1) then
		reset = 0
		ball:setcontrolbaseforce(0, 0, 0)
	end
	if (reset == 2) then
		reset = 0
		ball:setcontrolbaseforce(0, 0, 0.1)
	end
	
	--Check if the Ball inside the score location
	for i = 1, #listCones do
		if listCones[i] ~= nil then
			--The Ball inside the Ring
			if (ball:hascollision (listCones[i])) == true then
				if (i<3) then
					if frametime() > nextTime then
						if (i==1) then
							score = score +10
						elseif (i==2) then
							score =score + 20
						end
						numTries=numTries-1
						visualsBall[numTries+1]:destroy()
						ball:getattacheddrsobject():hide()
						ball:setposition(-0.7, 0.4, -5)
						ball:setcontrolbaseforce(0, 0,getRandomForce()*9.81*0.5)
						ball:getattacheddrsobject():show ()
						nextTime = frametime() + 6
						reset=2
					end
				else 
					if (i==3) then
						score=score + 30
					elseif (i==4) then
						score=score + 40
					elseif (i==5) then
						score=score + 60
					elseif (i>5) then
						score=score + 100
					end
					numTries=numTries-1
					visualsBall[numTries+1]:destroy()
					ball:getattacheddrsobject():hide()
					ball:setposition(-0.7, 0.4, -5)
					ball:setcontrolbaseforce(0, 0,getRandomForce())
					ball:getattacheddrsobject():show ()
				end
			elseif (ball:hascollision(innerWalls[3]))==true then 
				--The Ball outside the Ring: Lost Try
				if (frametime() > nextTime) then 
					numTries=numTries-1
					visualsBall[numTries+1]:destroy()
					ball:getattacheddrsobject():hide()
					ball:setcontrolbaseforce(1, 0,getRandomForce())
					ball:setposition(0.7, 0.4, -5)
					ball:getattacheddrsobject():show () 
					nextTime = frametime() + 6		
					reset=2				
				end
			end
		end
	end
	if (posBall[3]>1) then
		numTries=numTries-1
		visualsBall[numTries+1]:destroy()
		ball:getattacheddrsobject():hide()
		ball:setposition(0, 0.3, 0)
		ball:setlinearvelocity(0,0,0)
		ball:getattacheddrsobject():show () 
	end
end

--Initilization code
if init~=1 then
	init = 1
	camera=objects.get(1)
	camera:setnearplane(2) 

	--Physic World
	w1= world.createworld()	
	w1:setworldproperties ("gravity = 9.81; step_size=0.003") 
	w1:creatematerial ("Static", 0)
	w1:creatematerial ("Ball", 10)
	w1:createcontactproperties("Ball-Wall", "friction=0")
	--world:createcontactproperties("Ball-Wall", "friction=0.5;softness_kd=.., softness_kp=..")
	w1:setcontactproperties ( "Static", "Ball", "Ball-Wall") 
	
	--Create Walls and Ball
	floor = w1:createbox(3, 0.2,12, "Static")
	ball = w1:createsphere(0.2, "Ball")
	drsBall = object.create("Sphere", "Red")
	--drsBall:setcastshadows(true)
	drsBall:setscaling(0.2)
	drsBall:collisions (drsBall) 
	
	--Create Parent Ball
	drsParBall = object.create("Sphere", "Red")
	--drsParBall:setcastshadows(true)
	ball:connectdrsobject(drsParBall)
	
	--Left-Right Feet visualization
	leftFeet = w1:createsphere(0.2, "Ball")
	rightFeet = w1:createsphere(0.2, "Ball")
	drsLeft  = object.create("Sphere", "Blue")
	drsRight = object.create("Sphere", "Green")
	drsLeft:setscaling(0.2)
	drsRight:setscaling(0.2)
	drsLeft:collisions (drsLeft) 
	drsRight:collisions (drsRight) 
	leftFeet:connectdrsobject(drsLeft)
	rightFeet:connectdrsobject(drsRight)
	rightFeet:trackcontacts()
	leftFeet:trackcontacts()
	
	drsfloor = object.create("Cube", "Black")
	drsfloor:setscaling(3, 0.2, 12)
	ball:connectdrsobject(drsBall)
	floor:connectdrsobject(drsfloor)
	floor:getattacheddrsobject():hide()
	ball:setposition(0, 0.3, 0)
	ball:trackcontacts()
	
	drsParBall:setparent(drsBall)
	drsParBall:setscaling(0.2)
	drsParBall:setposition(0,17, 0)
	--Call functions
	createBoarders()
	ball:enablecontrol ()
	innerWalls=createInnerWall()
	
	--Visualize User Number of Tries
	for i=1,numTries do 
		visualsBall[i] = object.create("Sphere", "Red")
		visualsBall[i]:setscaling(0.2)
		visualsBall[i]:setposition(1.25, 17.1, -1.4+i/5)
	end
	
	--Radius of the Ring created by cubes
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
	end	
end




