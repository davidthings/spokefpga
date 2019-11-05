//
// Camera Definitions
//


//
// Camera Registers
//

localparam  Register_ChipVersion                 = 8'H00,
            Register_ColumnStart                 = 8'H01,
            Register_RowStart                    = 8'H02,
            Register_WindowHeight                = 8'H03,
            Register_WindowWidth                 = 8'H04,
            Register_HorizontalBlanking          = 8'H05,
            Register_VerticalBlanking            = 8'H06,
            Register_ChipControl                 = 8'H07,
            Register_CoarseShutterWidth1         = 8'H08,
            Register_CoarseShutterWidth2         = 8'H09,
            Register_CoarseShutterWidthControl   = 8'H0A,
            Register_CoarseShutterWidthTotal     = 8'H0B,
            Register_Reset                       = 8'H0C,
            Register_ReadMode                    = 8'H0D,
            Register_HighDynamicRangeEnable      = 8'H0F,
            Register_Mystery13                   = 8'H13,
            Register_LEDOutControl               = 8'H1B,
            Register_ADCResolutionControl        = 8'H1C,
            Register_Mystery20                   = 8'H20,
            Register_Mystery24                   = 8'H24,
            Register_Mystery2B                   = 8'H2B,
            Register_Mystery2F                   = 8'H2F,
            Register_ADCVoltageReference         = 8'H2C,
            Register_StepVoltageV1               = 8'H31,
            Register_StepVoltageV2               = 8'H32,
            Register_StepVoltageV3               = 8'H33,
            Register_StepVoltageV4               = 8'H34,
            Register_GlobalGainControl           = 8'H35,
            Register_FrameDarkAverage            = 8'H42,
            Register_DarkAverageThreshold        = 8'H46,
            Register_BlackLevelCalibControl      = 8'H47,
            Register_BlackLevelCalibValue        = 8'H48,
            Register_BlackLevelCalibValueStepSize= 8'H4C,
            Register_CFAType                     = 8'H6B,
            Register_RowNoiseCorrectionControl   = 8'H70,
            Register_RowNoiseConstant            = 8'H72,
            Register_PixelClockFVLV              = 8'H74,
            Register_DigitalTestPattern          = 8'H7F,
            Register_TiledDigitalGain_X0Y0       = 8'H80,
            Register_TiledDigitalGain_Y5Y5       = 8'H98,
            Register_TileCoordinates_X0          = 8'H99,
            Register_TileCoordinates_X5          = 8'H9E,
            Register_TileCoordinates_Y0          = 8'H9F,
            Register_TileCoordinates_Y5          = 8'HA4,
            Register_DesiredBin                  = 8'HA5,
            Register_ExposureSkip                = 8'HA6,
            Register_ExposureLPF                 = 8'HA8,
            Register_GainSkip                    = 8'HA9,
            Register_MaxGain                     = 8'HAA,   /* Error in datasheet? P26 */
            Register_GainLPF                     = 8'HAB,
            Register_CoarseShutterWidthMinimum   = 8'HAC,
            Register_CoarseShutterWidthMaximum   = 8'HAD,
            Register_AecAgcEnable                = 8'HAF,
            Register_LvdsOutPowerDown            = 8'HB1,
            Register_LvdsOutShiftClockPowerDown  = 8'HB2,
            Register_LvdsOutControl              = 8'HB6,
            Register_Exposure                    = 8'HBB,
            Register_MaxTotalShutterWidth        = 8'HBD,  /* Error in datasheet? P26 */
            Register_MonitorModeControl          = 8'HC0,
            Register_FineShutterWidth1           = 8'HD3,
            Register_FineShutterWidth2           = 8'HD4,
            Register_FineShutterWidthTotal       = 8'HD5,
            Register_MonitorMode                 = 8'HD9,
            Register_BytewiseAddress             = 8'HF0,
            Register_RegisterLock                = 8'HFE;

// Second Context Registers (note some second context stuff is available on alternate fields of the first register)

