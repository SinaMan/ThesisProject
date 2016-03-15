--Initialize variables
init = init or 0
num = num or true 
drsfloor = drsfloor or nil
obst = obst or {}
newObst = newObst or {}
parentObst = parentObst or {}
obHeight = obHeight or 0.1
numberObst=numberObst or 0
leftFeet = leftFeet or nil
rightFeet = rightFeet or nil
obstCubes= obstCubes or inputs.get("cubes")
area=inputs.get("area")
dim=inputs.get("dimensionality")
--Threshold Values
distThreshold = distThreshold or 3
thershold= threshold or 0.0029
bool = bool or true
--Speed of Rolling Sphere
speed=speed or 1.9

--Obstacles Virtual Heights (Changes Randomly)
heights = heights or {0.1,0.15,0.2,0.3} --Virtual height of Obstacles in meters (To be tested)

--Spawn Obstacles Radomly Left / Right
posLR = posLR or {-1.2,-0.15} 

--Position of the Interaction Area (Area that the test subjects have to lift their feet to surpass the obstacles)
posRedInter = posRedInter or {} 
-- Front Interaction Area (Visualize in the 1rst condition)
posRedInter[1] = posRedInter[1] or {0, -0.1, -1} 

-- Seperation between the left/Right foot task
posRedInter[2] = posRedInter[2] or {0, -0.1, 0} 	

-- Floor Interaction Area (Visualize in 2nd & 3rd condition)
posRedInter[3] = posRedInter[3] or {0, -0.1, 7} 

--Interaction Area Scale
scaleRedInter = scaleRedInter or {} 
scaleRedInter[1] = scaleRedInter[1] or {2.5, 0.02, 1}
scaleRedInter[2] = scaleRedInter[2] or {0.1, 0.01,30}	
scaleRedInter[3] = scaleRedInter[3] or {2.5, 0.02, 1}

--Floor Area
posFloor = posFloor or {2.5,-0.1,0.5}
scaleFloor = scaleFloor or {1,1.25,7.76}
rotFloor = rotFloor or {0,0,90}

--Place Walls
posWalls = posWalls or {}
posWalls[1] = posWalls[1] or {1.2,-0.1,-4.2} 	--Left Wall
posWalls[2] = posWalls[2] or {-1.2,-0.1,-4.2} 	--Right Wall
posWalls[3] = posWalls[3] or {0,-0.12,-6.3} 	--Back Wall
posWalls[4] = posWalls[4]	or {-2.2,3.5,-2}  	--Roof
posWalls[5] = posWalls[5] or {1.2,-0.1,11} 		--Left Back Wall
posWalls[6] = posWalls[6] or {-1.2,-0.1,11} 	--Right Back Wall
posWalls[7] = posWalls[7] or {21.2,-0.1,10.2} 	--Parent Wall
posWalls[8] = posWalls[8] or {18.8,-0.1,10.2} 	--\Parent Wall

--Scale of the Walls 
scaleWalls=scaleWalls or {}
scaleWalls[1] = scaleWalls[1] or {0.79,0.9,4.5} 
scaleWalls[2] = scaleWalls[2] or {0.79,0.9,4.5}
scaleWalls[3] = scaleWalls[3] or {0.5,0.9,1.2}  
scaleWalls[4] = scaleWalls[4] or {1.1,1.2,5}    
scaleWalls[5] = scaleWalls[5] or {0.79,0.9,3.09}
scaleWalls[6] = scaleWalls[6] or {0.79,0.9,3.09}
scaleWalls[7] = scaleWalls[7] or {0.79,0.9,4.09}
scaleWalls[8] = scaleWalls[8] or {0.79,0.9,4.09}

--Rotation of the Walls (Depends on the norms applied to the texture)
rotWalls=rotWalls or {}
rotWalls[1] = rotWalls[1] or {0,-180,0}
rotWalls[2] = rotWalls[2] or {0,0,0}
rotWalls[3] = rotWalls[3] or {0,-90,0}
rotWalls[4] = rotWalls[4] or {0,0,-90}
rotWalls[5] = rotWalls[5] or {0,-180,0}
rotWalls[6] = rotWalls[6] or {0,0,0}
rotWalls[7] = rotWalls[7] or {0,-180,0}
rotWalls[8] = rotWalls[8] or {0,0,0}

--Mathematical Functions Shortcuts
Cos = math.cos
Sin = math.sin
Tan = math.tan
Min = math.min
Max = math.max
pi=math.pi
math.randomseed(os.time() )
matfloor=matfloor or nil

