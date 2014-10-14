{{               
********************************************************
* ICARUS Rover                                        *
* Author: David Gitz                                   *
* Copyright (c) 2014 David Gitz/FAST Robotics          *     
********************************************************

TODO
 - 
   
{{
TARGET:
  - FAST Robotics Genius Core
PURPOSE:
  - 
}}
{{
SETUP:
}}
{{
INDICATOR LIGHTS

}}
{{
LOG:
  DPG 6-OCT-2014.  Created Program.  
 
  
}}
CON

' Timing             
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000 
  
' ASCII Constants
  CR = 13
  LF = 10
  SPACE = 32
  PERIOD = 46
  COMMA =  44
  TAB = 9

 'Loop Rates
  FAST_LOOP = 1 '100 Hz, 10 mS
  MEDIUM_LOOP = 10 '10 Hz, 50 mS
  SLOW_LOOP = 100 '1 Hz, 200 mS

  PRIORITY_HIGH = 0
  PRIORITY_MEDIUM = 1
  PRIORITY_LOW = 2  

  ' UART Definitions
    debug_port = 0
    lcd_port = 1
    pi_port = 2
      
  ' Hardware Pins************************************
  PINNOTUSED = -1                    

  ' UART Pins
  usbtx = 30  'USB TX Line
  usbrx = 31  'USB RX Line
  comtx = 8  'Robot Shield TX Line, FIX
  comrx = 7  'Robot Shield RX Line, FIX

' Led's

  LED4 = 17
  LED3 = 18
  LED2 = 19
  LED1 = 20

' Motor Out Pin: Set to -1 if not used
  SERVO1 = 16
  SERVO2 = 15
  SERVO3 = 14
  SERVO4 = 13

  'ADC Pins/Misc
  ADCuartPin = 21
  ADCclkPin = 22
  ADCcsPin = 23


  'Analog Sensors
  AnalogSense1 = 0
  AnalogSense2 = 1
  AnalogSense3 = 2
  AnalogSense4 = 3
  AnalogSense5 = 4
  AnalogSense6 = 5
  AnalogSense7 = 6
  AnalogSense8 = 7

 'GPIO Pin Definitions
  GPIO1 = 6
  GPIO2 = 5
  GPIO3 = 4
  GPIO4 = 3
  GPIO5 = 2

  'US Pin Definitions.  These are just more GPIO
  US1 = 13
  US2 = 12
  US3 = 11
  US4 = 10

  'SD Card Pin Definitions
  SD_DO = 24
  SD_SCLK = 25
  SD_DI = 26
  SD_CS = 27

  'Input Switch Pin Definitions
  SW1 = 0
  SW2 = 1

' ****************************************************  

  'ADC Definitions
  ADC_VOLTAGE_CONVERSION = 18   
  ADC_LOWER_THRESHOLD = 100  'Threshold for converting Analog Input to Boolean states.  Below this is FALSE.
  ADC_UPPER_THRESHOLD = 3900   'Threshold for converting Analog Input to Boolean states.  Above this is TRUE.
  ADC_MIN_VALUE = 0
  ADC_MAX_VALUE = 4096
  ADCmode = $00FF  
  
 'PWM/Motor Definitions

  PWM_MIN_VALUE = 1000
  PWM_MAX_VALUE = 2000
  PWM_NEUTRAL_VALUE = 1500 


  'FAST Protocol Definitions
  SD = $24
  ED = $2A
  'Message/Sub-Message Type Definitions
  MT_ERROR = $01
  SMT_NOERROR = $01


  'Value Type Definitions
  VT_NODATA = $FF
  VT_1INT = $01
   
  ' User Pin Definitions
  Arm_Pin = GPIO1
  Startup_LED = LED1
  Run_LED = LED2
  Armed_LED = LED3
  Error_LED = LED4

  'Ultrasonic Sensor Definitions
  PING_FRONT = GPIO1
  PING_LEFT = GPIO2
  PING_RIGHT = GPIO3
  SONIC_TOP = AnalogSense1

  'Motor Definitions
  SteerMotor = SERVO1
  DriveMotor = SERVO2
  TURN_LEFT = PWM_MIN_VALUE
  TURN_STRAIGHT = PWM_NEUTRAL_VALUE
  TURN_RIGHT = PWM_MAX_VALUE
  TURN_LEFT_SMALL = 1250
  TURN_RIGHT_SMALL = 1750
  DRIVE_STOP = PWM_NEUTRAL_VALUE
  DRIVE_FWD_SLOW = 1700   'Ok
  DRIVE_FWD_MEDIUM = 1725  'Ok
  DRIVE_FWD_FAST = 1800  'Ok
  DRIVE_REV_SLOW = 1300  'Ok
  TURN_TIME = 10
  STRAIGHT_TIME = 200

  'Navigation Methods
  NAV_OA = 1
  NAV_SIMPLE = 2

  NAV_SIMPLE_FWD = 1
  NAV_SIMPLE_EXPLORE = 2
  NAV_SIMPLE_HUG = 3
  'Obstacle Detecion/Avoidance Stuff
  BEYONDFAR = 100
  FAR = 20
  MID = 15
  WAVE_TOP = 200
  WAVE_BOTTOM = 50
  WAVE_LIMIT = 10

  GRIDSIZE = 7



OBJ
  uart:         "pcFullDuplexSerial4FC"
  pwmout:       "PWM_32_v4"
  util:         "Util"
  adc:          "MCP3208"
  str:          "STRINGS2"
  sdcard:           "fsrw"
  ping:         "ping"
  math:         "spin_trigpack"
  timer:        "Timer32"

VAR
  'Program Variables
  byte cogsused

  'Timing Variables
  long wait_mS
  long elapsedtime
  long slow_loop_count
  long medium_loop_count
  long fast_loop_count
  byte prioritylevel
  word ontime
  long armedtimer
  byte armedstart
  byte backup_timer

  'UART Variables
  long stack[10]  
  byte rxbyte,rxinit  
  byte tempbyte
  byte tempstr1[50]
  byte  stringbuffer[100]
  byte comrxbuffer[100] 
  byte Debug
  byte text_counter

  'Motor Variables
  byte Armed

  'Navigation Variables
  long front_distance
  long left_distance
  long right_distance
  long top_distance
  byte wave_counter
  byte wave_in
  byte wave_out
  byte nav_main_mode
  byte nav_chosen_mode
  byte turn_timer
  byte straight_timer
  byte delay_timer
   

  'Obstacle Detection/Avoidance Variables

  long occupancy_grid[GRIDSIZE*GRIDSIZE]
  long com_x
  long com_y
  long target_x
  long target_y
  long target_theta
  long target_speed
  
  'SD Card Variables
  byte tbuf[20]
  byte bigbuf[256]

PUB init | i,j,sum, tempstr, temp1,fileerror
  
  front_distance := 0
  left_distance := 0
  right_distance := 0
  com_x := 0
  com_y := 0
  wait_mS := clkfreq/1000 '1 mS
  Armed := 1
  wave_in := False
  wave_out := False
  wave_counter := 0
  delay_timer := 0
  Debug := 0
  backup_timer := 0
  text_counter := 0
  turn_timer := TURN_TIME + 1
  straight_timer := 0
  nav_main_mode := NAV_SIMPLE
  nav_chosen_mode := NAV_SIMPLE_FWD
  ResetGrid

  'bytemove(@stringbuffer,@@SYSTEM_MC,strlen(@@SYSTEM_MC))  

  'Set LED Pins as outputs if they should be.  We don't know if they are contiguous or not.
  DIRA[Startup_LED]~~
  DIRA[Run_LED]~~
  DIRA[Armed_LED]~~
  DIRA[Error_LED]~~
  OUTA[Startup_LED] := TRUE
  OUTA[Run_LED] := FALSE
  OUTA[Armed_LED] := FALSE
  OUTA[Error_LED] := FALSE

  'Wait a couple seconds before doing anything
  
  cogsused := 0
  slow_loop_count := medium_loop_count := fast_loop_count := 0
  i := 0      
  'Set GPIO Pins as Inputs/Outputas as needed.
  DIRA[Arm_Pin]~

   'Initialize all Ports
  uart.init                    

  uart.AddPort(debug_port,usbrx,usbtx,uart#PINNOTUSED,uart#PINNOTUSED,uart#DEFAULTTHRESHOLD,uart#NOMODE,uart#BAUD9600)
  uart.AddPort(lcd_port,comrx,comtx,uart#PINNOTUSED,uart#PINNOTUSED,uart#DEFAULTTHRESHOLD,uart#NOMODE,uart#BAUD9600)
  uart.AddPort(pi_port,GPIO5,GPIO4,uart#PINNOTUSED,uart#PINNOTUSED,uart#DEFAULTTHRESHOLD,uart#NOMODE,uart#BAUD115200)
  waitcnt(clkfreq*5 + cnt)
        
  'uart.AddPort(debug_port,comrx,comtx,-1,-1,0,-%000000,uart#BAUD115200)
                         
  if (temp1 := uart.Start) 
      cogsused += 1 'Should be 1
      uart.rxflush(debug_port)
      uart.rxflush(debug_port)  
  if (temp1 := pwmout.start) 'servo.start
    cogsused += 1 'Should be 2
  else
    uart.str(debug_port,string("pwmout not started"))
    uart.dec(debug_port,temp1)
    
  {if (temp1 := timer.start)
    timer.run
    cogsused += 1 'Should be 3
  else
    uart.str(debug_port,string("timer not started"))
    uart.dec(debug_port,temp1) }

  {if (temp1 := ledpwm.start)
    cogsused += 1 'Should be 4
  else
    uart.str(debug_port,string("ledpwm not started"))
    uart.dec(debug_port,temp1)
    }

  'pwmin.Start(FrontMotorInPin)
  
  'Start sensors

  if (temp1 := adc.start(ADCuartPin, ADCclkPin, ADCcsPin, ADCmode))
    cogsused += 1 'Should be 5
  else
    uart.str(debug_port,string("adc not started"))
    uart.dec(debug_port,temp1)

    
  if (temp1 := sdcard.mount(SD_DO))

  else
    uart.str(debug_port,string("sdcard card not mounted"))
    uart.dec(debug_port,temp1)

  math.Start_Driver
  
  timer.Init
  timer.Start
  timer.Mark
  cogsused++

  uart.str(debug_port,string("Cog's Used:"))
  uart.dec(debug_port,cogsused)
  uart.str(debug_port,string(CR,LF))
   
  OUTA[Startup_LED] := FALSE
  testuart

PUB testuart
  repeat
    waitcnt(clkfreq/10 + cnt)
    'uart.tx(debug_port,uart.rxtime(pi_port,1))
    uart.str(pi_port,string("HI BACK",CR,LF))
    !outa[LED1]
PUB testmotor | i
  pwmout.Servo(DriveMotor,DRIVE_REV_SLOW)
  waitcnt(clkfreq*3 + cnt)
  pwmout.Servo(DriveMotor,DRIVE_STOP)
  repeat
     !OUTA[Error_LED]
     waitcnt(clkfreq/2 + cnt)
PUB runprogram | i

  if nav_main_mode == NAV_OA
    repeat 20000
      waitcnt(clkfreq/100 + cnt)
       
      !outa[Run_LED]

      UpdateGrid

      FindGridCoM
      'PrintGrid
      UpdateSetPoints
  elseif nav_main_mode == NAV_SIMPLE
        repeat
            delay_timer++
            if delay_timer > 300
              delay_timer := 0
              uart.str(lcd_port,@@textblock[text_counter++]) 
            if text_counter > 9
              text_counter := 0
            'nav_chosen_mode := NAV_SIMPLE_FWD
            nav_chosen_mode := NAV_SIMPLE_HUG  
            waitcnt(clkfreq/100 + cnt)
            !outa[Run_LED]
            top_distance := adc.average(SONIC_TOP,4)
            if (timer.TimeOutS(5))
              timer.Mark
              wave_counter := 0 
            if top_distance > WAVE_BOTTOM and top_distance < WAVE_TOP
                wave_in := True
                'uart.str(debug_port,string("wave in"))
                'uart.dec(debug_port,wave_counter)
                'uart.str(debug_port,string(CR,LF))
            else
                wave_out := True
                'uart.str(debug_port,string("wave out"))
                'uart.dec(debug_port,wave_counter)
                'uart.str(debug_port,string(CR,LF))
            if wave_in and wave_out
              wave_counter++
              uart.dec(debug_port,wave_counter)
              uart.str(debug_port,string(CR,LF))
              wave_in := False
              wave_out := False
            if wave_counter > WAVE_LIMIT
              wave_counter := 0
                 uart.str(lcd_port,string(254,128,"PICK A CARD,    ANY CARD...     "))
                 if Debug
                      uart.str(debug_port,string("PICK A CARD, ANY CARD...     ",CR,LF))
                 outa[Run_LED] := False
                 if Armed
                      pwmout.Servo(DriveMotor,DRIVE_STOP)
                 repeat 3
                      waitcnt(clkfreq*4 + cnt)

                      repeat 4
                           if Armed
                                pwmout.Servo(SteerMotor,TURN_LEFT_SMALL)
                                waitcnt(clkfreq/4 + cnt)
                                pwmout.Servo(SteerMotor,TURN_RIGHT_SMALL)
                                waitcnt(clkfreq/4 + cnt)
                                pwmout.Servo(SteerMotor,TURN_STRAIGHT)
                      waitcnt(clkfreq*2 + cnt)
                 uart.str(lcd_port,string(254,128," MOVING SOON...   !WATCH OUT!   "))
                 waitcnt(clkfreq*5 + cnt)     
            else
                 navigate(nav_chosen_mode)
                
Pub navigate(mode)|i,j
        front_distance := ping.Inches(PING_FRONT) 
        right_distance := ping.Inches(PING_RIGHT)
        left_distance := ping.Inches(PING_LEFT)
        if backup_timer > 100
                backup_timer := 0
                if Debug
                     uart.str(debug_port,string("BACKING UP AND TURNING...",CR,LF))
                if Armed
                                pwmout.Servo(DriveMotor,DRIVE_REV_SLOW)
                                pwmout.Servo(SteerMotor,TURN_LEFT)
                waitcnt(clkfreq*1 + cnt)
                if Armed
                                pwmout.Servo(DriveMotor,DRIVE_STOP)
                                pwmout.Servo(SteerMotor,TURN_RIGHT)
                if Debug
                     uart.str(debug_port,string("DONE BACKING UP.  PROCEEDING...",CR,LF))
        elseif front_distance < MID
                if Armed
                                pwmout.Servo(DriveMotor,DRIVE_STOP)
                if Debug
                     uart.str(debug_port,string("STOPPING",CR,LF))
                backup_timer++ 
        elseif left_distance < MID
                backup_timer := 0
                if Debug
                     uart.str(debug_port,string("OBJECT ON LEFT, TURNING RIGHT",CR,LF))
                if Armed
                        pwmout.Servo(SteerMotor,TURN_RIGHT)
                        pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW) 
        elseif right_distance < MID
                backup_timer := 0
                if Debug
                     uart.str(debug_port,string("OBJECT ON RIGHT, TURNING LEFT",CR,LF))
                if Armed
                                pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW)
                                pwmout.Servo(SteerMotor,TURN_LEFT)
        else 'No Objects
                backup_timer := 0
                if mode== NAV_SIMPLE_FWD
                        if Debug
                             uart.str(debug_port,string("MOVING FORWARDS SLOWLY",CR,LF))
                        if Armed
                                pwmout.Servo(SteerMotor,TURN_STRAIGHT) 
                                pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW)
                elseif mode == NAV_SIMPLE_HUG
                                straight_timer++
                                if straight_timer < STRAIGHT_TIME
                                     if Debug
                                          uart.str(debug_port,string("MOVING FORWARDS SLOWLY",CR,LF)) 
                                     if Armed
                                          pwmout.Servo(SteerMotor,TURN_STRAIGHT)
                                          pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW)
                                else
                                     if Debug
                                          uart.str(debug_port,string("EXPLORING LEFT",CR,LF)) 
                                     if Armed
                                          repeat TURN_TIME
                                               pwmout.Servo(SteerMotor,TURN_LEFT)
                                          pwmout.Servo(SteerMotor,TURN_STRAIGHT)
                                          
                                
               {                                 
                elseif mode == NAV_SIMPLE_HUG
                        
                        if turn_timer > TURN_TIME
                                straight_timer := 0
                        if straight_timer > STRAIGHT_TIME
                                uart.str(debug_port,string("I SHOULDN'T GET HERE",CR,LF))
                                turn_timer := 0
                        if turn_timer <= TURN_TIME 'Turn
                                uart.str(debug_port,string("EXPLORING "))
                                uart.dec(debug_port,turn_timer)
                                uart.str(debug_port,string(" , "))
                                uart.dec(debug_port,straight_timer)
                                uart.str(debug_port,string(" , "))
                                turn_timer++
                                uart.dec(debug_port,turn_timer)   
                                 uart.str(debug_port,string(" TURNING",CR,LF))
                                if Armed
                                                        pwmout.Servo(SteerMotor,TURN_LEFT)
                                                        pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW)
                        elseif straight_timer <= STRAIGHT_TIME 'Drive STraight
                                straight_timer := straight_timer + 1                                
                                uart.str(debug_port,string(" STRAIGHT",CR,LF))
                                if Armed
                                                        pwmout.Servo(SteerMotor,TURN_STRAIGHT)
                                                        pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW)  }

                        