localparam  Register_ColumnStart_B               = 8'HC9,
            Register_RowStart_B                  = 8'HCA,
            Register_WindowHeight_B              = 8'HCB,
            Register_WindowWidth_B               = 8'HCC,
            Register_HorizontalBlanking_B        = 8'HCD,
            Register_VerticalBlanking_B          = 8'HCE,
            Register_CoarseShutterWidth1_B       = 8'HCF,
            Register_CoarseShutterWidth2_B       = 8'HD0,
            Register_CoarseShutterWidthControl_B = 8'HD1,
            Register_CoarseShutterWidthTotal_B   = 8'HD2,
            Register_ReadMode_B                  = 8'H0E,
            Register_StepVoltageV1_B             = 8'H39,
            Register_StepVoltageV2_B             = 8'H3A,
            Register_StepVoltageV3_B             = 8'H3B,
            Register_StepVoltageV4_B             = 8'H3C,
            Register_GlobalGainControl_B         = 8'H36,
            Register_FineShutterWidth1_B         = 8'HD6,
            Register_FineShutterWidth2_B         = 8'HD7,
            Register_FineShutterWidthTotal_B     = 8'HD8;

            // The following registers contain fields for the second context
            // Register_HighDynamicRangeEnable    = 8'H0F,
            // Register_ADCResolutionControl      = 8'H1C,
            // Register_RowNoiseCorrectionControl = 8'H70,
            // Register_TiledDigitalGain_0        = 8'H80,
            // Register_TiledDigitalGain_23       = 8'H98,
            // Register_AecAgcEnable              = 8'HAF,

// Register Bit Definitions (l = lsb, w = width)

// Chip Version

localparam Register_ChipVersion_MT9V022                      = 16'H1313;
localparam Register_ChipVersion_MT9V022_1                    = 16'H1311;
localparam Register_ChipVersion_MT9V022_2                    = 16'H1312;
localparam Register_ChipVersion_MT9V022_3                    = 16'H1313;
localparam Register_ChipVersion_MT9V034                      = 16'H1324;

// Column Start

localparam Register_ColumnStart_Min                          = 16'H1;
localparam Register_ColumnStart_Max                          = 16'D752;
localparam Register_ColumnStart_Default                      = 16'D1;

// Row Start

localparam Register_RowStart_Min                             = 16'H04;
localparam Register_RowStart_Max                             = 16'D482;
localparam Register_RowStart_Default                         = 16'H04;

// Window Height 8'H03

localparam Register_WindowHeight_Min                         = 16'D0;
localparam Register_WindowHeight_Max                         = 16'D482;
localparam Register_WindowHeight_Default                     = 16'D482;

// Window Width 8'H04

localparam Register_WindowWidth_Default                      = 16'D752;
localparam Register_WindowWidth_Min                          = 16'D1;
localparam Register_WindowWidth_Max                          = 16'D752;

// Horizontal Blanking 8'H05

localparam Register_HorizontalBlanking_Default               = 16'D94;
localparam Register_HorizontalBlanking_Min                   = 16'D61;
localparam Register_HorizontalBlanking_Max                   = 16'D1023;

// Vertical Blanking 8'H06

localparam Register_VerticalBlanking_Min                     = 16'H2;
localparam Register_VerticalBlanking_Max                     = 16'D32288;
localparam Register_VerticalBlanking_Default                 = 16'D45;

// Chip Control 8'H07

localparam Register_ChipControl_Default                      = 16'H388;
localparam Register_ChipControl_Snapshot_Default             = 16'H398;

localparam  Register_ChipControl_ScanMode_l                   = 0,
            Register_ChipControl_ScanMode_w                   = 3,
            Register_ChipControl_ScanMode_mask                = ((1<<3)-1),
            Register_ChipControl_ScanMode_Progressive         = 3'H0,
            Register_ChipControl_ScanMode_Nope                = 3'H1,
            Register_ChipControl_ScanMode_Interlaced_2        = 3'H2,
            Register_ChipControl_ScanMode_Interlaced_1        = 3'H3,
            Register_ChipControl_ScanMode_Default             = 3'H0;