--Walls of the Rehabilitation Environment
function createWalls()
	
	--Initialize local Variables
	local walls = walls or nil
	local materialWalls = materialWalls or nil
	
	createFloor()
	createinteractionArea()
	
	-- Create Walls, Parent Walls and add Textures to the Virtual Environment
	for i = 1,8 do
		walls = object.create("wallsection01.mesh")
		materialWalls=walls:getmaterial()
		materialWalls:settexture("blue.jpg")
		materialWalls:settexturescaling(0.8,1)
		if area==0 and i==3 then 
			materialWalls:settexture("backWalls.jpg")
			walls:setposition(posWalls[i][1],posWalls[i][2],posWalls[i][3]-5)
		else
			if i==3 then
				materialWalls:settexture("backWalls.jpg")
			end
			walls:setposition(posWalls[i]) --4 -> 1
		end
		walls:setscaling(scaleWalls[i]) --
		walls:setrotation(rotWalls[i])
	end
end

--Create the Ground
function createFloor()
	textureGround = object.create("wallsection01.mesh")
	textureGround:setposition(posFloor)
	textureGround:setscaling(scaleFloor)
	textureGround:setrotation(rotFloor)
	matfloor=textureGround:getmaterial()
	local parentTexFloor = object.create("wallsection01.mesh")
	parentTexFloor:setposition(posFloor[1]+20,posFloor[2],posFloor[3])
	parentTexFloor:setscaling(scaleFloor)
	parentTexFloor:setrotation(rotFloor)
end

--Create the Interaction Area
function createinteractionArea()
	--Display the Front or the Ground Interaction Area
	if area== 0 then 
		start = 1
		finish=2
	else
		start=2
		finish=3
	end
	
	for i=start,finish do 	 
		wallsVisuals = object.create("pCube1.mesh")
		parentWalls=  object.create("pCube1.mesh")
		text=wallsVisuals:getmaterial()
		text1=parentWalls:getmaterial()
		text:settexture("foot.jpg")
		text1:settexture("foot.jpg")
		text:settexturescaling(0.22,0.3)
		text1:settexturescaling(0.22,0.3)

		wallsVisuals:setscaling (scaleRedInter[i])
		
		parentWalls:setparent(wallsVisuals)
		parentWalls:setposition(20,0,0)
		wallsVisuals:setposition(posRedInter[i])
	end
end

--Distance Function in 3D
function distance3D(t1, t2)
	return math.sqrt((t1[1]-t2[1])^2 + (t1[2]-t2[2])^2 + (t1[3]-t2[3])^2)
end

--Distance Function betweem two points
function distance2D(t1, t2)
	return math.sqrt((t1-t2)^2)
end

function createObst(height, texture)
	--Initialize local variables 
	local posObst = posObst or {}
	local scale = scale or {}
	local obstHeight = obstHeight or 0.2
	local obstMaterial= obstMaterial or nil
	local newMaterial = newMaterial or nil
	local parenObstMat = parenObstMat or nil
	local distInter = distInter or nil

	--Height Position of the feet in Real-life (3D motion data provided by Kinect)
	posLeft = {-1, inputs.get(8),8}
	posRight= {1, inputs.get(11), 8}
	leftFoot:setposition(posLeft)
	rightFoot:setposition(posRight)
	
	--Spawn Obstacles Randomly
	obstHeight= heights[height]
		
	--Scale Obstacles (Depends of their height)
	scale={heights[height], heights[height], heights[height]}
	
	--Get the position of the Obstacles
	posObstacle= obst:getposition()	
	
	--Set the speed of the obstacles in the vertical axes 
	posObstacle[3] = posObstacle[3] + speed * framedelta() --Before speed at 1.5 m/s
	obst:setposition(posObstacle[1], posObstacle[2], posObstacle[3])
	
	--Objects coming towards the player's position
	for i=1,4 do 
		newObst[i]:setparent(obst)
		newObst[i]:setposition(posObstacle[1]+i/distThreshold,posObstacle[2],posObstacle[3])
		parentObst[i]:setparent(obst)
		--Animate Texture to give a perception of a Rolling Motion
		obstMaterial=newObst[i]:getmaterial()
		obstMaterial:settextureoffset(0,-0.7*frametime())
		if dim==0 then
			parentObst[i]:setposition(posObstacle[1]+(20+i/distThreshold),posObstacle[2],posObstacle[3])
			parenObstMat=parentObst[i]:getmaterial()
			parenObstMat:settextureoffset(0,-0.7*frametime())
		else
			parentObst[i]:setposition(posObstacle[1]+(20+i/distThreshold),-0.105,posObstacle[3])
		end
	end
	
	posObst=obst:getposition()
	
	--Event from D-Flow, stop recording data (Only in the interaction areas)
	if bool==false then
		broadcast("PauseRecord")
		bool=true
	end
	
	--Distance that the object will be visualized (Depends on the Front or the Front&Ground Condition)
	posZ,distSpawnObst,obstPosLR=controlObst()
	
	--Change the obstacle's Scale, Height and positioning (Right/Left Foot) after each Trial
	if  posObst[3]> distSpawnObst  then 		
		
	
		obst:setscaling ( scale[2] )
		
		for i=1,4 do 

			parentObst[i]:setparent(obst)
			if obstHeight==0.1 then  --0.2 meter
				obst:setposition (obstPosLR,obstHeight*0.1,posZ)
				newObst[i]:show()
				parentObst[i]:show()
				obHeight=0.1
				distThreshold=4	
			elseif obstHeight==0.15 then  --0.3	meter
				obst:setposition (obstPosLR,obstHeight*0.3,posZ)
				newObst[i]:show()
				parentObst[i]:show()
				if i>2 then
					newObst[i]:hide()
					parentObst[i]:hide()
				end
				obHeight=0.15
				distThreshold=2	
			elseif obstHeight==0.2 then --0.4 meter					
				obst:setposition (obstPosLR,obstHeight*0.5,posZ)
				newObst[i]:show()
				parentObst[i]:show()
				if i>2 then
					newObst[i]:hide()
					parentObst[i]:hide()
				end
				obHeight=0.2
				distThreshold=2
			elseif obstHeight==0.3 then --0.6 meter			
				obst:setposition (obstPosLR,obstHeight*0.62,posZ)
				if i>1 then
					newObst[i]:hide()
					parentObst[i]:hide()
				end	
				obHeight=0.3
				distThreshold=1.5
			end
			
		end
		
		--Number of Spawn Obstacle
		numberObst=numberObst+1
	end
	
	print(obHeight,numberObst)
	
	--Calculate the distance obstacle to the Interaction Area 
	distInter=distanceInteractionArea(posObst)
	
	--Record Subject Performance inside the Interaction Area 
	recordData(posRight,posLeft,obHeight,distInter,numberObst,area)	
