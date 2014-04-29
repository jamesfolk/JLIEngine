


local GGJ = {}
GGJ.__index = GGJ


function GGJ.new()
    local self = setmetatable({}, GGJ)
    self.textureIDs = {}
    self.meshIDs = {}
    
    self.textureIDs["conetexture1"] = jli.TextureFactory_createTextureFromData("conetexture1")
    self.textureIDs["cubetexture1"] = jli.TextureFactory_createTextureFromData("cubetexture1")
    self.textureIDs["floor"] = jli.TextureFactory_createTextureFromData("floor")
    self.textureIDs["spheretexture"] = jli.TextureFactory_createTextureFromData("spheretexture")
    self.textureIDs["walltexture"] = jli.TextureFactory_createTextureFromData("walltexture")
    
--    self.meshIDs["cube"] = jli.VertexBufferObjectFactory_createViewObject("cube", self.textureIDs["cubetexture1"]);
--    self.meshIDs["planeobject"] = jli.VertexBufferObjectFactory_createViewObject("planeobject", self.textureIDs["floor"]);
--    self.meshIDs["raycone"] = jli.VertexBufferObjectFactory_createViewObject("raycone", self.textureIDs["conetexture1"]);
--    self.meshIDs["skybox"] = jli.VertexBufferObjectFactory_createViewObject("skybox", self.textureIDs["walltexture"]);
--    self.meshIDs["sphere"] = jli.VertexBufferObjectFactory_createViewObject("sphere", self.textureIDs["spheretexture"]);
    
    
--    self.meshIDs["cube"] = jli.ViewObjectFactory_createViewObject("cube", self.textureIDs["cubetexture1"]);
--    self.meshIDs["planeobject"] = jli.ViewObjectFactory_createViewObject("planeobject", self.textureIDs["floor"]);
--    self.meshIDs["raycone"] = jli.ViewObjectFactory_createViewObject("raycone", self.textureIDs["conetexture1"]);
--    self.meshIDs["skybox"] = jli.ViewObjectFactory_createViewObject("skybox", self.textureIDs["walltexture"]);
--    self.meshIDs["sphere"] = jli.ViewObjectFactory_createViewObject("sphere", self.textureIDs["spheretexture"]);
    
    return self
end

function GGJ.getTextureID(self, name)
    return self.textureIDs[name]
end

function GGJ.getMeshID(self, name)
    return self.meshIDs[name]
end

function GGJ.createViewObject(self, amt, name, textureID, shaderID)
    self.meshIDs[name] = jli.VertexBufferObjectFactory_createViewObject(amt, name, textureID, shaderID)
end























-- Start cube Collision Response Functions -----------------------------------------------
function cubeCollisionResponse(currentEntity, otherEntity, point)
    --print("cubeCollisionResponse")
    local cr = currentEntity:getCollisionResponseBehavior()
--    cr:reset()
    --print("collide " .. currentEntity:getName())
end
-- End   cube Collision Response Functions -----------------------------------------------

-- Start planeobject Collision Response Functions -----------------------------------------------
function planeobjectCollisionResponse(currentEntity, otherEntity, point)
    --print("planeobjectCollisionResponse")
    local cr = currentEntity:getCollisionResponseBehavior()
--    cr:reset()
    --print("collide " .. currentEntity:getName())
end
-- End   planeobject Collision Response Functions -----------------------------------------------

-- Start raycone Collision Response Functions -----------------------------------------------
function rayconeCollisionResponse(currentEntity, otherEntity, point)
    --print("rayconeCollisionResponse")
    local cr = currentEntity:getCollisionResponseBehavior()
--    cr:reset()
    --print("collide " .. currentEntity:getName())
end
-- End   raycone Collision Response Functions -----------------------------------------------

-- Start skybox Collision Response Functions -----------------------------------------------
function skyboxCollisionResponse(currentEntity, otherEntity, point)
    --print("skyboxCollisionResponse")
    local cr = currentEntity:getCollisionResponseBehavior()
--    cr:reset()
    --print("collide " .. currentEntity:getName())
end
-- End   skybox Collision Response Functions -----------------------------------------------

-- Start sphere Collision Response Functions -----------------------------------------------
function sphereCollisionResponse(currentEntity, otherEntity, point)
    print("sphereCollisionResponse")
    local cr = currentEntity:getCollisionResponseBehavior()
    --print("collide " .. currentEntity:getName())