localparam  Register_ChipControl_SensorOperatingMode_l        = 3,
            Register_ChipControl_SensorOperatingMode_w        = 2,
            Register_ChipControl_SensorOperatingMode_mask     = ((1<<2)-1),
            Register_ChipControl_SensorOperatingMode_Slave    = 0,
            Register_ChipControl_SensorOperatingMode_Master   = 1,
            Register_ChipControl_SensorOperatingMode_Nope     = 2,
            Register_ChipControl_SensorOperatingMode_Snapshot = 3,
            Register_ChipControl_SensorOperatingMode_Default  = 1;

localparam  Register_ChipControl_StereoMode_l                 = 5,
            Register_ChipControl_StereoMode_w                 = 1,
            Register_ChipControl_StereoMode_mask              = 1,
            Register_ChipControl_StereoMode_Disabled          = 0,
            Register_ChipControl_StereoMode_Enabled           = 1;

localparam  Register_ChipControl_StereoMasterMode_l           = 6,
            Register_ChipControl_StereoMasterMode_w           = 1,
            Register_ChipControl_StereoMasterMode_mask        = 1,
            Register_ChipControl_StereoMasterMode_Master      = 0,
            Register_ChipControl_StereoMasterMode_Slave       = 1;

localparam  Register_ChipControl_ParallelOutputEnable_l       = 7,
            Register_ChipControl_ParallelOutputEnable_w       = 1,
            Register_ChipControl_ParallelOutputEnable_mask    = 1,
            Register_ChipControl_ParallelOutputEnable_Disable = 0,
            Register_ChipControl_ParallelOutputEnable_Enable  = 1,
            Register_ChipControl_ParallelOutputEnable_Default = 1;

localparam  Register_ChipControl_ExposureMode_l               = 8,
            Register_ChipControl_ExposureMode_w               = 1,
            Register_ChipControl_ExposureMode_mask            = 1,
            Register_ChipControl_ExposureMode_Sequential      = 0,
            Register_ChipControl_ExposureMode_Simultaneous    = 1,
            Register_ChipControl_ExposureMode_Default         = 1;

localparam  Register_ChipControl_DefectivePixelCorrect_l       = 9,
            Register_ChipControl_DefectivePixelCorrect_w       = 1,
            Register_ChipControl_DefectivePixelCorrect_mask    = 1,
            Register_ChipControl_DefectivePixelCorrect_Disable = 0,
            Register_ChipControl_DefectivePixelCorrect_Enable  = 1,
            Register_ChipControl_DefectivePixelCorrect_Default = 1;

localparam  Register_ChipControl_ContextABSelect_l             = 15,
            Register_ChipControl_ContextABSelect_w             = 1,
            Register_ChipControl_ContextABSelect_mask          = 1,
            Register_ChipControl_ContextABSelect_ContextA      = 0,
            Register_ChipControl_ContextABSelect_ContextB      = 1,
            Register_ChipControl_ContextABSelect_Default       = 0;

// Coarse Shutter Width 8'H08

localparam Register_CoarseShutterWidth_Default               = 16'D480;
localparam Register_CoarseShutterWidth_Min                   = 16'D0;
localparam Register_CoarseShutterWidth_Max                   = 16'D32765;

// Coarse Shutter Width Control 8'H0A

localparam  Register_CoarseShutterWidthControl_HDRKneeAuto_l       = 8,
            Register_CoarseShutterWidthControl_HDRKneeAuto_w       = 1,
            Register_CoarseShutterWidthControl_HDRKneeAuto_mask    = 1,
            Register_CoarseShutterWidthControl_HDRKneeAuto_Disable = 0,
            Register_CoarseShutterWidthControl_HDRKneeAuto_Enable  = 1,
            Register_CoarseShutterWidthControl_HDRKneeAuto_Default = 1;

// Reset 8'H0C

