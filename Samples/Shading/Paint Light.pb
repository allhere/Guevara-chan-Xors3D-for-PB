; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*
; Xors3D shading sample: 'Paint Light'
; Original source from MoKa (Maxim Miheyev)
; Converted in 2012 by Guevara-chan.
; *-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*

SetCurrentDirectory("..\..\dll") : XIncludeFile "..\..\xors3d.pbi" ; Essential.
SetCurrentDirectory("..\")

Declare UpdateInput()
Declare UpdateCamera(Camera.i,ViewSensivity.f,MoveSensivity.f)
Macro SinD(Val) : Sin(Radian(Val)) : EndMacro
Macro CosD(Val) : Cos(Radian(Val)) : EndMacro
;====================================


;====================================
; Window
xGraphics3D(800,600,32,0,1)
xSetTextureFiltering(#TF_ANISOTROPIC)
;====================================


;====================================
; *Font
Define *Font=xLoadFont("Tahoma",10)
xSetFont(*Font)
;====================================


;====================================
; Varriables
Global mXSp.i,mYSp.i
Global IKdQ.i,IKdW.i,IKdE.i,IKdA.i,IKdS.i,IKdD.i
;====================================


;====================================
; Camera
Global gCamera.i=xCreateCamera()
xCameraZoom(gCamera,0.8)
xCameraClsColor(gCamera,255,255,255)
xRotateEntity(gCamera,20,45,0)
xMoveEntity(gCamera,0,10,-100)
;====================================


;====================================
; LightSphere
Define tLightSpr.i=xCreateSphere(8)
xEntityFX(tLightSpr,1)
xPositionEntity(tLightSpr,30,30,30)
;====================================


;====================================
; Shader
Define tShader.i=xLoadFXFile("Media\Materials\Paint Light.fx")
;====================================


;====================================
; Model
Define tModel.i=xLoadMesh("Media\Extra media\Teapot.b3d")

Define tTexturePaintDark.i=xLoadTexture("Media\Extra media\Paint_Dark.png")
Define tTexturePaintMedium.i=xLoadTexture("Media\Extra media\Paint_Medium.png")
Define tTexturePaintLight.i=xLoadTexture("Media\Extra media\Paint_Light.png")
Define tTexturePaintWhite.i=xLoadTexture("Media\Extra media\Paint_White.png")

xSetEntityEffect(tModel,tShader)
xSetEffectTechnique(tModel,"Directional")
xSetEffectMatrixSemantic(tModel,"MatWorldViewProj",#WORLDVIEWPROJ)
xSetEffectMatrixSemantic(tModel,"MatWorld",#WORLD)
;		Shader Varriables
xSetEffectFloat(tModel,		"RngLight",50)
xSetEffectVector(tModel,	"CountourClr",0,0,0)
xSetEffectFloat(tModel,		"CountourWidth",0.2)
xSetEffectTexture(tModel,	"tPaintDark",tTexturePaintDark)
xSetEffectTexture(tModel,	"tPaintMedium",tTexturePaintMedium)
xSetEffectTexture(tModel,	"tPaintLight",tTexturePaintLight)
xSetEffectTexture(tModel,	"tPaintWhite",tTexturePaintWhite)
;====================================



;====================================
; Main Cycle
xMoveMouse(400,300)

Repeat

		UpdateInput()
		UpdateCamera(gCamera,0.1,1)
		
		;====================================
		xTurnEntity(tModel,0,0.1,0)
		
		If xKeyHit(#KEY_1) : xSetEffectTechnique(tModel,"Directional") : EndIf
		If xKeyHit(#KEY_2) : xSetEffectTechnique(tModel,"Point") : EndIf
		If xKeyHit(#KEY_3) : xSetEffectTechnique(tModel,"PointDistance") : EndIf
		
xPositionEntity(tLightSpr,SinD(ElapsedMilliseconds()*0.05)*40,Abs(SinD(ElapsedMilliseconds()*0.06)*40),SinD(ElapsedMilliseconds()*0.04)*40)
		If Random(2)=1 : xSetEffectVector(tModel,	"TexProjRnd",Random(1000000)/1000000.0,Random(1000000)/1000000.0,0): EndIf
		;====================================
		
		 If xKeyHit(#KEY_ESCAPE) : End : EndIf
	
	xSetEffectVector(tModel,	"PosLight",xEntityX(tLightSpr),xEntityY(tLightSpr),xEntityZ(tLightSpr))
	xSetEffectVector(tModel,	"PosCam",xEntityX(gCamera),xEntityY(gCamera),xEntityZ(gCamera))
		
	xRenderWorld()
	xColor(0, 0, 0)
	xText(10,10,"TrisRendered: "+Str(xTrisRendered()))
	xText(10,25,"FPS: "+Str(xGetFPS()))
	xText(10,580,"Press 1,2,3 to Change Light Type (Directional, Point, Point+Distance)")
	
	xFlip()
ForEver
;====================================



;====================================
; Functions
Procedure UpdateInput()
	xMoveMouse(400,300)
	mXSp=xMouseXSpeed() : mYSp=xMouseYSpeed()
	IKdQ=xKeyDown(#KEY_Q) : IKdW=xKeyDown(#KEY_W)
	IKdE=xKeyDown(#KEY_E) : IKdA=xKeyDown(#KEY_A)
	IKdS=xKeyDown(#KEY_S) : IKdD=xKeyDown(#KEY_D)
EndProcedure

Procedure.f SgnF(Val.F) ; Returns sign of value.
If Val > 0     : ProcedureReturn 1
ElseIf Val < 0 : ProcedureReturn -1
EndIf
EndProcedure

Procedure UpdateCamera(Camera.i,ViewSensivity.f,MoveSensivity.f)
	Define CamP.f=xEntityPitch(gCamera)+mYSp*ViewSensivity
	If Abs(CamP)>80 : CamP=80*SgnF(CamP) : EndIf
	xTurnEntity(Camera,0,-mXSp*ViewSensivity,0)
	xRotateEntity(Camera,CamP,xEntityYaw(gCamera),0)
	
	xMoveEntity(Camera,(IKdD-IKdA)*MoveSensivity,(IKdE-IKdQ)*MoveSensivity,(IKdW-IKdS)*MoveSensivity)
EndProcedure
;====================================
; IDE Options = PureBasic 5.30 (Windows - x86)
; Folding = -
; EnableXP