end
-- End   sphere Collision Response Functions -----------------------------------------------

-- Start cube State Functions -----------------------------------------------
function cubeEnterState(currentEntity)
    --print("cubeEnterState")
end
function cubeUpdateState(currentEntity, deltaTimeStep)
--    --print("cubeUpdateState")
--    --print(currentEntity)
end
function cubeExitState(currentEntity)
    --print("cubeExitState")
end
function cubeOnMessage(currentEntity, telegram)
    --print("cubeOnMessage")
end
-- End   cube State Functions -----------------------------------------------

-- Start planeobject State Functions -----------------------------------------------
function planeobjectEnterState(currentEntity)
    --print("planeobjectEnterState")
end
function planeobjectUpdateState(currentEntity, deltaTimeStep)
    --print("planeobjectUpdateState")
end
function planeobjectExitState(currentEntity)
    --print("planeobjectExitState")
end
function planeobjectOnMessage(currentEntity, telegram)
    --print("planeobjectOnMessage")
end
-- End   planeobject State Functions -----------------------------------------------

-- Start raycone State Functions -----------------------------------------------
function rayconeEnterState(currentEntity)
--    --print("rayconeEnterState")
end
function rayconeUpdateState(currentEntity, deltaTimeStep)
--    --print("rayconeUpdateState")
end
function rayconeExitState(currentEntity)
--    --print("rayconeExitState")
end
function rayconeOnMessage(currentEntity, telegram)
--    --print("rayconeOnMessage")
end
-- End   raycone State Functions -----------------------------------------------

-- Start skybox State Functions -----------------------------------------------
function skyboxEnterState(currentEntity)
    --print("skyboxEnterState")
end
function skyboxUpdateState(currentEntity, deltaTimeStep)
    --print("skyboxUpdateState")
end
function skyboxExitState(currentEntity)
    --print("skyboxExitState")
end
function skyboxOnMessage(currentEntity, telegram)
    --print("skyboxOnMessage")
end
-- End   skybox State Functions -----------------------------------------------

-- Start sphere State Functions -----------------------------------------------
function sphereEnterState(currentEntity)
    --print("sphereEnterState")
end
function sphereUpdateState(currentEntity, deltaTimeStep)
    print("sphereUpdateState")
end
function sphereExitState(currentEntity)
    --print("sphereExitState")
end
function sphereOnMessage(currentEntity, telegram)
    --print("sphereOnMessage")
end
-- End   sphere State Functions -----------------------------------------------
















function createCube(origin)
    --self.meshIDs["cube"] = jli.ViewObjectFactory_createViewObject("cube", self.textureIDs["cubetexture1"]);
    
    local entityStateMachine = jli.EntityStateMachine.create()
--    local textureID = ggj:getTextureID("cubetexture1")
    local viewObjectID = ggj:getMeshID("cube")

    --load the vertexBufferObject
    local shapeID = jli.CollisionShapeFactory_createShape(viewObjectID,
                                                            jli.CollisionShapeType_Cube)
    
    cubeEntity = jli.BaseEntity.create(jli.EntityTypes_SteeringEntity)
    cubeEntity:setup(shapeID, 1.0)
    
    cubeEntity:setOrigin(origin)
    
    cubeEntity:setVertexBufferObject(viewObjectID)
    cubeEntity:getRigidBody():setFriction(1.0)
    cubeEntity:getRigidBody():setRestitution(0.0)
    cubeEntity:setCollisionResponseBehavior(collisionResponseBehavior:getID())
    cubeEntity:setStateMachineID(entityStateMachine:getID())
    cubeEntity:setSteeringBehavior(steeringBehavior:getID())
    cubeEntity:getStateMachine():pushCurrentState(entityState)
    
    return cubeEntity
    
end

function createRandomObject()
    local aabMinPlane = jli.btVector3(0,0,0);
    local aabMaxPlane = jli.btVector3(0,0,0);
    
--    planeEntity:getRigidBody():getAabb(aabMinPlane, aabMaxPlane)
    
    local buffer = 20.0
    local x = 0
    local z = 0
    local randomInt = jli.randomIntegerRange(0,3)
    
    if(randomInt == 0)then
        x = aabMinPlane:x() + buffer
        z = aabMinPlane:z() + buffer
    elseif(randomInt == 1)then
        x = aabMinPlane:x() + buffer
        z = aabMinPlane:z() - buffer
    elseif(randomInt == 2)then
        x = aabMinPlane:x() - buffer
        z = aabMinPlane:z() - buffer
    elseif(randomInt == 3)then
        x = aabMinPlane:x() - buffer
        z = aabMinPlane:z() + buffer
    end
    
    x = -40--aabMinPlane:x() + buffer
    z = -40--aabMinPlane:z() + buffer
    
    entity = createCube(jli.btVector3(x, 10.0, z))
    
    entity:pursue(camera:getID())
    
    entity:setMaxLinearSpeed(5.0)
    entity:setMaxLinearForce(5.0)