end --end createObst

--Area that the obstacles will be visualized (Differences between the Front and the Front&Ground Projection)
function controlObst()
	--Position Obstacles in Horizontal Axes
	local posZ = posZ or nil
	local posX = posX or nil
	local obstPosLR = obstPosLR or 0
	
	posX = math.random(2)
	obstPosLR = posLR[posX]
	
	--Front & Ground Projection 
	if area==0 then
		posZ=-12
		distSpawnObst=1.7
	else 
		posZ=-7 
		distSpawnObst=11
	end

	return posZ,distSpawnObst,obstPosLR
end

--Calculate the distance of the object from the interaction area (z-axes)
function distanceInteractionArea(pos)
	if area==0 then
		dist = distance2D(pos[3], posRedInter[1][3])
	else
		dist = distance2D(pos[3], posRedInter[3][3])
	end
	return dist
end 

--Record Data 
function recordData(posRight,posLeft,obHeight, distInter,numberObst,area)
	
	if (distInter< 0.6)  then
		
		broadcast("Record")	
		print("Record")
		--Difference between position of the feet and hight of obstacle
		local diffRight= posRight[2]-(obHeight*2)
		local diffLeft= posLeft[2]-(obHeight*2)
		
		--Position Left/Right Foot
		outputs.set("footRight",posRight[2])
		outputs.set("footLeft",posLeft[2])
		
		--Height Spawn Obstacle
		outputs.set("obstHeight", (obHeight*2))
		
		--Height of the Feet - Height of the Obstacle
		outputs.set("difRight", diffRight)
		outputs.set("difLeft", diffLeft) 
		
		--Number Spawn Obstacle
		outputs.set("numberObst",numberObst)
		
		--First Interaction Area
		outputs.set("line", area) 
		
		--3D dimensionality 
		outputs.set("dimensions",dim)
	end	
	bool=false
	return bool
end 

-- Update Function
function update(speed, side)
	local posLR = posLR or 0
	local text=inputs.get("texture")
	local speedTreadmill=inputs.get("speed")
	local height = math.random(4)--Height Obstacles
	
	--Start the treadmill
	if speedTreadmill<0.4 then
		speedTreadmill=speedTreadmill+0.01*frametime()
	end
	
	outputs.set("speed", speedTreadmill) 
	
	--Create the obstacles and move them with constant speed 
	--Towards the position of the test subjects
	createObst(height, text) 
end

--Initilization Code
if init~=1 then

	init = 1
	
	--Initialize the sphere obstacle 
	obst=object.create("pSphere1.mesh")
	obst:setscaling(0.1,0.1,0.1)
	obst:setposition(0,0,-15)
	obst:hide()
	obst:setcastshadows(true)

	--Create a Group Parent Obstacles
	for i=1,4 do
		newObst[i]=object.create("pSphere1.mesh")
		newObst[i]:setcastshadows(true)
		parentObst[i]=object.create("pSphere1.mesh")
		--If I have 3D objects
		if dim==1 then
			parentObst[i]:setscaling(1,0.1,1)
		end
		parentObst[i]:setcastshadows(true)
	end	
	
	--Visualize the feet
	leftFoot  = object.create("Sphere", "Red")
	rightFoot = object.create("Sphere", "Green")
	leftFoot:setscaling(0.2,0.1,0.3)
	rightFoot:setscaling(0.2,0.1,0.3)
	
	--Hide left and right foot (No feedback is given to the test subject)
	leftFoot:hide()
	rightFoot:hide()
	
	--Call functions
	createWalls()
end 