Pub UpdateSetPoints| x,y,tempstr
  'target_theta
  x := math.Qval(target_x)
  y := math.Qval(target_y)
  tempstr := math.QvalToStr(math.Deg_ATAN2(x,y))
  target_theta := util. strntodec(tempstr,0)-90
  'tempstr := math.Qradius(x,y)
  target_speed := target_x*target_x + target_y*target_y
  target_speed := target_speed >> 1
  if Debug == 0
    uart.str(debug_port,string("Target Theta: "))
    uart.dec(debug_port,target_theta)
    uart.str(debug_port,string(" X: "))
    uart.dec(debug_port,target_x)
    uart.str(debug_port,string(" Y: "))
    uart.dec(debug_port,target_y)
    uart.str(debug_port,string(CR,LF))
  if Debug == 0
    uart.str(debug_port,string("Dist:"))
    uart.dec(debug_port,target_speed)
    uart.str(debug_port,string(CR,LF))
  if Armed
    if target_theta > 10
      'pwmout.Servo(SteerMotor,TURN_LEFT)
    elseif target_theta < -10
      'pwmout.Servo(SteerMotor,TURN_RIGHT)
    else
      'pwmout.Servo(SteerMotor,TURN_STRAIGHT)
  if Armed
    if backup_timer > 100
      uart.str(debug_port,string("BACKING UP AND TURNING",CR,LF))
      pwmout.Servo(DriveMotor,DRIVE_REV_SLOW)
      pwmout.Servo(SteerMotor,TURN_LEFT)
      waitcnt(clkfreq*1 + cnt)
      pwmout.Servo(SteerMotor,TURN_RIGHT)
      pwmout.Servo(SteerMotor,DRIVE_STOP)
      waitcnt(clkfreq/100 + cnt)
      backup_timer := 0
    if target_speed < 1
        uart.str(debug_port,string("STOPPING",CR,LF))
        backup_timer := backup_timer + 1
        uart.dec(debug_port,backup_timer)
        pwmout.Servo(DriveMotor,DRIVE_STOP) 
    elseif target_speed < 5
        uart.str(debug_port,string("SLOW",CR,LF))
        backup_timer := 0
        pwmout.Servo(DriveMotor,DRIVE_FWD_SLOW) 
    else
        uart.str(debug_port,string("MEDIUM",CR,LF))
        backup_timer := 0 
        pwmout.Servo(DriveMotor,DRIVE_FWD_MEDIUM) 