end

function createCollisionResponse()
    collisionResponseBehavior = jli.BaseCollisionResponseBehavior.create(jli.CollisionResponseBehaviorTypes_Lua)
    
--    collisionResponseBehaviorID = collisionResponseBehavior:getID()
--    print("the collision response ")
--    print(collisionResponseBehaviorID)
end

function createSteeringBehavior()
    steeringBehavior = jli.BaseEntitySteeringBehavior.create(jli.SteeringBehaviorTypes_Weighted)
end

function createCamera()                                                        
          
    camera = jli.CameraEntity.create(jli.CameraTypes_Entity)
    
--    camera:setup(sphereShapeID, 100.0)
--    camera:setVBOID(sphereViewObjectID)
--    
--    camera:setCollisionResponseBehavior(collisionResponseBehavior:getID())
--    
--    camera:setKinematicPhysics()
    camera:setOrigin(jli.btVector3(0,10,0))
--    camera:setMass(100.0)
    
--    camera:lookAt(jli.btVector3(0,0,0))
    camera:hide()
    
end

function createPlane()
    local entityStateMachine = jli.EntityStateMachine.create()
    local floorTextureID = ggj:getTextureID("floor")
    local planeViewObjectID = ggj:getMeshID("planeobject")
    
    local triangleMeshShapeID = jli.CollisionShapeFactory_createShape(planeViewObjectID,
                                                                      jli.CollisionShapeType_TriangleMesh)
    
    planeEntity = jli.BaseEntity.create(jli.EntityTypes_RigidEntity)
    
    planeEntity:setup(triangleMeshShapeID, 0.0, jli.btVector3(0,0,0))
    planeEntity:setVertexBufferObject(planeViewObjectID)
    
    
    
    planeEntity:getRigidBody():setFriction(1.0)
    planeEntity:getRigidBody():setRestitution(0.0)
    
    
    local vbo = vertexBufferFactory:get(planeViewObjectID)
--    vbo:loadGLSL(shaderID, materialID)
    
    
    
--    planeEntity:setCollisionResponseBehavior(collisionResponseBehavior:getID())
    
    
--    planeEntity:setStateMachineID(entityStateMachine:getID())
    
--    planeEntity:enableDebugDraw(false)

end

function createSkybox()
    local entityStateMachine = jli.EntityStateMachine.create()
    local wallTextureID = ggj:getTextureID("walltexture")
    local skyboxViewObjectID = ggj:getMeshID("skybox")
    local skyboxTriangleMeshShapeID = jli.CollisionShapeFactory_createShape(skyboxViewObjectID,
                                                                            jli.CollisionShapeType_TriangleMesh)
    
    skyboxEntity = jli.BaseEntity.create(jli.EntityTypes_RigidEntity)
    
    skyboxEntity:setup(skyboxTriangleMeshShapeID, 0.0)
    skyboxEntity:setVBOID(skyboxViewObjectID)
    
    skyboxEntity:setKinematicPhysics()
    skyboxEntity:setOrigin(planeEntity:getOrigin())
    
    skyboxEntity:setCollisionResponseBehavior(collisionResponseBehavior:getID())
    
    skyboxEntity:setStateMachineID(entityStateMachine:getID())
end

function createConeEntity()
    local entityStateMachine = jli.EntityStateMachine.create()
    local coneTextureID = ggj:getTextureID("conetexture1")
    local rayconeViewObjectID = ggj:getMeshID("raycone")
    local rayConvexHullID = jli.CollisionShapeFactory_createShape(rayconeViewObjectID,
                                                                  jli.CollisionShapeType_ConvexHull)
                                                                  
    coneEntity = jli.BaseEntity.create(jli.EntityTypes_GhostEntity)
    
    coneEntity:setup(rayConvexHullID, camera:getWorldTransform())
    coneEntity:setVBOID(rayconeViewObjectID)
    
    coneEntity:setCollisionResponseBehavior(collisionResponseBehavior:getID())
    
    coneEntity:setStateMachineID(entityStateMachine:getID())
    
    coneEntity:getStateMachine():pushCurrentState(entityState)
    