localparam  Register_Reset_LogicReset_l                  = 0,
            Register_Reset_LogicReset_w                  = 1,
            Register_Reset_LogicReset_mask               = 1,
            Register_Reset_LogicReset_Disable            = 0,
            Register_Reset_LogicReset_Enable             = 1;

localparam  Register_Reset_AgcAEcReset_l                 = 1,
            Register_Reset_AgcAEcReset_w                 = 1,
            Register_Reset_AgcAEcReset_mask              = 1,
            Register_Reset_AgcAEcReset_Disable           = 0,
            Register_Reset_AgcAEcReset_Enable            = 1;

// Fine Shutter Width

localparam Register_FineShutterWidth_Default                 = 16'H0;
localparam Register_FineShutterWidth_Min                     = 16'H0;
localparam Register_FineShutterWidth_Max                     = 16'D1774;

// Read Mode 8'H0D

localparam Register_ReadMode_Default                          = 16'H300;
localparam Register_ReadMode_Default_RCFlip                   = 16'H330;

localparam  Register_ReadMode_ColumnBin_l                     = 0,
            Register_ReadMode_ColumnBin_w                     = 2,
            Register_ReadMode_ColumnBin_mask                  = (1<<2)-1,
            Register_ReadMode_ColumnBin_1                     = 2'H0,
            Register_ReadMode_ColumnBin_2                     = 2'H1,
            Register_ReadMode_ColumnBin_4                     = 2'H2;

localparam  Register_ReadMode_RowBin_l                        = 2,
            Register_ReadMode_RowBin_w                        = 2,
            Register_ReadMode_RowBin_mask                     = (1<<2)-1,
            Register_ReadMode_RowBin_1                        = 2'H0,
            Register_ReadMode_RowBin_2                        = 2'H1,
            Register_ReadMode_RowBin_4                        = 2'H2;

localparam  Register_ReadMode_RowFlip_l                       = 4,
            Register_ReadMode_RowFlip_w                       = 1,
            Register_ReadMode_RowFlip_mask                    = 1,
            Register_ReadMode_RowFlip_Disable                 = 0,
            Register_ReadMode_RowFlip_Enable                  = 1;

localparam  Register_ReadMode_ColumnFlip_l                    = 5,
            Register_ReadMode_ColumnFlip_w                    = 1,
            Register_ReadMode_ColumnFlip_mask                 = 1,
            Register_ReadMode_ColumnFlip_Disable              = 0,
            Register_ReadMode_ColumnFlip_Enable               = 1;

localparam  Register_ReadMode_DarkRowsMode_l                  = 6,
            Register_ReadMode_DarkRowsMode_w                  = 1,
            Register_ReadMode_DarkRowsMode_mask               = 1,
            Register_ReadMode_DarkRowsMode_Disable            = 0,
            Register_ReadMode_DarkRowsMode_Enable             = 1;

localparam  Register_ReadMode_DarkColumnssMode_l              = 7,
            Register_ReadMode_DarkColumnssMode_w              = 1,
            Register_ReadMode_DarkColumnssMode_mask           = 1,
            Register_ReadMode_DarkColumnssMode_Disable        = 0,
            Register_ReadMode_DarkColumnssMode_Enable         = 1;

// High Dynamic Range ( aka Pixel Operation Mode) R0F

localparam  Register_HighDynamicRangeEnable_Enable_l          = 0,
            Register_HighDynamicRangeEnable_Enable_w          = 1,
            Register_HighDynamicRangeEnable_Enable_mask       = 1,
            Register_HighDynamicRangeEnable_Enable_Disable    = 0,
            Register_HighDynamicRangeEnable_Enable_Enable     = 1;

localparam  Register_HighDynamicRangeEnable_Color_l           = 1,
            Register_HighDynamicRangeEnable_Color_w           = 1,
            Register_HighDynamicRangeEnable_Color_mask        = 1,
            Register_HighDynamicRangeEnable_Color_Disable     = 0,
            Register_HighDynamicRangeEnable_Color_Enable      = 1;