Pub SetGoalOnGrid(x,y) | i,j,sum  'Tries to search for a Free location at or near desired grid value    
  sum := 0
  x := x + 3
  y := 3 - y
  repeat i from 0 to (GRIDSIZE*GRIDSIZE)-1
    sum := sum + occupancy_grid[i]
  occupancy_grid[x+y*GRIDSIZE] := -sum/2
Pub FindGridCoM| i,j,Mx,My, value,mass
  mass := 0
  Mx := 0
  My := 0
  repeat i from -3 to 3
    repeat j from 3 to -3
        value := GetGridValue(i,j)
        Mx := Mx + value * i
        My := My + value * j
        mass := mass + value
        {
        uart.str(debug_port,string("i:"))
        uart.dec(debug_port,i)
        uart.str(debug_port,string("j:"))
        uart.dec(debug_port,j)
        uart.str(debug_port,string("Mx:"))
        uart.dec(debug_port,Mx)
        uart.str(debug_port,string("My:"))
        uart.dec(debug_port,My)
        uart.str(debug_port,string(CR,LF))  }
                                             
  Mx := Mx * (GRIDSIZE-1)/(mass)
  My := My * (GRIDSIZE-1)/(mass)
  com_x := Mx
  com_y := My
  target_x := -com_x
  target_y := -com_y
  target_x := -3 #> target_x <# 3
  target_y := -3 #> target_y <# 3
 { 
  uart.str(debug_port,string("Tx: "))
  uart.dec(debug_port,target_x)
  uart.str(debug_port,string(" Ty: "))
  uart.dec(debug_port,target_y)
  uart.str(debug_port,string(CR,LF)) 
  }    