--    coneEntity:enableDebugDraw(false)
    coneEntity:hide()
end

function createDebugCamera()
    debugCamera = jli.CameraEntity.create(jli.CameraTypes_Entity)

    debugCamera:setOrigin(jli.btVector3(30,20,30))

    debugCamera:lookAt(camera:getOrigin())
    debugCamera:hide()
    
--    debugCamera:enableDebugDraw(false)
end



function Enter()
    cameraFactory = jli.TheCameraFactory.getInstance()
    materialFactory = jli.TheVBOMaterialFactory.getInstance()
    vertexBufferFactory = jli.TheVertexBufferObjectFactory.getInstance()
    
    ggj = GGJ.new()
    
    
    
--    entityStateMachine = jli.EntityStateMachine.create()

--    print("entity state machine id #" .. esmid)
    
    
--    entityState = jli.BaseEntityState.create(jli.EntityStateType_Lua)
--    print("entity state ID # " .. entityState:getID())
    
    createCollisionResponse()
    createSteeringBehavior()
    
--    cubeTextureID = ggj:getTextureID("cubetexture1")
--    cubeViewObjectID = ggj:getMeshID("cube")
--    cubeShapeID = jli.CollisionShapeFactory_createShape(cubeViewObjectID,
--                                                            jli.CollisionShapeType_Cube)
--    
--    sphereTextureID = ggj:getTextureID("spheretexture")
--    sphereViewObjectID = ggj:getMeshID("sphere")
--    sphereShapeID = jli.CollisionShapeFactory_createShape(sphereViewObjectID,
--                                                            jli.CollisionShapeType_Sphere)
    
    --create the material
--    materialID = materialFactory:createObject()
    
    --create the shader
    local key = jli.ShaderFactoryKey("PixelLighting.vsh", "PixelLighting.fsh")
    shaderID = jli.TheShaderFactory.getInstance():create(key)
    
--    ggj:createViewObject(5, "sphere", ggj:getTextureID("spheretexture"), shaderID);
    ggj:createViewObject(10000, "cube", ggj:getTextureID("cubetexture1"), shaderID)
--    ggj:createViewObject(1, "planeobject", ggj:getTextureID("floor"), shaderID)
--    ggj:createViewObject(100, "sphere", ggj:getTextureID("spheretexture"), shaderID)
    
    print(materialFactory)
    local materialInfo = jli.VBOMaterialInfo()
    materialID = materialFactory:create(materialInfo)
    
    createCamera()
--    theCube = createCube(jli.btVector3(0, 0.0, 0));
--    
--    createPlane()
--    createSkybox()
--    createConeEntity()

--    createDebugCamera()
    
--    cameraFactory:setCurrentCamera(debugCamera)
    cameraFactory:setCurrentCamera(camera)
end

function Update(deltaTime)

    
    
    if camera then
--        coneEntity:setOrigin(camera:getOrigin())
--        camera:lookAt(jli.btVector3(0,0,0))
--        camera:lookAt(theCube:getOrigin())
--        print("look at")
    end
            
--    debugCamera:lookAt(camera:getOrigin())
end

function Render()
--    jli.WorldPhysics.getInstance():debugDrawWorld()
end

function Exit()
end

function OnMessage()
end

function TouchRespond(input)
    if(input:getTouchPhase() == jli.DeviceTouchPhaseEnded) then
        createRandomObject()

--        if(input:getTapCount() >= 2)then
--            cameraFactory:setCurrentCamera(debugCamera)
--        else
--            cameraFactory:setCurrentCamera(camera)
--        end
    end
end

function TapGestureRespond(input)
end

function PinchGestureRespond(input)
end

function PanGestureRespond(input)
end

function SwipeGestureRespond(input)
end

function RotationGestureRespond(input)
end

function LongPressGestureRespond(input)
end

function AccelerometerRespond(input)
end

function MotionRespond(input)
    local yawQuaternion = jli.btQuaternion(jli.btVector3(0, 1, 0), input:getAttitude():getYaw());
    
    if camera then
--        camera:setRotation(yawQuaternion)
        
    end
--
--    coneEntity:setRotation(yawQuaternion)
end

function GyroRespond(input)
end

function MagnetometerRespond(input)
end