localparam  Register_HighDynamicRangeEnable_Enable2Wot_l      = 6,
            Register_HighDynamicRangeEnable_Enable2Wot_w      = 1,
            Register_HighDynamicRangeEnable_Enable2Wot_mask   = 1,
            Register_HighDynamicRangeEnable_Enable2Wot_Disable= 0,
            Register_HighDynamicRangeEnable_Enable2Wot_Enable = 1;

localparam  Register_HighDynamicRangeEnable_EnableB_l         = 8,
            Register_HighDynamicRangeEnable_EnableB_w         = 1,
            Register_HighDynamicRangeEnable_EnableB_mask      = 1,
            Register_HighDynamicRangeEnable_EnableB_Disable   = 0,
            Register_HighDynamicRangeEnable_EnableB_Enable    = 1;

// Mystery Registers (from MT9V034-D.PDF)

localparam Register_Mystery13_DefaultWithNew20Default        = 16'H01C1;

// LED Out Control R1B

// ... note the inverted sense of the enable.  LedOut is enabled when Enable is cleared.
localparam  Register_LedOutControl_Enable_l                   = 0,
            Register_LedOutControl_Enable_w                   = 1,
            Register_LedOutControl_Enable_mask                = 1,
            Register_LedOutControl_Enable_Disable             = 1,
            Register_LedOutControl_Enable_Enable              = 0;

localparam  Register_LedOutControl_Invert_l                   = 1,
            Register_LedOutControl_Invert_w                   = 1,
            Register_LedOutControl_Invert_mask                = 1,
            Register_LedOutControl_Invert_Disable             = 0,
            Register_LedOutControl_Invert_Enable              = 1;

// ADC Resolution Control R1C

// ... values might be wrong, not clear in datasheet (P27)
localparam  Register_ADCResolutionControl_Companding_l        = 0,
            Register_ADCResolutionControl_Companding_w        = 1,
            Register_ADCResolutionControl_Companding_mask     = 1,
            Register_ADCResolutionControl_Companding_Disable  = 0,
            Register_ADCResolutionControl_Companding_Enable   = 1;

// ...new value gives better HDR mode performance when frame rate is low
localparam  Register_Mystery20_Default                        = 16'H01C1,
            Register_Mystery20_NewDefault                     = 16'H03C7,
            Register_Mystery20_NewDefaultWithLowShutterTime   = 16'H01C7,
            Register_Mystery20_DefaultWithShapshotHint        = 16'H01C5;

localparam  Register_Mystery20_CR_l                           = 2,
            Register_Mystery20_CR_w                           = 1,
            Register_Mystery20_CR_mask                        = 1,
            Register_Mystery20_CR_Disable                     = 0,
            Register_Mystery20_CR_Enable                      = 1;


localparam  Register_Mystery20_GlobalReset                    = 9,
            Register_Mystery20_GlobalReset_w                  = 1,
            Register_Mystery20_GlobalReset_mask               = 1,
            Register_Mystery20_GlobalReset_Disable            = 0,
            Register_Mystery20_GlobalReset_Enable             = 1;

// ... new value corrects negative dark offser when global reset R20[9] is enabled
localparam  Register_Mystery24_Default                        = 16'H0010,
            Register_Mystery24_NewDefault                     = 16'H001B;

localparam  Register_Mystery2B_Default                        = 16'H0004,
            Register_Mystery2B_NewDefault                     = 16'H0003;

localparam  Register_Mystery2F_Default                        = 16'H0004,
            Register_Mystery2F_NewDefault                     = 16'H0003;

// HDR Step Voltage (R31-R34)

// ... unclear when HDR step voltages are automatic
localparam  Register_StepVoltageN_l                           = 0,
            Register_StepVoltageN_w                           = 5,
            Register_StepVoltageN_mask                        = ((1<<5)-1);

// ADC Voltage Reference R2C