Pub UpdateGrid|rowtomark,coltomark,i,j
  ResetGrid
  front_distance := ping.Inches(PING_FRONT) 
  right_distance := ping.Inches(PING_RIGHT)
  left_distance := ping.Inches(PING_LEFT)
  if debug == 0
    uart.str(debug_port,string("L: "))
    uart.dec(debug_port,left_distance)
    uart.str(debug_port,string(" F:"))
    uart.dec(debug_port,front_distance)
    uart.str(debug_port,string(" R:"))
    uart.dec(debug_port,right_distance) 
    uart.str(debug_port,string(CR,LF))
  if front_distance > BEYONDFAR
    rowtomark := -1
  elseif front_distance > FAR
    rowtomark := 0
  elseif front_distance > MID
    rowtomark := 1
  elseif front_distance < MID
    rowtomark := 2
  if rowtomark => 2
    repeat i from 16 to 18
      occupancy_grid[i] := 1
  if rowtomark => 1
    repeat i from 8 to 12
      occupancy_grid[i] := 1
  if rowtomark => 0
    repeat i from 0 to 6
      occupancy_grid[i] := 1
  
  if right_distance > BEYONDFAR
    coltomark := 10
  elseif right_distance > FAR
    coltomark := 3
  elseif right_distance > MID
    coltomark := 2
  elseif right_distance < MID
    coltomark := 1
  if coltomark =< 1
    repeat i from 0 to 2
      occupancy_grid[18+(i*GRIDSIZE)] := 1
  if coltomark =< 2
    repeat i from 0 to 4
      occupancy_grid[12+(i*GRIDSIZE)] := 1
  if coltomark =< 3
    repeat i from 0 to 6
      occupancy_grid[6+(i*GRIDSIZE)] := 1
  

  if left_distance > BEYONDFAR
     coltomark := 10
  elseif left_distance > FAR
    coltomark := 3
  elseif left_distance > MID
    coltomark := 2
  elseif left_distance < MID
    coltomark := 1
  if coltomark =< 1
    repeat i from 0 to 2
      occupancy_grid[16+(i*GRIDSIZE)] := 1
  if coltomark =< 2
    repeat i from 0 to 4
      occupancy_grid[8+(i*GRIDSIZE)] := 1
  if coltomark =< 3
    repeat i from 0 to 6
      occupancy_grid[0+(i*GRIDSIZE)] := 1     