// Important to preserve the other bits in this register (all zeros in the default)
localparam  Register_ADCVoltageReference_Default              = 3'H4;

localparam  Register_ADCVoltageReference_Voltage_l            = 0,
            Register_ADCVoltageReference_Voltage_w            = 3,
            Register_ADCVoltageReference_Voltage_mask         = ((1<<3)-1),
            Register_ADCVoltageReference_Voltage_1_0V         = 0,
            Register_ADCVoltageReference_Voltage_1_1V         = 1,
            Register_ADCVoltageReference_Voltage_1_2V         = 2,
            Register_ADCVoltageReference_Voltage_1_3V         = 3,
            Register_ADCVoltageReference_Voltage_1_4V         = 4,
            Register_ADCVoltageReference_Voltage_1_6V         = 5,
            Register_ADCVoltageReference_Voltage_1_7V         = 6,
            Register_ADCVoltageReference_Voltage_2_1V         = 7;

// Global Gain Control 8'H35

localparam  Register_GlobalGainControl_l                      = 0,
            Register_GlobalGainControl_w                      = 7,
            Register_GlobalGainControl_mask                   = ((1<<7)-1),
            Register_GlobalGainControl_Enable                 = 1,
            Register_GlobalGainControl_Default                = 16;

// Black Level Calibration Control 8'H47
// .. On Semi Datasheet P25

localparam  Register_BlackLevelCalibControl_Manual_l          = 0,
            Register_BlackLevelCalibControl_Manual_w          = 1,
            Register_BlackLevelCalibControl_Manual_mask       = 1,
            Register_BlackLevelCalibControl_Manual_Disable    = 0,
            Register_BlackLevelCalibControl_Manual_Enable     = 1,
            Register_BlackLevelCalibControl_Manual_Default    = 0;

localparam  Register_BlackLevelCalibControl_LowPassFrameCount_l      = 5,
            Register_BlackLevelCalibControl_LowPassFrameCount_w      = 3,
            Register_BlackLevelCalibControl_LowPassFrameCount_mask = ((1<<3)-1),
            Register_BlackLevelCalibControl_LowPassFrameCount_Default = 4;


// Row Noise Constant 8'H72

localparam  Register_RowNoiseConstant_LineValid_l             = 2,
            Register_RowNoiseConstant_LineValid_w             = 2,
            Register_RowNoiseConstant_LineValid_mask          = (1<<2)-1,
            Register_RowNoiseConstant_LineValid_InFrame       = 2'H0,
            Register_RowNoiseConstant_LineValid_Continuous    = 2'H1,
            Register_RowNoiseConstant_LineValid_XORFrame      = 2'H2,
            Register_RowNoiseConstant_LineValid_Default       = 2'H0;

localparam  Register_RowNoiseConstant_InvertPixClk_l          = 4,
            Register_RowNoiseConstant_InvertPixClk_w          = 1,
            Register_RowNoiseConstant_InvertPixClk_mask       = 1,
            Register_RowNoiseConstant_InvertPixClk_Disable    = 0,
            Register_RowNoiseConstant_InvertPixClk_Enable     = 1;


// Pixel Clock Configuration 8'H74

localparam  Register_PixelClockFVLV_HSync_l                   = 0,
            Register_PixelClockFVLV_HSync_w                   = 1,
            Register_PixelClockFVLV_HSync_mask                = 1,
            Register_PixelClockFVLV_HSync_ActiveHigh          = 0,
            Register_PixelClockFVLV_HSync_ActiveLow           = 1,
            Register_PixelClockFVLV_HSync_Default             = 0;

localparam  Register_PixelClockFVLV_VSync_l                   = 1,
            Register_PixelClockFVLV_VSync_w                   = 1,
            Register_PixelClockFVLV_VSync_mask                = 1,
            Register_PixelClockFVLV_VSync_ActiveHigh          = 0,
            Register_PixelClockFVLV_VSync_ActiveLow           = 1,
            Register_PixelClockFVLV_VSync_Default             = 0;