Pub GetGridValue(x,y)  
  x := x + 3
  y := 3 - y
  return occupancy_grid[x+y*GRIDSIZE]         

Pub PrintGrid|i,j
  uart.str(debug_port,string("    FRONT",CR,LF))
  uart.str(debug_port,string("--------------",CR,LF))
  repeat i from 0 to GRIDSIZE - 1
    repeat j from 0 to GRIDSIZE - 1
      uart.dec(debug_port,occupancy_grid[j+i*GRIDSIZE])
      uart.tx(debug_port,SPACE)
    uart.str(debug_port,string(CR,LF))
  uart.str(debug_port,string("--------------",CR,LF))
  uart.str(debug_port,string("   BACK"))
  uart.str(debug_port,string(CR,LF))
  uart.str(debug_port,string(CR,LF))   
  uart.str(debug_port,string(CR,LF))
Pub ResetGrid| i,j
  repeat i from 0 to GRIDSIZE-1
    repeat j from 0 to GRIDSIZE - 1
      occupancy_grid[j+i*GRIDSIZE] := 0
  occupancy_grid[((GRIDSIZE*GRIDSIZE-1)/2)] := 1
  repeat i from 30 to 32
    occupancy_grid[i] := 1
  repeat i from 36 to 40
    occupancy_grid[i] := 1
  repeat i from 42 to 48
    occupancy_grid[i] := 1

Dat

  text1 byte 254,128,"Hasta La Vista,      Baby!      ",0
  text2 byte 254,128," FAST ROBOTICS  MAKE ROBOTS FAST",0
  text3 byte 254,128,"Come with me if you want to live",0
  text4 byte 254,128," FAST ROBOTICS  MAKE ROBOTS FAST",0  
  text5 byte 254,128,"   Your Move,        Creep!     ",0
  text6 byte 254,128," FAST ROBOTICS  MAKE ROBOTS FAST",0  
  text7 byte 254,128,"Would you like   to play a game?",0
  text8 byte 254,128," FAST ROBOTICS  MAKE ROBOTS FAST",0  
  text9 byte 254,128,"I Need Input.        Input!     ",0
  text10 byte 254,128," FAST ROBOTICS  MAKE ROBOTS FAST",0  
  textblock word @text1, @text2, @text3, @text4, @text5, @text6, @text7, @text8, @text9, @text10
  