localparam  Register_PixelClockFVLV_PCLKSample_l              = 4,
            Register_PixelClockFVLV_PCLKSample_w              = 1,
            Register_PixelClockFVLV_PCLKSample_mask           = 1,
            Register_PixelClockFVLV_PCLKSample_Falling        = 0,
            Register_PixelClockFVLV_PCLKSample_Rising         = 1,
            Register_PixelClockFVLV_PCLKSample_Default        = 0;

// Digital Test Pattern 8'7F

localparam  Register_DigitalTestPattern_TestData_l            = 0,
            Register_DigitalTestPattern_TestData_w            = 10,
            Register_DigitalTestPattern_TestData_mask         = ((1<<10)-1);

localparam  Register_DigitalTestPattern_UseTestData_l         = 10,
            Register_DigitalTestPattern_UseTestData_w         = 1,
            Register_DigitalTestPattern_UseTestData_mask      = 1,
            Register_DigitalTestPattern_UseTestData_Disable   = 0,
            Register_DigitalTestPattern_UseTestData_Enable    = 1;

localparam  Register_DigitalTestPattern_GrayShadeTestPattern_l          = 11,
            Register_DigitalTestPattern_GrayShadeTestPattern_w          = 2,
            Register_DigitalTestPattern_GrayShadeTestPattern_mask       = (1<<2)-1,
            Register_DigitalTestPattern_GrayShadeTestPattern_None       = 0,
            Register_DigitalTestPattern_GrayShadeTestPattern_Vertical   = 1,
            Register_DigitalTestPattern_GrayShadeTestPattern_Horizontal = 2,
            Register_DigitalTestPattern_GrayShadeTestPattern_Diagonal   = 3,
            Register_DigitalTestPattern_GrayShadeTestPattern_Default    = 0;

localparam  Register_DigitalTestPattern_Test_l                = 13,
            Register_DigitalTestPattern_Test_w                = 1,
            Register_DigitalTestPattern_Test_mask             = 1,
            Register_DigitalTestPattern_Test_Disable          = 0,
            Register_DigitalTestPattern_Test_Enable           = 1,
            Register_DigitalTestPattern_Test_Default          = 0;

localparam  Register_DigitalTestPattern_FlipTestData_l        = 14,
            Register_DigitalTestPattern_FlipTestData_w        = 1,
            Register_DigitalTestPattern_FlipTestData_mask     = 1,
            Register_DigitalTestPattern_FlipTestData_Disable  = 0,
            Register_DigitalTestPattern_FlipTestData_Enable   = 1,
            Register_DigitalTestPattern_FlipTestData_Default  = 0;

// AEC AGC Enable (8'HAF)

localparam  Register_AecAgcEnable_AEC_l                       = 0,
            Register_AecAgcEnable_AEC_w                       = 1,
            Register_AecAgcEnable_AEC_mask                    = 1,
            Register_AecAgcEnable_AEC_Disable                 = 0,
            Register_AecAgcEnable_AEC_Enable                  = 1,
            Register_AecAgcEnable_AEC_Default                 = 1;

localparam  Register_AecAgcEnable_AGC_l                       = 1,
            Register_AecAgcEnable_AGC_w                       = 1,
            Register_AecAgcEnable_AGC_mask                    = 1,
            Register_AecAgcEnable_AGC_Disable                 = 0,
            Register_AecAgcEnable_AGC_Enable                  = 1;

// Monitor Mode 8'HD9

localparam  Register_MonitorMode_Enable_l                     = 1,
            Register_MonitorMode_Enable_w                     = 1,
            Register_MonitorMode_Enable_mask                  = 1,
            Register_MonitorMode_Enable_Disable               = 0,
            Register_MonitorMode_Enable_Enable                = 1;


// Register Lock Register

localparam Register_RegisterLock_Lock                        = 16'HDEAD;
localparam Register_RegisterLock_Lock_ReadMode               = 16'HDEAF;
localparam Register_RegisterLock_Unlock                      = 16'HBEEF;

